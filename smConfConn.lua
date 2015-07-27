print("\nsmConfConn iniciada correctamente") --DEBUG

dofile("smAPConfData.lua") -- Set Station-AP mode and create SMARTIDEA-XX-YY WLAN

refreshTimeout = 15 -- Timeout for AP scan
availableAPs = {}

function getAPs_callback(t)
    if(t==nil) then
        availableAPs = nil
        return
    end
    availableAPs = nil
    availableAPs = t
    t = nil
end

function getAPs()
    print(collectgarbage("count")*1024.."KB") -- Show used memory in KB
    print ("Buscando APs...") --DEBUG
    wifi.sta.getap(1, getAPs_callback)
end

function sendAPlistPage(conn)
    print ("\n\nEnviando web de configuracion!") --DEBUG
    local webPage = 'HTTP/1.1 200 OK\n<!DOCTYPE HTML>\n<html><head><meta content="text/html; charset=utf-8">\n<title>SmartWiFi</title></head>\n<body>\n<form action="/" method="POST">\n<br/>\nSelecciona tu WLAN:<br/><br/>\n'
    for ap,v in pairs(availableAPs) do
        local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
        webPage = webPage..'<input type="button" onClick=\'document.getElementById("ssid").value = "'..ssid..'"\' value="'..ssid..'"/><br/>Potencia: '..rssi..' Canal: '..channel..' Seguridad: '..authmode..' MAC: '..ap..'<br/>\n'
    end
    webPage = webPage..'SSID:<input type="text" id="ssid" name="ssid" value=""><br/>\nPassword:<input type="text" name="passwd" value=""><br/>\n'
    webPage = webPage..'<input type="button" onClick="window.location.reload()" value="Refrescar"/>\n<input type="submit" name="reboot" value="Conectar"/>\n</form>\n</body>\n</html>'
    conn:send(webPage)
    conn:close()
    webPage = nil
end

function url_decode(str)
    local s = string.gsub (str, "+", " ")
    s = string.gsub (s, "%%(%x%x)",
        function(h) return string.char(tonumber(h,16)) end)
    s = string.gsub (s, "\r\n", "\n")
    return s
end

function incomingConnection(conn, payload)
    print ("\n\nConexion HTTP recibida!") --DEBUG
    if (string.find(payload, "GET /favicon.ico HTTP/1.1") ~= nil) then
        print("\nGET favicon solicitado") --DEBUG
    elseif (string.find(payload, "GET / HTTP/1.1") ~= nil) then
        print("\nGET recibido") --DEBUG
        sendAPlistPage(conn)
    else
        print("\nPOST recibido") --DEBUG
        local blank, plStart = string.find(payload, "\r\n\r\n");
        if(plStart == nil) then
            return
        end
        payload = string.sub(payload, plStart+1)
        local args={}
        args.passwd=""
        -- parseamos todos las variables POST en la tabla args[]
        for k,v in string.gmatch(payload, "([^=&]*)=([^&]*)") do
            args[k]=url_decode(v)
        end
        if(args.ssid ~= nil and args.ssid ~= "") then
            print("Nueva SSID: " .. args.ssid) --DEBUG
            print("Password: " .. args.passwd) --DEBUG
            wifi.sta.config(args.ssid, args.passwd)
        end
        if(args.reboot ~= nil) then
            print("Reiniciando") --DEBUG
            conn:send('HTTP/1.1 200 OK\n\n<!DOCTYPE HTML>\n<html>\n<head><meta content="text/html; charset=utf-8">\n<title>'.. args.ssid ..'</title></head>\n<body>\n\n<br/>Conectando a: '.. args.ssid ..'\n</body></html>')
            conn:close()
            node.restart()
        end
        conn:send('HTTP/1.1 303 See Other\n')
        conn:send('Location: /\n')
    end
end

getAPs() -- Search for APs before setting timed search

tmr.alarm(0, refreshTimeout*1000, 1, getAPs) -- Timed search based on refreshTimeout var

-- Start Web Server and handle incomming requests
srv=net.createServer(net.TCP)
srv:listen(80,function(sock)
  sock:on("receive", incomingConnection)
  sock:on("sent", function(sock) 
    sock:close()
  end)
end)

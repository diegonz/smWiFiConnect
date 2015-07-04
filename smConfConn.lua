-- Establecemos modo AP
dofile("smAPConfData.lua")

-- Timeout de escaneo de redes disponibles
refreshTimeout = 15
availableAPs = {}
newssid = ""

function getAPs_callback(t)
    if(t==nil) then
        return
    end
    availableAPs = nil
    availableAPs = t
end

function getAPs()
    print ("Buscando APs...") --DEBUG
    wifi.sta.getap(getAPs_callback)
end

function sendAPlistPage(conn)
    print ("\n\nEnviando web de configuracion!") --DEBUG
    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n<html>\n<head><meta content="text/html; charset=utf-8">\n<title>Conectar a red WiFi</title></head>\n<body>\n<form action="/" method="POST">\n')
    --if(newssid ~= "") then
    --    conn:send('<br/>Tras reiniciar, conectar al SSID "' .. newssid ..'".\n')
    --end
    conn:send('<br/><br/>\n\n<table>\n<tr><th>Selecciona el SSID de la red:</th></tr>\n')
    for ap,v in pairs(availableAPs) do
        conn:send('<tr><td><input type="button" onClick=\'document.getElementById("ssid").value = "' .. ap .. '"\' value="' .. ap .. '"/></td></tr>\n')
    end
    conn:send('</table>\n\nSSID: <input type="text" id="ssid" name="ssid" value=""><br/>\nPassword: <input type="text" name="passwd" value=""><br/>\n\n')
    conn:send('<input type="submit" value="Submit"/>\n<input type="button" onClick="window.location.reload()" value="Refresh"/>\n<br/>\n<input type="submit" name="reboot" value="Conectar"/>\n')
    conn:send('</form>\n</body></html>')
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
        print("GET favicon solicitado") --DEBUG
    elseif (string.find(payload, "GET / HTTP/1.1") ~= nil) then
        print("GET recibido") --DEBUG
        sendAPlistPage(conn)
    else
        print("POST recibido") --DEBUG
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
            newssid = args.ssid
            wifi.sta.config(args.ssid, args.passwd)
        end
        if(args.reboot ~= nil) then
            print("Reiniciando") --DEBUG
            conn:close()
            node.restart()
        end
        conn:send('HTTP/1.1 303 See Other\n')
        conn:send('Location: /\n')
    end
end

getAPs() -- lanzamos la busqueda de redes antes de establecer el timer

tmr.alarm(0, refreshTimeout*1000, 1, getAPs) -- actualizamos la lista de redes en base al refreshTimeout

-- arrancamos servidor web y procesamos las peticiones
srv=net.createServer(net.TCP)
srv:listen(80,function(sock)
  sock:on("receive", incomingConnection)
  sock:on("sent", function(sock) 
    sock:close()
  end)
end)

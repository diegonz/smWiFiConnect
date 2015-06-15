dofile("smAPConfData.lua")

refreshTimeout = 15 -- timeout de escaneo de redes disponibles
availableAPs = {}
newssid = ""

function getAPs_callback(t)
  if(t==nil) then
    return
  end
  availableAPs = t
end

function getAPs()
  wifi.sta.getap(getAPs_callback)
end

function sendAPlistPage(conn)
  conn:send('HTTP/1.1 200 OK\n\n')
  conn:send('<!DOCTYPE HTML>\n<html>\n<head><meta content="text/html; charset=utf-8">\n<title>SMARTIDEA - Conectar a una red WiFi</title></head>\n<body>\n<form action="/" method="POST">\n')

  if(lastStatus ~= nil) then
    conn:send('<br/>Estado anterior de la red: ' .. lastStatus ..'\n')
  end
  
  if(newssid ~= "") then
    conn:send('<br/>Tras reiniciar, conectar al SSID "' .. newssid ..'".\n')
  end
    
  conn:send('<br/><br/>\n\n<table>\n<tr><th>Selecciona el SSID de la red:</th></tr>\n')

  for ap,v in pairs(availableAPs) do
    conn:send('<tr><td><input type="button" onClick=\'document.getElementById("ssid").value = "' .. ap .. '"\' value="' .. ap .. '"/></td></tr>\n')
  end
  
  conn:send('</table>\n\nSSID: <input type="text" id="ssid" name="ssid" value=""><br/>\nPassword: <input type="text" name="passwd" value=""><br/>\n\n')
  conn:send('<input type="submit" value="Submit"/>\n<input type="button" onClick="window.location.reload()" value="Refresh"/>\n<br/>If you\'re happy with this...\n<input type="submit" name="reboot" value="Conectar"/>\n')
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
  if (string.find(payload, "GET /favicon.ico HTTP/1.1") ~= nil) then
    print("GET favicon request")
  elseif (string.find(payload, "GET / HTTP/1.1") ~= nil) then
    print("GET received")
    sendAPlistPage(conn)
  else
    print("POST received")
    local blank, plStart = string.find(payload, "\r\n\r\n");
    if(plStart == nil) then
      return
    end
    payload = string.sub(payload, plStart+1)
    args={}
    args.passwd=""
    
    for k,v in string.gmatch(payload, "([^=&]*)=([^&]*)") do -- parseamos todos las variables POST en la tabla args[]
      args[k]=url_decode(v)
    end
    if(args.ssid ~= nil and args.ssid ~= "") then
      print("Nueva SSID: " .. args.ssid)
      print("Password: " .. args.passwd)
      newssid = args.ssid
      wifi.sta.config(args.ssid, args.passwd)
    end
    if(args.reboot ~= nil) then
      print("Reiniciando")
      conn:close()
      node.restart()
    end
    conn:send('HTTP/1.1 303 See Other\n')
    conn:send('Location: /\n')
  end
end

tmr.alarm(0, refreshTimeout*1000, 1, getAPs) -- actualizamos la lista de redes en base al refreshTimeout
getAPs() -- forzamos la carga de la lista de redes la primera vez
  
srv=net.createServer(net.TCP) -- arrancamos el servidor web
srv:listen(80,function(sock)
  sock:on("receive", incomingConnection) -- procesamos las peticiones
  sock:on("sent", function(sock) 
    sock:close()
  end)
end)
function incConnDimmer(conn) -- devolvemos una respuesta 
    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n<html>\n<head><meta content="text/html; charset=utf-8">\n<title>SMARTIDEA - SmartDimmer</title></head>\n<body>\n\n')
    conn:send('\n<h1>SmartDimmer</h1>')
    ssid, password, bssid_set, bssid=wifi.sta.getconfig()
    conn:send('\n\n\n<br />Conectado correctamente a la red WiFi :' .. ssid)
    conn:send('<br />BSSID :' .. bssid)
    conn:send('<br />BSSID_SET :' .. bssid_set)
    conn:send('<br />Password :' .. password)
    ssid, password, bssid_set, bssid=nil, nil, nil, nil
    ip = wifi.sta.getip()
    conn:send('<br />Dirección IP:' .. ip)
    ip = nil
    conn:send('\n</body></html>')
end

srv=net.createServer(net.TCP) -- arrancamos servidor web
srv:listen(80,function(sock)
    sock:on("receive", incConnDimmer) -- procesamos las peticiones
    sock:on("sent", function(sock) 
        sock:close()
    end)
end)
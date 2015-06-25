print("SmartApp iniciada correctamente") --DEBUG
function incConnDimmer(conn)
    print ("\n\nConexion HTTP recibida!") --DEBUG
    conn:send('HTTP/1.1 200 OK\n\n')
    conn:send('<!DOCTYPE HTML>\n<html>\n<head><meta content="text/html; charset=utf-8">\n<title>SMARTIDEA - SmartDimmer</title></head>\n<body>\n\n')
    conn:send('\n<h1>SmartDimmer</h1>')
    conn:send('\n\n\n<br />Conectado correctamente a la red WiFi')
    local ip = wifi.sta.getip()
    conn:send('<br />Direccion IP:' .. ip)
    conn:send('\n</body></html>')
end

srv=net.createServer(net.TCP)
-- arrancamos servidor web y procesamos las peticiones
srv:listen(80,function(sock)
    sock:on("receive", incConnDimmer)
    sock:on("sent", function(sock) 
        sock:close()
    end)
end)

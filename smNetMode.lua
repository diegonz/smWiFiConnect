print("SmNetMode iniciada correctamente") --DEBUG
srvHost="" -- IP del servidor

function checkWAN()
    local wan=net.createConnection(net.TCP, 0)
    wan:dns("www.smartidea.es",function(conn,ip)
        print(ip)
        if (ip~=nil) then
            --srvHost=ip -- IP del servidor WAN
            srvHost="192.168.1.107"
        else
            srvHost="192.168.1.107"
        end
        print(srvHost)
    end)
    wan = nil
end

--checkWAN() -- Comprobamos la conexión WAN
srvHost="192.168.1.107"
smsk=net.createConnection(net.TCP,0)
smsk:on("receive",function(smsk,stringBuffer)
    if (stringBuffer=="HOLA\n") then
        print(stringBuffer) --DEBUG
        smsk:send("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13).."\n")
        print("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) --DEBUG
    elseif (stringBuffer=="OK\n") then
        print(stringBuffer) --DEBUG
    elseif (stringBuffer=="QUIT\r\n") then
        smsk:close()
        print("Conexion finalizada") --DEBUG
    else
        --print(stringBuffer) --DEBUG
        print("OTROS") --DEBUG
    end

end)
smsk:connect(2525,srvHost)

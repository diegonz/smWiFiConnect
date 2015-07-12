print("\nsmNetMode iniciada correctamente") --DEBUG

function checkWAN()
    local wan=net.createConnection(net.TCP, 0)
    wan:dns("www.smartidea.es",function(conn,ip)
        print(ip) -- IP del servidor WAN
        if (ip~=nil) then
            srvHost=ip -- IP del servidor WAN
            srvHost="192.168.1.107"
        else
            -- Aqui se lanzara el checkeo/escucha en LAN en caso de no haber WAN
            srvHost="192.168.1.107"
        end
        print("\n"..srvHost)
    end)
    wan = nil
end
checkWAN()
print("\nsmNetMode iniciada correctamente") --DEBUG

function checkWAN()
    local oldNetMode = netMode
    local wan=net.createConnection(net.TCP, 0)
    wan:dns("www.smartidea.es",function(conn,ip)
        print(ip) -- IP del servidor WAN
        if (ip~=nil) then
            srvHost=ip -- IP del servidor WAN
            netMode = 2 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN
        else
            netMode = 1 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN
        end
        print("\nIP servidor :"..srvHost)
        --srvHost="192.168.1.107" -- HARDCODE SERVER IP
    end)
    wan = nil
    print(collectgarbage("count")*1024.."KB") -- Mostramos la memoria usada en KB
    -- Si ha cambiado el tipo de conectividad reiniciamos para empezar de 0
    if (oldNetMode~=netMode and oldNetMode~=0) then node.restart() end
end
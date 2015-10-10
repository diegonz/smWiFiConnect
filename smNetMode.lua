local smNetMode = {}

function smNetMode.checkWAN()
    print("\nsmNetMode llamada correctamente") --DEBUG
    local oldNetMode = netMode
    local wan=net.createConnection(net.TCP, 0)
    wan:dns("testingserver.smartidea.es",function(conn, ip)
        print(ip) -- WAN's Server IP
        if (ip~=nil) then
            srvHost = ip -- WAN's Server IP
            netMode = 2 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN
        else
            netMode = 1 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN
        end
        print("\nIP servidor :"..srvHost)
    end)
    wan = nil
    print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB

    -- If netMode has changed (not first try) or no WLAN restart system.
    if ((oldNetMode~=netMode and oldNetMode~=0) or (netMode==0)) then node.restart() end
end

return smNetMode

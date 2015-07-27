print("\nsmDimmer iniciada correctamente") --DEBUG
testWAN = require "smNetMode"

-- Launch service depending on WAN status
if (netMode==2) then
    local wanHandler = require "smWanHandler"
    local smSk=net.createConnection(net.TCP,0)
    smSk:on("receive", function(sock, stringBuffer)
        wanHandler.incWanConn(sock, stringBuffer)
    end)
    smSk:connect(2525, srvHost)
elseif (netMode==1) then
    local lanHandler = require "smLanHandler"
    local smSrv=net.createServer(net.TCP)
    smSrv:listen(2525, function(sock)
        sock:on("receive", function(sock, stringBuffer)
            lanHandler.incLanConn(sock, stringBuffer)
        end)
    end)
elseif (netMode==0) then
    node.restart()
else
    testWAN.checWAN()
end

-- Periodically test WAN status
tmr.alarm(0, 90*1000, 1, testWAN.checkWAN())
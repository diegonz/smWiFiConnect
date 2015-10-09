print("\nsmDimmer iniciada correctamente") --DEBUG

local notLoggedIn = true
local srvPort = 8992

-- Require modules
testWAN = require "smNetMode"

-- Launch service depending on WAN status
if ( netMode == 2 ) then
    local wanHandler = require "smWanHandler"
    local wanAuthHandler = require "smWanAuthHandler"
    local smSrv=net.createConnection(net.TCP, 0)
    smSrv:on("receive", function(sock, stringBuffer)
        if notLoggedIn then
            wanAuthHandler.wanAuthHandler(sock, notLoggedIn)
        else
            wanHandler.incWanData(sock, stringBuffer, notLoggedIn)
            if notLoggedIn then
                wanAuthHandler.wanAuthHandler(sock, notLoggedIn)
            end
        end
    end)
    smSrv:connect(srvPort, srvHost)
elseif (netMode == 1) then
    local lanHandler = require "smLanHandler"
    local smSrv=net.createServer(net.TCP)
    smSrv:listen(srvPort, function(sock)
        sock:on("receive", function(sock, stringBuffer)
            lanHandler.incLanData(sock, stringBuffer)
        end)
    end)
elseif (netMode == 0) then
    node.restart()
else
    testWAN.checWAN(notLoggedIn)
end

-- Configure UART
--if ((uart.setup( 0, 115200, 8, 0, 1, 0 )) == 115200) then
--  local uartHandler = require "smUARTHandler"
--  -- Register UART callback on data received, each 5 characters
--  uart.on("data", 5, function(data)
--    uartHandler.incUartData(data)
--  end, 0)
--else
--  smSrv:send("{deviceID:SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)..",smCommand:picdata,smData:ERROR UART}") --DEBUG --Hardcoded JSON error.
--end

-- Periodically test WAN status
tmr.alarm(0, 90*1000, 1, testWAN.checkWAN(notLoggedIn))

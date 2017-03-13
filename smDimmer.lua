print("\nsmDimmer successfully started") --DEBUG

local srvPort = 8992

-- Require modules
testWAN = require "smNetMode"

-- Configure UART
--if ((uart.setup( 0, 115200, 8, 0, 1, 0 )) == 115200) then
--  local uartHandler = require "smUARTHandler"
--  -- Register UART callback on data received, each 5 characters
--  uart.on("data", 5, function(data)
--    uartHandler.incUartData(data)
--  end, 0)
--else
--  smSrv:send(UART_ERROR)-- TODO SENDS UART ERROR TO THE SERVER
--  node.restart()
--end

-- Launch service depending on WAN status
if ( netMode == 2 ) then
    local wanHandler = require "smWanHandler"
    local wanAuthHandler = require "smWanAuthHandler"
    local smSrv=net.createConnection(net.TCP, 0)
    smSrv:on("receive", function(sock, stringBuffer)
        if (stringBuffer=="RQ_AUTH\n") then
            wanAuthHandler.wanAuthHandler(sock)
        else
            wanHandler.incWanData(sock, stringBuffer)
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
    testWAN.checWAN()
end

-- Periodically test WAN status
tmr.alarm(0, 90 * 1000, 1, testWAN.checkWAN())

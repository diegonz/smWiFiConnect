conTimeout = 10 -- Timeout before changing to StationAP mode

timeoutCount = 0
srvHost = "" -- WAN's Server IP
netMode = 0 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN

function netStatus()
    print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB
    timeoutCount = timeoutCount + 1
    local s=wifi.sta.status()
    if(s==5) then -- Connected, launching smApp
        netMode=1
        local ip = wifi.sta.getip()
        print('Conectado correctamente - (status 5)') --DEBUG
        print('\nDireccion IP: ' .. ip) --DEBUG
        doTask()
        return
    elseif(s == 2 or s == 3 or s == 4) then -- Connection error, switching to StationAP mode
        netMode=0
        print('\nFallo al conectar - (status 2/3/4)') --DEBUG
        doConfConn()
        return
    end
    if(timeoutCount >= conTimeout) then -- Timed out, switching to StationAP mode
        netMode=0
        print('\nTimeout al conectar!') --DEBUG
        doConfConn()
        return
    end
end

function doTask()
    -- Check for WAN status
    local wanStatus = require "smNetMode"
    wanStatus.checkWAN()
    wanStatus = nil
    doCleanup()
    dofile('smDimmer.lua')
    print("\nModo de red actual: "..netMode)
    print("\n0 -> NoWLAN, 1 -> LAN, 2 -> WAN\n Reiniciando...")
    node.restart()
end

function doConfConn()
    print('\nRed WiFi no conectada/encontrada, lanzando modo AP ') --DEBUG
    doCleanup()

    -- Can't connect/find network, switching to StationAP mode
    dofile('smConfConn.lua')
end

function doCleanup()
    print("\nSacando la basura...") --DEBUG
    -- stop timers
    tmr.stop(0)
    -- reset global variables
    conTimeout = nil
    timeoutCount = nil
    -- reset useless functions
    netStatus = nil
    doTask = nil
    doConfConn = nil
    doCleanup = nil
    -- call to garbage collector
    collectgarbage("collect")
    print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB
end

-- Set Station mode and try to auto-connect
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)

-- Chech network status every second
tmr.alarm(0, 1000, 1, netStatus)

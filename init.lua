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
        print('Successfully connected - (status 5)') --DEBUG
        print('\nIP Address: ' .. ip) --DEBUG
        doTask()
        return
    elseif(s == 2 or s == 3 or s == 4) then -- Connection error, switching to StationAP mode
        netMode=0
        print('\nFailed to connect - (status 2/3/4)') --DEBUG
        doConfConn()
        return
    end
    if(timeoutCount >= conTimeout) then -- Timed out, switching to StationAP mode
        netMode=0
        print('\nConnection timeout!') --DEBUG
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
    print("\nCurrent net mode: "..netMode)
    print("\n0 -> NoWLAN, 1 -> LAN, 2 -> WAN\n Rebooting...")
    node.restart()
end

function doConfConn()
    print('\nWiFi network not reachable, starting AP mode') --DEBUG
    doCleanup()

    -- Can't connect/find network, switching to StationAP mode
    dofile('smConfConn.lua')
end

function doCleanup()
    print("\nTaking out the trash...") --DEBUG
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

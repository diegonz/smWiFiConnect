conTimeout = 10 -- timeout antes de cambiar a modo AP

timeoutCount = 0
srvHost="" -- IP del servidor
netMode = 0 -- 0 -> NoWLAN, 1 -> LAN, 2 -> WAN

function netStatus()
    timeoutCount = timeoutCount + 1
    local s=wifi.sta.status()
    if(s==5) then -- conectado, lanzamos la smApp
        netMode=1
        local ip = wifi.sta.getip()
        print('Conectado correctamente - (status 5)') --DEBUG
        print('\nDireccion IP: ' .. ip) --DEBUG
        checkNetMode()
        return
    elseif(s==2 or s==3 or s==4) then -- conexion fallida, cambiamos a modo AP
        netMode=0
        print('\nFallo al conectar - (status 2/3/4)') --DEBUG
        confConn()
        return
    end
    if(timeoutCount >= conTimeout) then -- agotado el tiempo cambiamos a modo AP
        netMode=0
        print('\nTimeout al conectar!') --DEBUG
        confConn()
        return
    end
end

function checkNetMode()
    doCleanup()
    dofile('smNetMode.lua')
    dofile('smDimmer.lua')
    print("\nModo de red actual: "..netMode)
    print("\n0 -> NoWLAN, 1 -> LAN, 2 -> WAN\n Reiniciando...")
    node.restart()
end

function confConn()
    print('\nRed WiFi no conectada/encontrada, lanzando modo AP ') --DEBUG
    doCleanup()
    -- red no conectada/encontrada, cambiando a modo AP
    dofile('smConfConn.lua')
end

function doCleanup()
    print("\nSacando la basura...") --DEBUG
    -- paramos el timer
    tmr.stop(0)
    -- reseteamos con nil las variables globales
    conTimeout = nil
    timeoutCount = nil
    -- reseteamos con nil las funciones definidas
    netStatus = nil
    checkNetMode = nil
    confConn = nil
    doCleanup = nil
    -- llamamos al recolector de basura
    collectgarbage()
    -- hacemos un delay (ms) para esperar a que se libere memoria
    --tmr.delay(3000)
end

-- Establecemos modo cliente e intentamos autoconectar
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)

-- Comprobamos el estado de la red cada segundo
tmr.alarm(0, 1000, 1, netStatus)

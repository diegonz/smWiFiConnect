conTimeout = 10 -- timeout antes de cambiar a modo AP

timeoutCount = 0

function netStatus()
    timeoutCount = timeoutCount + 1
    local s=wifi.sta.status()
    if(s==5) then -- conectado, lanzamos la smApp
        local ip = wifi.sta.getip()
        print('Conectado correctamente - (status 5)') --DEBUG
        print('\n\nDireccion IP: ' .. ip) --DEBUG
        smartideaApp()
        return
    elseif(s==2 or s==3 or s==4) then -- conexion fallida, cambiamos a modo AP
        print('Fallo al conectar - (status 2/3/4)') --DEBUG
        confConn()
        return
    end
    if(timeoutCount >= conTimeout) then -- agotado el tiempo cambiamos a modo AP
        print('Timeout al conectar!') --DEBUG
        confConn()
        return
    end
end

function smartideaApp()
    doCleanup()
    dofile('smDimmer.lua')
end

function confConn()
    print('Red WiFi no conectada/encontrada, lanzando modo AP ') --DEBUG
    doCleanup()
    -- red no conectada/encontrada, cambiando a modo AP
    dofile('smConfConn.lua')
end

function doCleanup()
    print("Sacando la basura...") --DEBUG
    -- paramos el timer
    tmr.stop(0)
    -- reseteamos con nil las variables globales
    conTimeout = nil
    timeoutCount = nil
    -- reseteamos con nil las funciones definidas
    netStatus = nil
    smartideaApp = nil
    confConn = nil
    doCleanup = nil
    -- llamamos al recolector de basura
    collectgarbage()
    -- hacemos un delay (ms) para esperar a que se libere memoria
    tmr.delay(3000)
end

-- Establecemos modo cliente e intentamos autoconectar
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)

-- Comprobamos el estado de la red cada segundo
tmr.alarm(0, 1000, 1, netStatus)

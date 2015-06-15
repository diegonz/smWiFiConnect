conTimeout = 30 -- timeout antes de cambiar a modo AP

timeoutCount = 0
function netStatus()
  timeoutCount = timeoutCount + 1
  local s=wifi.sta.status()
  if(s==5) then -- conectado, lanzamos la smApp
    smartideaApp()
    return
  elseif(s==2 or s==3 or s==4) then -- conexion fallida, cambiamos a modo AP
    confConnection()
    return
  end
  if(timeoutCount >= conTimeout) then -- agotado el tiempo cambiamos a modo AP
    confConnection()
    return
  end
end

function smartideaApp()
  doCleanup()
  local smApp = 'smDimmer.lua'
  local smFile=file.open(smApp, 'r')
  if(smFile == nil) then -- no se encuentra el fichero
    print('Error al acceder al archivo la SMARTIDEA App: ' .. smApp)
    return
  end
  smFile.close()
  dofile(smApp)
end

function confConnection()
  lastStatus = statuses[wifi.sta.status()]
  doCleanup()
  dofile('smConfCon.lua') -- red no encontrada, cambiando a modo AP
end

function doCleanup()
  -- paramos el timer
  tmr.stop(0)
  -- reseteamos con nil las variables globales
  conTimeout = nil
  statuses = nil
  timeoutCount = nil
  -- reseteamos con nil las funciones definidas
  netStatus = nil
  smartideaApp = nil
  confConnection = nil
  doCleanup = nil
  -- llamamos al recolector de basura
  collectgarbage()
  -- hacemos un delay para esperar a que se libere memoria
  tmr.delay(5000)
end

-- establecemos modo cliente e intentamos autoconectar
wifi.setmode(wifi.STATION)
wifi.sta.autoconnect(1)

-- comprobamos el estado de la red cada segundo
tmr.alarm(0, 1000, 1, netStatus)
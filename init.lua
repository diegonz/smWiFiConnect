conTimeout = 10 -- timeout antes de cambiar a modo AP

timeoutCount = 0
function netStatus()
  timeoutCount = timeoutCount + 1
  local s=wifi.sta.status()
  if(s==5) then -- conectado, lanzamos la smApp
	print('Conectado correctamente - (status 5)')
    smartideaApp()
    return
  elseif(s==2 or s==3 or s==4) then -- conexion fallida, cambiamos a modo AP
	print('Fallo al conectar - (status 2/3/4)')
    confConn()
    return
  end
  if(timeoutCount >= conTimeout) then -- agotado el tiempo cambiamos a modo AP
	print('Timeout al conectar!')
    confConn()
    return
  end
end

function smartideaApp()
  ip = wifi.sta.getip()
  print('Conectado correctamente a la red WiFi con IP: ' .. ip)
  doCleanup()
  dofile('smDimmer.lua')
end

function confConn()
  print('Red WiFi no conectada/encontrada, lanzando modo AP ')
  doCleanup()
  dofile('smConfConn.lua') -- red no conectada/encontrada, cambiando a modo AP
end

function doCleanup()
  -- paramos el timer
  tmr.stop(0)
  -- reseteamos con nil las variables globales
  conTimeout = nil
  timeoutCount = nil
  -- reseteamos con nil las funciones definidas
  netStatus = nil
  smartideaApp = nil
  confConn = nil
  ip = nil
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

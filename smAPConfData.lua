local apNetConfig = {}
apNetConfig = {ip      = "192.168.4.1", -- NodeMCU predefine las IPs en el rango 192.168.4.x , forzamos dicho rango por seguridad.
               netmask = "255.255.255.0",
               gateway = "192.168.4.1"}
wifi.setmode(wifi.STATIONAP) -- cambiamos a modo STATION + AP
local apSsidConfig = {}
apSsidConfig.ssid = "SMARTIDEA-" .. string.sub(wifi.ap.getmac(),13) -- El SSID del AP SMARTIDEA-XX-YY, "-XX-YY" son los ultimos cuatro elementos de la MAC
wifi.ap.config(apSsidConfig)
wifi.ap.setip(apNetConfig)
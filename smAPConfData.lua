print("\nsmAPConfConn iniciada correctamente") --DEBUG

-- NodeMCU predefine las IPs en el rango 192.168.4.x , forzamos dicho rango por seguridad.
local apNetConfig = {
    ip      = "192.168.4.1",
    netmask = "255.255.255.0",
    gateway = "192.168.4.1"
}
wifi.setmode(wifi.STATIONAP)
-- El SSID del AP SMARTIDEA-XX-YY, "-XX-YY" son los ultimos cuatro elementos de la MAC
local apSsidConfig.ssid = "SMARTIDEA-"..string.sub(wifi.ap.getmac(), 13)
wifi.ap.config(apSsidConfig)
wifi.ap.setip(apNetConfig)
print("AP con SSID: "..apSsidConfig.ssid.." establecido.") --DEBUG
apNetConfig, apSsidConfig = nil, nil
print(collectgarbage("count") * 1024 .. "KB") -- Mostramos la memoria usada en KB
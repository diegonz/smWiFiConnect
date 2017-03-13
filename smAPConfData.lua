print("\nsmAPConfConn successfully started") --DEBUG

-- NodeMCU predefines IPs at 192.168.4.x range anyway.
local apNetConfig = {
    ip      = "192.168.4.1",
    netmask = "255.255.255.0",
    gateway = "192.168.4.1"
}
wifi.setmode(wifi.STATIONAP)
-- SSID of AP SMART-XX-YY, "-XX-YY" are the last four elements of the MAC address.
local apSsidConfig.ssid = "SMART-"..string.sub(wifi.ap.getmac(), 13)
wifi.ap.config(apSsidConfig)
wifi.ap.setip(apNetConfig)
print("AP with SSID: "..apSsidConfig.ssid.." established.") --DEBUG
apNetConfig, apSsidConfig = nil, nil
print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB
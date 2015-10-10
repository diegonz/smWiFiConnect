local lanHandler = {}

function lanHandler.incLanData (smSrv,stringBuffer)

    local recData, respData = cjson.decode(stringBuffer), {}
    respData["deviceID"] = "SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)
    if (recData["deviceID"] == "SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) then
        if (recData["smCommand"] == "send") then
            uart.write(0,string.char(tonumber(respData["smData"]))) -- SEND DATA (CHAR OF BYTE VALUE) TO UART - *ACCEPTS ONLY ONE COMMAND
            --uart.write(0,string.byte(respData["smData"])) -- SEND DATA (BYTE VALUE OF CHAR) TO UART  *ACCEPTS ONLY ONE COMMAND*
        elseif (recData["smCommand"] == "print") then
          if (recData["smData"]~=nil) then
              print("Received DATA: "..recData["smData"]) -- DEBUG
              respData["smCommand"], respData["smData"] = recData["smCommand"], recData["smData"]
              smSrv:send(cjson.encode(respData))
          else
              respData["smCommand"], respData["smData"] = recData["smCommand"], "DATA ERROR"
              smSrv:send(cjson.encode(respData))
              print("Error, no data not received!") -- DEBUG
          end
        elseif (recData["smCommand"] == "restart") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], "Rebooting..."
            smSrv:send(cjson.encode(respData))
            print("Rebooting...") --DEBUG
            node.restart()
        elseif (recData["smCommand"] == "getip") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], wifi.sta.getip()
            smSrv:send(cjson.encode(respData))
            print("IP address sent") --DEBUG
        elseif (recData["smCommand"] == "getmac") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], wifi.ap.getmac()
            smSrv:send(cjson.encode(respData))
            print("MAC address sent") --DEBUG
        elseif (recData["smCommand"] == "getwlancfg") then
            respData["smCommand"] = recData["smCommand"]
            respData["smData"]["ssid"], respData["smData"]["password"], respData["smData"]["bssid_set"],respData["smData"]["bssid"] = wifi.sta.getconfig()
            smSrv:send(cjson.encode(respData))
            print("WLAN config sent") --DEBUG
        else
            respData["smCommand"], respData["smData"] = recData["smCommand"], "COMMAND ERROR"
            smSrv:send(cjson.encode(respData))
            print("COMMAND ERROR\r\n") --DEBUG
        end
    elseif (recData["deviceID"] == "getdeviceid") then
        respData["smCommand"], respData["smData"] = recData["deviceID"] ,respData["deviceID"]
        smSrv:send(cjson.encode(respData))
        print("DEVICE-ID sent!") --DEBUG
    else
        respData["deviceID"], respData["smCommand"], respData["smData"] = "DEVICE-ID ERROR", "DEVICE-ID ERROR", "DEVICE-ID ERROR"
        smSrv:send(cjson.encode(respData))
        print("DEVICE-ID ERROR!") --DEBUG
    end
    print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB
    respData, recData = nil, nil -- Free up some memory
    print(collectgarbage("count") * 1024 .. "KB") -- Show used memory in KB
end

return lanHandler

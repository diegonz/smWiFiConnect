print("\nsmDimmer iniciada correctamente") --DEBUG

function receiveData (smSk,stringBuffer)
    if (stringBuffer=="HOLA\n") then
        print(stringBuffer) --DEBUG
        smSk:send("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13).."\n")
        print("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) --DEBUG
    elseif (stringBuffer=="OK\n") then
        print(stringBuffer) --DEBUG
    elseif (stringBuffer=="QUIT\r\n") then
        smSk:close()
        print("Conexion finalizada") --DEBUG
    else
        print(stringBuffer) --DEBUG
    end
end

function incLanConn (smSrv,stringBuffer)

    local recData, respData = cjson.decode(stringBuffer), {}
    respData["deviceID"] = "SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)
    if (recData["deviceID"]=="SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) then
        if (recData["smCommand"]=="print") then
            if (recData["smData"]~=nil) then
                print("Received DATA: "..recData["smData"]) -- DEBUG
                respData["smCommand"], respData["smData"] = recData["smCommand"], recData["smData"]
                smSrv:send(cjson.encode(respData))
            else
                respData["smCommand"], respData["smData"] = recData["smCommand"], "DATA ERROR"
                smSrv:send(cjson.encode(respData))
                print("Error, no data not received!") -- DEBUG
            end
        elseif (recData["smCommand"]=="restart") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], "Rebooting..."
            smSrv:send(cjson.encode(respData))
            print("Rebooting...") --DEBUG
            node.restart()
        elseif (recData["smCommand"]=="getip") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], wifi.sta.getip()
            smSrv:send(cjson.encode(respData))
            print("IP address sent") --DEBUG
        elseif (recData["smCommand"]=="getmac") then
            respData["smCommand"], respData["smData"] = recData["smCommand"], wifi.ap.getmac()
            smSrv:send(cjson.encode(respData))
            print("MAC address sent") --DEBUG
        elseif (recData["smCommand"]=="getwlancfg") then
            respData["smCommand"] = recData["smCommand"]
            respData["smData"]["ssid"], respData["smData"]["password"], respData["smData"]["ssid"], respData["smData"]["bssid_set"],respData["smData"]["bssid"] = wifi.sta.getconfig()
            smSrv:send(cjson.encode(respData))
            print("WLAN config sent") --DEBUG
        else
            respData["smCommand"], respData["smData"] = recData["smCommand"], "COMMAND ERROR"
            smSrv:send(cjson.encode(respData))
            print("COMMAND ERROR\r\n") --DEBUG
        end
    elseif (recData["deviceID"]=="getdeviceid") then
        respData["smCommand"], respData["smData"] = recData["deviceID"] ,respData["deviceID"]
        smSrv:send(cjson.encode(respData))
        print("DEVICE-ID sent!") --DEBUG
    else
        respData["deviceID"], respData["smCommand"], respData["smData"] = "DEVICE-ID ERROR", "DEVICE-ID ERROR", "DEVICE-ID ERROR"
        smSrv:send(cjson.encode(respData))
        print("DEVICE-ID ERROR!") --DEBUG
    end
    print(collectgarbage("count")*1024.."KB") -- Show used memory in KB
    respData, recData = nil, nil -- Free up some memory
    print(collectgarbage("count")*1024.."KB") -- Show used memory in KB
end

testWAN = require("smNetMode")

if (netMode==2) then
    smSk=net.createConnection(net.TCP,0)
    smSk:on("receive", receiveData)
    smSk:connect(2525, srvHost)
elseif (netMode==1) then
    smSrv=net.createServer(net.TCP)
    smSrv:listen(2525,function(sock)
        sock:on("receive", incLanConn)
    end)
end

-- Periodically test WAN status
tmr.alarm(0, 90*1000, 1, testWAN.checkWAN())

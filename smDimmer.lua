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

    local recData = {}
    local itemCount = 0
    for itemData in string.gmatch(stringBuffer, "%w%-+") do
        table.insert(recData, itemData)
        itemCount = itemCount + 1
        if (itemCount==2) then break end
    end
    itemCount = nil
    if (recData[1]=="SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) then
        if (recData[2]=="print") then 
            print(recData[3])
            smSrv:send(recData[3].."\r\n")            
        elseif (recData[2]=="restart") then
            smSrv:send("Reiniciando\r\n")            
            print("Reiniciando...") --DEBUG
            node.restart()
        elseif (recData[2]=="getip") then
            smSrv:send(wifi.sta.getip().."\r\n")
            print("Direccion IP enviada") --DEBUG
        elseif (recData[2]=="getmac") then
            smSrv:send(wifi.ap.getmac().."\r\n")
            print("Direccion MAC enviada") --DEBUG
        elseif (recData[2]=="getwlancfg") then
            local ssid, password, bssid_set, bssid=wifi.sta.getconfig()
            smSrv:send("SSID: "..ssid.." PASSWD: "..password.." BSSID_SET: "..bssid_set.." BSSID: "..bssid.."\r\n")
            ssid, password, bssid_set, bssid = nil, nil, nil, nil
            print("Config. WLAN enviada") --DEBUG
        else
            smSrv:send("COMMAND ERROR\r\n")
            print("COMMAND ERROR\r\n") --DEBUG
        end
    else
        smSrv:send("DEVICE-ID ERROR\r\n")
        print("DEVICE-ID ERROR\r\n") --DEBUG
        smSrv:send("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13).."\r\n")
    end
    print(collectgarbage("count")*1024.."KB") -- Mostramos la memoria usada en KB
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

-- Comprobamos el estado de la red periodicamente
tmr.alarm(0, 90*1000, 1, testWAN.checkWAN())

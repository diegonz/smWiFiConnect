local UARTHandler = {}

function UARTHandler.incUartData (data)
    local respData = {}
    respData["deviceID"] = "SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)
    respData["smCommand"] = "picdata"
    if (data=="e") then -- on = 101
      respData["smData"] = 101
      smSrv:send(cjson.encode(respData)) --DEBUG
    elseif (data=="f") then -- off = 102
      respData["smData"] = 102
      smSrv:send(cjson.encode(respData)) --DEBUG
    elseif (data=="g") then -- mConsulta = 103
      respData["smData"] = 103
      smSrv:send(cjson.encode(respData)) --DEBUG
    elseif (data=="h") then -- mNi = 104
      respData["smData"] = 104
      smSrv:send(cjson.encode(respData)) --DEBUG
    elseif (data=="i") then -- mTemp = 105
      respData["smData"] = 105
      smSrv:send(cjson.encode(respData)) --DEBUG
    elseif (data=="j") then -- mOff = 106
      respData["smData"] = 106
      smSrv:send(cjson.encode(respData)) --DEBUG
    else
        print("\nERROR - Command not found!")
    end
    print(collectgarbage("count")*1024.."KB") -- Show used memory in KB
    respData = nil -- Free up some memory
    print(collectgarbage("count")*1024.."KB") -- Show used memory in KB
end

return UARTHandler

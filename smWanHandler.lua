local wanHandler = {}

function wanHandler.incWanData (smSrv, stringBuffer)
    if (stringBuffer=="HOLA\n") then
        print(stringBuffer) --DEBUG
        smSrv:send("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13).."\n")
        print("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) --DEBUG
    elseif (stringBuffer=="OK\n") then
        print(stringBuffer) --DEBUG
    elseif (stringBuffer=="QUIT\r\n") then
        smSrv:close()
        print("Conexion finalizada") --DEBUG
    else
      --uart.write(0,string.char(tonumber(respData["smData"]))) -- SEND DATA (CHAR OF BYTE VALUE) TO UART - *ACCEPTS ONLY ONE COMMAND
      --uart.write(0,string.byte(respData["smData"])) -- SEND DATA (BYTE VALUE OF CHAR) TO UART  *ACCEPTS ONLY ONE COMMAND*
        print(stringBuffer)
    end
end

return wanHandler

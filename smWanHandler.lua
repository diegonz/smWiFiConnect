local wanHandler = {}

function wanHandler.incWanData (smSrv, stringBuffer, notLoggedIn)
    if (stringBuffer=="RQ_AUTH\n") then
        notLoggedIn = true
--    else
--      --uart.write(0,string.char(tonumber(respData["smData"]))) -- SEND DATA (CHAR OF BYTE VALUE) TO UART - *ACCEPTS ONLY ONE COMMAND
--      --uart.write(0,string.byte(respData["smData"])) -- SEND DATA (BYTE VALUE OF CHAR) TO UART  *ACCEPTS ONLY ONE COMMAND*
--        print(stringBuffer)
    end
    print(stringBuffer)
    --smSrv:send(stringBuffer)	-- SENDS DATA BACK TO THE SERVER
end

return wanHandler

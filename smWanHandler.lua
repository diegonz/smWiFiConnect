local wanHandler = {}

function wanHandler.incWanData (smSrv, stringBuffer)
    -- Configure UART
    --if ((uart.setup( 0, 115200, 8, 0, 1, 0 )) == 115200) then
    --  uart.write(0,string.char(tonumber(respData["smData"]))) -- SEND DATA (CHAR OF BYTE VALUE) TO UART - *ACCEPTS ONLY ONE COMMAND
    --  uart.write(0,string.byte(respData["smData"])) -- SEND DATA (BYTE VALUE OF CHAR) TO UART  *ACCEPTS ONLY ONE COMMAND*
    --else
    --  smSrv:send(UART_ERROR)-- TODO SENDS UART ERROR TO THE SERVER
    --  node.restart()
    --end

    print(stringBuffer) -- Prints received data

    -- SENDS DATA BACK TO THE SERVER
    --smSrv:send(stringBuffer,
    --    function()
    --        smSrv:send("\n")
    --    end
    --)
end

return wanHandler

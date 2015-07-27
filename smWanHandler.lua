local wanHandler = {}

function wanHandler.incWanConn (smSk, stringBuffer)
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
        print(stringBuffer)
    end
end

return wanHandler
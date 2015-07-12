print("\nsmDimmer iniciada correctamente") --DEBUG

function incConn (smsk,stringBuffer)
    if (stringBuffer=="HOLA\n") then
        print(stringBuffer) --DEBUG
        smsk:send("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13).."\n")
        print("SMARTIDEA-"..string.sub(wifi.ap.getmac(),13)) --DEBUG
    elseif (stringBuffer=="OK\n") then
        print(stringBuffer) --DEBUG
    elseif (stringBuffer=="QUIT\r\n") then
        smsk:close()
        print("Conexion finalizada") --DEBUG
    else
        print(stringBuffer) --DEBUG
    end
end

srvHost="192.168.1.107"
smsk=net.createConnection(net.TCP,0)
smsk:on("receive", incConn)
smsk:connect(2525, srvHost)
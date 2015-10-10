local wanAuthHandler = {}

function wanAuthHandler.authRequest (smSrv)
    print("\nsmWanAuthHandler iniciada correctamente") --DEBUG
    local wanAuthRequest = {}
    wanAuthRequest["action"] = "DEVICE_AUTH"
    wanAuthRequest["id"] = "100999"
    smSrv:send(cjson.encode(wanAuthRequest))
end

return wanAuthHandler

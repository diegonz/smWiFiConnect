local wanAuthHandler = {}

function wanAuthHandler.authRequest (smSrv)
    print("\nsmWanAuthHandler successfully started") --DEBUG
    local wanAuthRequest = {}
    wanAuthRequest["action"] = "DEVICE_AUTH"
    wanAuthRequest["id"] = "100999"
    smSrv:send(cjson.encode(wanAuthRequest),
        function()
            smSrv:send("\n")
        end
    )
end

return wanAuthHandler

--Reconnect MP Screen

local env = env
GLOBAL.setfenv(1, GLOBAL)

env.AddClassPostConstruct("screens/redux/multiplayermainscreen", function(self, ...)
    TheSim:GetPersistentString("BetterCrashScreen", function(load_success, data)
        if load_success and data ~= nil then
            local status, bettercrashscr = pcall(function() return json.decode(data) end)
            if status and bettercrashscr then
                self.bettercrashscr_cached_server = bettercrashscr.bettercrashscr_cached_server
                self.loaded = true
            end
        end
    end)
    local online = TheNet:IsOnlineMode() and not TheFrontEnd:GetIsOfflineMode()


    self.oldactive = self.OnBecomeActive
    self.OnBecomeActive = function(self, ...)
        TheMixer:SetHighPassFilter("set_music", 0)


        return self.oldactive(self, ...)
    end

    if self.bettercrashscr_cached_server and online then
        self.inst:DoTaskInTime(0.2, function()
            TheMixer:SetHighPassFilter("set_music", 1000)
        end)

        self.inst:DoTaskInTime(1.5, function()
            TheFrontEnd:GetSound():PlaySound("dontstarve/common/lava_arena/player_joined", 0.35)
            JoinServer(self.bettercrashscr_cached_server)
        end)

        self.inst:DoTaskInTime(2, function()
            local locationData = { bettercrashscr_cached_server = nil }
            local jsonString = json.encode(locationData)
            TheSim:SetPersistentString("BetterCrashScreen", jsonString, false)
        end)
    else
        local locationData = { bettercrashscr_cached_server = nil }
        local jsonString = json.encode(locationData)
        TheSim:SetPersistentString("BetterCrashScreen", jsonString, false)
    end
end)
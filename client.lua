local Alerts = {}

local function CreateAlert(coords, blipType, title, description, notifyType)


    exports.ox_lib:notify({
        title = title,
        description = description,
        type = notifyType or 'inform'
    })

    local blipConfig = Config.Blips[blipType] or Config.Blips.custom
    

    local blip1 = N_0x554d9d53f696d002(1664425300, coords.x, coords.y, coords.z)
    local blip2 = Citizen.InvokeNative(0x45f13b7e0a15c880, 693035517, coords.x, coords.y, coords.z, blipConfig.areaSize or 10.0)
    


    Citizen.InvokeNative(0x0DF2B55F717DDB10, blip1, false)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip1, blipConfig.modifier)
    SetBlipSprite(blip1, blipConfig.sprite, blipConfig.color or 1)
    SetBlipScale(blip1, blipConfig.scale)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip1, blipConfig.label)
    

    local id = #Alerts + 1
    Alerts[id] = {
        blip1 = blip1,
        blip2 = blip2
    }

    SetTimeout(Config.BlipDuration, function()
        if Alerts[id] then
            RemoveBlip(Alerts[id].blip1)
            RemoveBlip(Alerts[id].blip2)
            Alerts[id] = nil
        end
    end)
    
    return id
end

-- Özel bildirim ve blip oluşturma
RegisterNetEvent('af-alert:client:customAlert')
AddEventHandler('af-alert:client:customAlert', function(coords, message, alertData)


    local alertType = "custom"
    local title = Config.DefaultAlerts.custom.title
    local notifyType = Config.DefaultAlerts.custom.notifyType
    
    -- Eğer özel alert verisi gönderilmişse kullan
    if alertData then
        alertType = alertData.blipType or alertType
        title = alertData.title or title
        notifyType = alertData.notifyType or notifyType
    end
    
    CreateAlert(coords, alertType, title, message, notifyType)
end)




RegisterCommand('testfire', function()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local randomOffset = vector3(
        (math.random() - 0.5) * 100,
        (math.random() - 0.5) * 100,
        0
    )
    local randomCoords = playerCoords + randomOffset
    TriggerServerEvent('af-alert:server:alert', randomCoords)
end, false)



RegisterCommand('testalert', function(source, args)
    local blipType = args[1] or "custom"
    local alertData = {
        blipType = blipType,
        title = "Test Alert: " .. blipType,
        notifyType = "inform"
    }
    
    TriggerServerEvent('af-alert:server:customAlertTrigger', 
        "Test alert with blip type: " .. blipType, 
        Config.AlertDistance, 
        {"unemployed"}, 
        alertData
    )
end, false)




-- Normal shotfire bildirimi
RegisterNetEvent('af-alert:client:alert')
AddEventHandler('af-alert:client:alert', function(coords)
    local alertConfig = Config.DefaultAlerts.shotfire
    CreateAlert(
        coords, 
        alertConfig.blip, 
        alertConfig.title, 
        alertConfig.description, 
        alertConfig.notifyType
    )
end)


local shotCount = 0
local canTriggerShotAlert = true

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) then
            if canTriggerShotAlert then
                shotCount = shotCount + 1
                local coords = GetEntityCoords(playerPed)
                TriggerServerEvent('af-alert:server:alert', coords)
                if shotCount >= 2 then
                    canTriggerShotAlert = false
                    Citizen.SetTimeout(Config.ShotCooldown, function()
                        shotCount = 0
                        canTriggerShotAlert = true
                    end)
                end
            end
        end
        Citizen.Wait(100)
    end
end)



function CallSendCustomAlert(message, distance, alertJobs, options)
  
    
    options = options or {}
    
    local alertData = {
        blipType = options.blipType or "custom",
        title = options.title or Config.DefaultAlerts.custom.title,
        notifyType = options.notifyType or Config.DefaultAlerts.custom.notifyType
    }
    
    TriggerServerEvent('af-alert:server:customAlertTrigger', message, distance, alertJobs, alertData)
end
exports('CallSendCustomAlert', CallSendCustomAlert)
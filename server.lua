local RSGCore = exports['rsg-core']:GetCoreObject()


exports('SendCustomAlert', function(message, distance, alertJobs, options)
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)

    if not player then
        if Config.Debug then
            print(('Player with source %s not found in RSG Core.'):format(src))
        end
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))

    if Config.Debug then
        print(('Custom alert triggered by %s at %s'):format(player.PlayerData.name, playerCoords))
    end

    -- Tüm alert jobları için bildirimleri gönder
    if alertJobs and type(alertJobs) == "table" then
        for _, job in ipairs(alertJobs) do
            local players, count = RSGCore.Functions.GetPlayersOnDuty(job)
            if Config.Debug then
                print(('Found %d players on duty for job: %s'):format(count, job))
            end

            for _, v in ipairs(players) do
                TriggerClientEvent('af-alert:client:customAlert', v, playerCoords, message, options)
                if Config.Debug then
                    print(('Custom alert sent to %s (Job: %s)'):format(GetPlayerName(v), job))
                end
            end
        end
    else
        if Config.Debug then
            print('No alert jobs specified or invalid format.')
        end
    end
end)

RegisterNetEvent('af-alert:server:alert')
AddEventHandler('af-alert:server:alert', function(coords)
    if not Config.ShootAlert then
        if Config.Debug then
            print('Shoot alerts are disabled in the config.')
        end
        return
    end

    local src = source
    local player = RSGCore.Functions.GetPlayer(src)

    if not player then
        if Config.Debug then
            print(('Player with source %s not found in RSG Core.'):format(src))
        end
        return
    end

    -- Eğer oyuncu bildirim gönderilecek meslek grubundaysa bildirim gönderme
    local playerJob = player.PlayerData.job.name
    if Config.AlertJobs[playerJob] then
        if Config.Debug then
            print(('Player %s is in an alert job (%s), no notification sent.'):format(player.PlayerData.name, playerJob))
        end
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))

    if Config.Debug then
        print(('Player %s shot at %s'):format(player.PlayerData.name, coords))
    end


    if #(playerCoords - coords) <= Config.AlertDistance then
        for job, _ in pairs(Config.AlertJobs) do
            local players, count = RSGCore.Functions.GetPlayersOnDuty(job)
            if Config.Debug then
                print(('Found %d players on duty for job: %s'):format(count, job))
            end

            for _, v in ipairs(players) do
                TriggerClientEvent('af-alert:client:alert', v, coords)
                if Config.Debug then
                    print(('Alert sent to %s (Job: %s)'):format(GetPlayerName(v), job))
                end
            end
        end
    else
        if Config.Debug then
            print(('Player %s shot, but no alert sent due to distance.'):format(player.PlayerData.name))
        end
    end
end)


RegisterNetEvent('af-alert:server:customAlertTrigger')
AddEventHandler('af-alert:server:customAlertTrigger', function(message, distance, alertJobs, alertData)
    local src = source
    local player = RSGCore.Functions.GetPlayer(src)
    if not player then
        if Config.Debug then
            print(('Player with source %s not found in RSG Core.'):format(src))
        end
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if Config.Debug then
        print(('Custom alert triggered by %s at %s'):format(player.PlayerData.name, playerCoords))
    end

    -- Tüm alert jobları için bildirimleri gönder
    if alertJobs and type(alertJobs) == "table" then
        for _, job in ipairs(alertJobs) do
            local players, count = RSGCore.Functions.GetPlayersOnDuty(job)
            if Config.Debug then
                print(('Found %d players on duty for job: %s'):format(count, job))
            end

            for _, v in ipairs(players) do
                TriggerClientEvent('af-alert:client:customAlert', v, playerCoords, message, alertData)
                if Config.Debug then
                    print(('Custom alert sent to %s (Job: %s)'):format(GetPlayerName(v), job))
                end
            end
        end
    else
        if Config.Debug then
            print('No alert jobs specified or invalid format.')
        end
    end
end)
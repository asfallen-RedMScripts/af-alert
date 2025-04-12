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
        print(('Custom alert triggered by %s at %s with distance: %s'):format(player.PlayerData.name, playerCoords, distance))
    end

    -- Geçerli mesafe değeri kontrolü
    if distance == nil or type(distance) ~= "number" then
        distance = Config.AlertDistance -- Varsayılan değer kullan
        if Config.Debug then
            print('Invalid distance value, using default: ' .. distance)
        end
    end

    local jobsToAlert = {}
    if alertJobs and type(alertJobs) == "table" then
        if #alertJobs > 0 then
            jobsToAlert = alertJobs
        else
        
            for job, active in pairs(alertJobs) do
                if active then
                    table.insert(jobsToAlert, job)
                end
            end
        end
    elseif Config.Debug then
        print('No alert jobs specified or invalid format. Using default jobs.')

        for job, _ in pairs(Config.AlertJobs) do
            table.insert(jobsToAlert, job)
        end
    end

    local players = RSGCore.Functions.GetPlayers()
    for _, playerId in ipairs(players) do
        local targetPlayer = RSGCore.Functions.GetPlayer(playerId)
        
        if targetPlayer then
            local targetJob = targetPlayer.PlayerData.job.name
            local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
            local isJobMatch = false
            
        
            for _, job in ipairs(jobsToAlert) do
                if targetJob == job then
                    isJobMatch = true
                    break
                end
            end
            
        
            if isJobMatch then
                local distanceBetween = #(playerCoords - targetCoords)
                
                if distanceBetween <= distance then
                    TriggerClientEvent('af-alert:client:customAlert', playerId, playerCoords, message, options)
                    
                    if Config.Debug then
                        print(('Custom alert sent to %s (Job: %s, Distance: %.2f)'):format(
                            GetPlayerName(playerId), targetJob, distanceBetween))
                    end
                elseif Config.Debug then
                    print(('Player %s is too far (%.2f > %s), no alert sent'):format(
                        GetPlayerName(playerId), distanceBetween, distance))
                end
            end
        end
    end
end)


RegisterNetEvent('af-alert:server:fireAlert')
AddEventHandler('af-alert:server:fireAlert', function(coords)
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


    local playerJob = player.PlayerData.job.name
    if Config.AlertJobs[playerJob] and Config.AlertJobs[playerJob] == true then
        if Config.Debug then
            print(('Player %s is in an ignored alert job (%s), no notification sent.'):format(player.PlayerData.name, playerJob))
        end
        return
    end

    local playerCoords = GetEntityCoords(GetPlayerPed(src))

    if Config.Debug then
        print(('Player %s shot at %s'):format(player.PlayerData.name, coords))
    end

    -- Sunucu üzerindeki tüm oyuncuları kontrol et
    local players = RSGCore.Functions.GetPlayers()
    for _, playerId in ipairs(players) do
        local targetPlayer = RSGCore.Functions.GetPlayer(playerId)
        
        if targetPlayer then
            local targetJob = targetPlayer.PlayerData.job.name
            local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
            
            local distanceBetween = #(playerCoords - targetCoords)
            
            if distanceBetween <= Config.AlertDistance then
                TriggerClientEvent('af-alert:client:fireAlert', playerId, coords)
                
                if Config.Debug then
                    print(('Shotfire alert sent to %s (Job: %s, Distance: %.2f)'):format(
                        GetPlayerName(playerId), targetJob, distanceBetween))
                end
            elseif Config.Debug then
                print(('Player %s is too far (%.2f > %s), no shotfire alert sent'):format(
                    GetPlayerName(playerId), distanceBetween, Config.AlertDistance))
            end
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
        print(('Custom alert triggered by %s at %s with distance: %s'):format(
            player.PlayerData.name, playerCoords, distance))
    end

    if distance == nil or type(distance) ~= "number" then
        distance = Config.AlertDistance 
        if Config.Debug then
            print('Invalid distance value, using default: ' .. distance)
        end
    end

    local jobsToAlert = {}
    if alertJobs and type(alertJobs) == "table" then
        -- Eğer array ise (örn: {"police", "sheriff"}) direkt kullan
        if #alertJobs > 0 then
            jobsToAlert = alertJobs
        else
            -- Eğer hash map ise (örn: {police=true, sheriff=true}) key'leri al
            for job, active in pairs(alertJobs) do
                if active then
                    table.insert(jobsToAlert, job)
                end
            end
        end
    elseif Config.Debug then
        print('No alert jobs specified or invalid format. Using default jobs.')

        for job, _ in pairs(Config.AlertJobs) do
            table.insert(jobsToAlert, job)
        end
    end


    local players = RSGCore.Functions.GetPlayers()
    for _, playerId in ipairs(players) do
        local targetPlayer = RSGCore.Functions.GetPlayer(playerId)
        
        if targetPlayer then
            local targetJob = targetPlayer.PlayerData.job.name
            local targetCoords = GetEntityCoords(GetPlayerPed(playerId))
            local isJobMatch = false
            
          
            for _, job in ipairs(jobsToAlert) do
                if targetJob == job then
                    isJobMatch = true
                    break
                end
            end
            
          
            if isJobMatch then
                local distanceBetween = #(playerCoords - targetCoords)
                
                if distanceBetween <= distance then
                    TriggerClientEvent('af-alert:client:customAlert', playerId, playerCoords, message, alertData)
                    
                    if Config.Debug then
                        print(('Custom alert sent to %s (Job: %s, Distance: %.2f)'):format(
                            GetPlayerName(playerId), targetJob, distanceBetween))
                    end
                elseif Config.Debug then
                    print(('Player %s is too far (%.2f > %s), no alert sent'):format(
                        GetPlayerName(playerId), distanceBetween, distance))
                end
            end
        end
    end
end)
lib.locale()
local config = require('shared.config')
local ox_inventory = exports.ox_inventory

if config.Framework == "qb" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
end

PoliceCount = function()
    local jobCount = 0
    if config.Framework == "qb" then
        for _, players in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(players)
            local job = player.PlayerData.job
            for _, jobs in pairs(config.Police.jobs) do
                local jobNames = jobs
                print(jobNames)
                if job.name == jobNames then
                    jobCount = jobCount + 1
                end
            end
        end
    elseif config.Framework == 'esx' then
        for _, player in pairs(ESX.GetExtendedPlayers()) do
            local job = player.getJob()
            for _, jobs in pairs(config.Police.jobs) do
                local jobNames = jobs
                if job.name == jobNames then
                    jobCount = jobCount + 1
                end
            end
        end
    end
    return jobCount
end

RegisterServerEvent('possible-phonehacking:server:requestPoliceCount', function()
    local policeCount = PoliceCount()  -- Call the function to get the police count
    TriggerClientEvent('possible-phonehacking:client:receivePoliceCount', source, policeCount)  -- Send police count to the client
end)

RegisterServerEvent('possible-phonehacking:server:removeRequiredItem', function()
    local src = source
    if config.QBInventory then
        Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveItem(config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[config.RequiredItem], "remove", 1)
        end
    else
        ox_inventory:RemoveItem(src, config.RequiredItem, 1)
    end
end)

RegisterServerEvent('possible-phonehacking:server:giveReward', function(reward)
    if config.Debug then
        print('Reward: ' .. reward)
    end
    
    local src = source

    if config.Framework == "qb" then
        Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddMoney('bank', reward)
        if config.PossibleTerritories then
            exports['possible-territories']:AddItemToStash(src, config.TerritoriesRewardItem, config.TerritoriesRewardAmount)
            exports['possible-territories']:UpdateInfluenceForGangInTerritory(src, config.TerritoriesInfluence)
        end
        if config.PossibleGangLevels then
            local gangName = Player.PlayerData.gang.name
            print(gangName)
            if gangName ~= "none" then
                exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, config.GangXPReward)
            end
        end
    elseif config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addAccountMoney('bank', reward)
        if config.PossibleTerritories then
            exports['possible-territories']:AddItemToStash(src, config.TerritoriesRewardItem, config.TerritoriesRewardAmount)
            exports['possible-territories']:UpdateInfluenceForGangInTerritory(src, config.TerritoriesInfluence)
        end
        if config.PossibleGangLevels then
            local gangName = xPlayer.job.name
            exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, config.GangXPReward)
        end
    end

    if config.QBInventory then
        if Player.Functions.RemoveItem(config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['phonehacker'], "remove", 1)
        end
    else
        ox_inventory:RemoveItem(src, config.RequiredItem, 1)
    end
    
    TriggerClientEvent('ox_lib:notify', src, { title = locale('hacking_hack_successful_title'), description = locale('hacking_hack_sucessful_description') .. reward, position = config.NotifPosition, type = 'success' })

end)

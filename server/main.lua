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

RegisterServerEvent('possible-phonehacking:server:giveReward', function(reward)
    if config.Debug then
        print('Reward: ' .. reward)
    end
    local src = source

    if config.Framework == "qb" then
        Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.AddMoney('bank', reward)
    elseif config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        xPlayer.addAccountMoney('bank', reward)
    end

    if config.QBInventory then
        if Player.Functions.RemoveItem(Config.RequiredItem, 1) then
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['phonehacker'], "remove", 1)
        end
    else
        ox_inventory:RemoveItem(src, config.RequiredItem, 1)
    end
    
    TriggerClientEvent('ox_lib:notify', src, { title = locale('hacking_hack_successful_title'), description = locale('hacking_hack_sucessful_description') .. reward, position = config.NotifPosition, type = 'success' })
    
        if config.PossibleTerritories and config.Framework == "qb" then
            TriggerEvent('possible-phonehacking:server:rewardGangInfluence')
        elseif config.PossibleTerritories and config.Framework == "esx" then
            TriggerEvent('possible-phonehacking:server:rewardGangInfluence')
        end 
    
        if config.PossibleGangLevel and config.Framework == "qb" then
            local src = source
            local Player = QBCore.Functions.GetPlayer(src)
            local gangName = Player.PlayerData.gang.name
            if gangName ~= "none" then
                exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, 5) -- Replace with the amount of XP to give
            end
        elseif config.PossibleGangLevel and config.Framework == "esx" then
            exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, 5) -- Replace with the amount of XP to give
        end
end)

RegisterServerEvent('possible-phonehacking:server:rewardGangInfluence', function()
    if config.Framework == "qb" then
        local src = source
        local player = QBCore.Functions.GetPlayer(src)
        if not player then return end
        local gangID = Player.PlayerData.gang.name
        
        local territoryName = exports['possible-territories']:GetPlayerTerritory(src)
        if not territoryName then return end

        local influence = 10 -- Influence Gained Per hack
        local cashAmount = 30 -- Amount added to stash per completion, regardless of who completes
        exports['possible-territories']:AddCashToSafe(territoryName, cashAmount)
        exports['possible-territories']:UpdateInfluenceForGangInTerritory(territoryName, gangID, influence)
    elseif config.Framework == "esx" then
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        local gangID = xPlayer.job.name

        local territoryName = exports['possible-territories']:GetPlayerTerritory(source)
        if not territoryName then return end

        local influence = 10 -- Influence Gained Per hack
        local cashAmount = 30 -- Amount added to stash per completion, regardless of who completes
        exports['possible-territories']:AddCashToSafe(territoryName, cashAmount)
        exports['possible-territories']:UpdateInfluenceForGangInTerritory(territoryName, gangID, influence)
    end
end) 

RegisterServerEvent('possible-phonehacking:server:rewardGangXP', function()
    if config.Framework == "qb" then
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local gangName = Player.PlayerData.gang.name

    if gangName ~= "none" then
        exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, 5) -- Replace with the amount of XP to give
    end
    elseif config.Framework == "esx" then
        local source = source
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end
        local gangName = xPlayer.job.name

        exports['possible-gang-levels']:AddGangXPForPlayer(src, gangName, 5) -- Replace with the amount of XP to give
    end
end) 

local QBCore = exports['qb-core']:GetCoreObject()
local ox_inventory = exports.ox_inventory

local cachedPoliceAmount = {}

QBCore.Functions.CreateCallback('possible-atm-robbery:server:getCops', function(source, cb)
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if not Config.UsePoliceName then 
            if v.PlayerData.job.type == Config.PoliceJobType and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        else 
            if v.PlayerData.job.name == Config.PoliceJobName and v.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    cachedPoliceAmount[source] = amount
    cb(amount)
end)

RegisterServerEvent('possible-phonehacker:removeRequiredItem')
AddEventHandler('possible-phonehacker:removeRequiredItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Config.InventoryType == "qb-inventory" then
        if Player.Functions.RemoveItem(Config.RequiredItem, 1) then
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['phonehacker'], "remove", 1)
    end
        elseif Config.InventoryType == "ox_inventory" then
        ox_inventory:RemoveItem(source, Config.RequiredItem, 1)
    end
end)


RegisterServerEvent('possible-phonehacker:giveReward')
AddEventHandler('possible-phonehacker:giveReward', function(reward)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('bank', reward)
    TriggerClientEvent('possible-phonehacker:success', src, reward)
end)

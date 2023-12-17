local QBCore = exports['qb-core']:GetCoreObject()
local ox_target = exports.ox_target
local ox_inventory = exports.ox_inventory
local PlayerHasProp = false
local PlayerProps = {}
local hackedPeds = {}
local currentTargetPed = nil
local maxWiringDistance = Config.MaxDistanceFromPed

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerJob = QBCore.Functions.GetPlayerData().job
    onDuty = true
end)

RegisterNetEvent('QBCore:Client:SetDuty', function(duty)
    onDuty = duty
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = true
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

local function PoliceCall()
     exports['ps-dispatch']:PhoneHacking()
end

  function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))
  
    if not HasModelLoaded(prop1) then
      LoadPropDict(prop1)
    end
  
    local prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
  end
  

function AnimMode()
    local Player = PlayerPedId()
    local AnimDict = "amb@code_human_wander_texting_fat@male@base"
    lib.requestAnimDict(AnimDict, 500)
    local Prop = 'ch_prop_ch_phone_ing_01a'
    lib.requestModel(Prop, 500)
    local PropBone = 28422
    AddPropToPlayer(Prop, PropBone, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0)
    TaskPlayAnim(GetPlayerPed(-1), AnimDict, "static", 2.0, 8.0, -1, 53, 0, false, false, false)
end

function DestroyAllProps()
    for _, v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
end

local function isPedTargetable(ped)
    local amount = ox_inventory:Search('count', Config.RequiredItem)
    if not IsPedAPlayer(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) and amount > 0 then
        return true
    end
    return false
end

local pedOptions = {
    {
        name = 'possible-phonehacker:hackPhone',
        icon = 'fas fa-mobile-alt',
        label = Config.TargetLabel,
        distance = Config.TargetDistance,
        canInteract = function(entity)
            if not isPedTargetable(entity) then
                return false
            end
            return true
        end,
        onSelect = function(entity)
            ped = entity.entity
            if Config.Debug then
                local pedCoords = GetEntityCoords(ped)
                local playerCoords = GetEntityCoords(PlayerPedId())
                print("Ped Coords: ", pedCoords.x, pedCoords.y, pedCoords.z)
                print("Player Coords: ", playerCoords.x, playerCoords.y, playerCoords.z)
            end
            if not hackedPeds[ped] then
                hackedPeds[ped] = true
                TaskWanderStandard(ped, 10.0, 10)
                TriggerEvent('possible-phonehacker:startHack')
            else
                if Config.NotifyType == 'ox_lib' then
                    lib.notify({
                        title = Config.AlreadyHackedTitle,
                        description = Config.AlreadyHackedDescription,
                        type = 'error',
                        position = Config.OxlibPosition
                    })
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert(Config.AlreadyHackedTitle, Config.AlreadyHackedDescription, 1500, 'error', true)
                elseif Config.NotifyType == "qb-notify" then
                    QBCore.Functions.Notify(Config.AlreadyHackQbNotif)
                end
            end
        end
    }
}

local qbTargetPedOptions = {
    {
        name = 'possible-phonehacker:hackPhone',
        event = 'possible-phonehacker:startHack',
        icon = 'fas fa-mobile-alt',
        label = Config.TargetLabel,
        item = Config.RequiredItem,
        canInteract = function(entity)
            if IsPedAPlayer(entity) or IsEntityDead(entity) then return false end
            local pedType = GetPedType(entity)
            return pedType ~= 28
        end,
        action = function(entity)
            ped = entity
            if not hackedPeds[ped] then
                hackedPeds[ped] = true
                TaskWanderStandard(ped, 10.0, 10)
                TriggerEvent('possible-phonehacker:startHack')
            else
                if Config.NotifyType == 'ox_lib' then
                    lib.notify({
                        title = 'Not today bucko',
                        description = 'This pedestrian has already been hacked.',
                        type = 'error',
                        position = Config.OxlibPosition
                    })
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert('Not today bucko', 'This pedestrian has already been hacked.', 1500, 'error', true)
                elseif Config.NotifyType == "qb-notify" then
                    QBCore.Functions.Notify('Not today bucko! This pedestrian has already been hacked.')
                end
        end
    end
    }
}

local function InitializeTargetSystem()
    if Config.TargetType == 'ox_target' then
        ox_target:addGlobalPed(pedOptions)
    elseif Config.TargetType == 'qb-target' then
        exports['qb-target']:AddGlobalPed({
            options = qbTargetPedOptions,
            distance = Config.TargetDistance
        })
    end
end

InitializeTargetSystem()

local function OnHackDone(success)
    Animation = false
    if success then
        TriggerEvent('mhacking:hide')
        local policeChance = math.random(1, 100)
        if policeChance <= Config.PoliceCallHackingChance then
            if Config.Debug then
                print("Police Chance Random", policeChance)
            end
            PoliceCall()
        end

        local AnimDict = "cellphone@"
        lib.requestAnimDict(AnimDict, 500)
        local Prop = 'ch_prop_ch_phone_ing_01a'
        lib.requestModel(Prop, 500)
        local PropBone = 28422
        AddPropToPlayer(Prop, PropBone, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0)
        TaskPlayAnim(GetPlayerPed(-1), AnimDict, "cellphone_text_in", 2.0, 8.0, -1, 54, Config.WiringTime, false, false, false)

        QBCore.Functions.Progressbar("wiring_bank_funds", Config.WiringProgressText, Config.WiringTime, false, true, {
            disableMouse = false,
            disableCombat = true,
        }, {},{}, {}, function()                      -- Done
            currentTargetPed = nil
            ClearPedTasks(PlayerPedId())
            DestroyAllProps()
            local pedCoords = GetEntityCoords(ped) -- Get the current coordinates
            local playerCoords = GetEntityCoords(PlayerPedId())
            local Distance = math.abs(playerCoords.x - pedCoords.x)
            if Config.Debug then
                print("Distance between player and target ped:", Distance)
                print(pedCoords)
                print(playerCoords)
            end
            if Distance > maxWiringDistance then
                if Config.NotifyType == "ox_lib" then
                    lib.notify({
                        title = Config.SignalLostNotifTitle,
                        description = Config.SignalLostNotifDescription,
                        type = 'error',
                        position = Config.OxlibPosition
                    })
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert('Signal Lost', Config.SignalLostNotifDescription, 1500,
                        'error', true)
                elseif Config.NotifyType == "qb-notify" then
                    QBCore.Functions.Notify(Config.SignalLostQbNotif, "error")
                end
            else
                local reward = math.random(Config.MinReward, Config.MaxReward)
                TriggerServerEvent('possible-phonehacker:giveReward', reward)
            end
        end, function() -- Cancel
            DestroyAllProps()
            ClearPedTasks(PlayerPedId())
            if Config.NotifyType == "ox_lib" then
                lib.notify({
                    title = Config.AuthFailedNotifTitle,
                    description = Config.AuthFailedNotifDescription,
                    type = 'error',
                    position = Config.OxlibPosition
                })
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert(Config.AuthFailedNotifTitle, Config.AuthFailedNotifDescription, 1500,
                'error', true)
            elseif Config.NotifyType == "qb-notify" then
                QBCore.Functions.Notify(Config.AuthFailedNotifDescription, "error")
            end
            currentTargetPed = nil
        end)
    else
        TriggerEvent('mhacking:hide')
        ClearPedTasks(PlayerPedId())
        DestroyAllProps()
        if Config.NotifyType == 'ox_lib' then
            lib.notify({
                title = Config.AuthFailedNotifTitle,
                description = Config.AuthFailedNotifDescription,
                type = 'error',
                position = Config.OxlibPosition
            })
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert(Config.AuthFailedNotifTitle, Config.AuthFailedNotifDescription, 1500,
                'error', true)
        elseif Config.NotifyType == "qb-notify" then
            QBCore.Functions.Notify(Config.AuthFailedNotifDescription, "error")
        end
        currentTargetPed = nil
    end
end

RegisterNetEvent('possible-phonehacker:startHack')
AddEventHandler('possible-phonehacker:startHack', function(ped)
    QBCore.Functions.TriggerCallback('possible-atm-robbery:server:getCops', function(cops)
        if cops >= Config.MinimumPolice then
            AnimMode()
            currentTargetPed = ped
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
        else
            if Config.OxLib then
                lib.notify({
                    title = Config.NoPoliceOnlineTitle,
                    description = Config.NoPoliceOnlineDescription,
                    type = 'error'
                })
            else
                QBCore.Functions.Notify(Config.NoPoliceOnlineQbNotif, 'error', 1500)
            end
        end
    end)
end)

RegisterNetEvent('possible-phonehacker:success')
AddEventHandler('possible-phonehacker:success', function(reward)
    local src = source
    TriggerServerEvent('possible-phonehacker:removeRequiredItem', src)
    if Config.NotifyType == 'ox_lib' then
        lib.notify({
            title = 'Hack Successful',
            description = 'You have received $' .. reward .. ' in your bank account.',
            type = 'success',
            position = Config.OxlibPosition
        })
    elseif Config.NotifyType == "okok" then
        exports['okokNotify']:Alert('Hack Successful', 'You have received $' .. reward .. ' in your bank account.', 1500, 'success', true)
    elseif Config.NotifyType == "qb-notify" then
        QBCore.Functions.Notify('Hack Successful! You have received $' .. reward .. ' in your bank account.')
    end
    DestroyAllProps()
end)
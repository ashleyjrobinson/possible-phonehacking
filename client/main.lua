lib.locale()
local config = require('shared.config')

local ox_target = exports.ox_target
local ox_inventory = exports.ox_inventory
local hackedPeds = {}
local currentTargetPed = nil
local maxWiringDistance = config.MaxDistanceFromPed

local function policeCall()
    if config.Dispatch == "ps-dispatch" then
         exports['ps-dispatch']:PhoneHacking()
    else
        -- Add your custom export here
    end
end

local function isPedTargetable(ped)
    local amount = ox_inventory:Search('count', config.RequiredItem)
    if not IsPedAPlayer(ped) and not IsEntityDead(ped) and not IsPedInAnyVehicle(ped, true) and amount > 0 then
        return true
    end
    return false
end

local pedOptions = {
    {
        name = 'HackPhoneTarget',
        icon = 'fas fa-mobile-alt',
        label = locale('target_label'),
        distance = config.TargetDistance,
        item = config.RequiredItem,
        canInteract = function(entity)
            if not isPedTargetable(entity) then
                return false
            end
            return true
        end,
        onSelect = function(entity)
            ped = entity.entity
            if config.Debug then
                local pedCoords = GetEntityCoords(ped)
                local playerCoords = GetEntityCoords(PlayerPedId())
                print("Ped Coords: ", pedCoords.x, pedCoords.y, pedCoords.z)
                print("Player Coords: ", playerCoords.x, playerCoords.y, playerCoords.z)
            end
            if not hackedPeds[ped] then
                hackedPeds[ped] = true
                TaskWanderStandard(ped, 10.0, 10)
                TriggerEvent('possible-phonehacking:client:startHack')
            else
                lib.notify({
                    title = locale('hacking_already_hacked_title'),
                    description = locale('hacking_already_hacked_description'),
                    type = 'error',
                    position = config.NotifPosition
                })
            end
        end
    }
}

local qbTargetPedOptions = {
    {
        name = 'HackPhoneTarget',
        event = 'possible-phonehacking:client:startHack',
        icon = 'fas fa-mobile-alt',
        label = locale('target_label'),
        item = config.RequiredItem,
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
                TriggerEvent('possible-phonehacking:client:startHack')
            else
                lib.notify({
                    title = locale('hacking_already_hacked_title'),
                    description = locale('hacking_already_hacked_description'),
                    type = 'error',
                    position = config.NotifPosition
                })
        end
    end
    }
}

local function InitializeTargetSystem()
    if config.TargetType == 'ox_target' then
        ox_target:addGlobalPed(pedOptions)
    elseif config.TargetType == 'qb-target' then
        exports['qb-target']:AddGlobalPed({
            options = qbTargetPedOptions,
            distance = config.TargetDistance
        })
    end
end

InitializeTargetSystem()

local function OnHackDone(success)
    if success then
        TriggerEvent('mhacking:hide')
        local policeChance = math.random(1, 100)
        if policeChance <= config.PoliceCallHackingChance then
            if config.Debug then
                print("Police Chance Random", policeChance)
            end
            policeCall()
        end
        if config.Emotes == "rpemotes" then
            exports["rpemotes"]:EmoteCommandStart("phone")
        else
            exports.scully_emotemenu:playEmoteByCommand('phone')
        end

        if lib.progressBar({
                duration = config.ProgressDuration,
                label = locale('hacking_progress_label'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                    move = false,
                    combat = true
                }
            }) then
            currentTargetPed = nil
            local pedCoords = GetEntityCoords(ped)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local Distance = math.abs(playerCoords.x - pedCoords.x)
            if config.Debug then
                print("Distance between player and target ped:", Distance)
                print(pedCoords)
                print(playerCoords)
            end
            if Distance > maxWiringDistance then
                lib.notify({
                    title = locale('hacking_signal_lost_title'),
                    description = locale('hacking_signal_lost_description'),
                    type = 'error',
                    position = config.NotifPosition,
                    icon = config.NotifIcon
                })
                if config.Emotes == 'rpemotes' then
                    exports["rpemotes"]:EmoteCancel(forceCancel)
                else
                    exports.scully_emotemenu:cancelEmote()
                end
            else
                local reward = math.random(config.MinReward, config.MaxReward)
                TriggerServerEvent('possible-phonehacking:server:giveReward', reward)
                if config.Emotes == 'rpemotes' then
                    exports["rpemotes"]:EmoteCancel(forceCancel)
                else
                    exports.scully_emotemenu:cancelEmote()
                end
            end
        else
            TriggerServerEvent('possible-phonehacking:server:removeRequiredItem')
            TriggerEvent('mhacking:hide')
            if config.Emotes == 'rpemotes' then
                exports["rpemotes"]:EmoteCancel(forceCancel)
            else
                exports.scully_emotemenu:cancelEmote()
            end
            lib.notify({
                title = locale('hacking_failed_title'),
                description = locale('hacking_failed_description'),
                type = 'error',
                position = config.NotifPosition,
            })
            currentTargetPed = nil
        end
    else
        TriggerEvent('mhacking:hide')
        if config.Emotes == 'rpemotes' then
            exports["rpemotes"]:EmoteCancel(forceCancel)
        else
            exports.scully_emotemenu:cancelEmote()
        end
        lib.notify({
            title = locale('hacking_failed_title'),
            description = locale('hacking_failed_description'),
            type = 'error',
            position = config.NotifPosition,
        })
        currentTargetPed = nil
    end
end

RegisterNetEvent('possible-phonehacking:client:receivePoliceCount', function(count)
    policeCount = count
    if config.Debug then
        print('Police count: ' .. policeCount)
    end
end)

RegisterNetEvent('possible-phonehacking:client:startHack', function(ped)
    TriggerServerEvent('possible-phonehacking:server:requestPoliceCount')
    Wait(500)
    if policeCount >= config.MinimumPolice then
            if config.Emotes == "rpemotes" then
                exports["rpemotes"]:EmoteCommandStart("sms5")
            else
                exports.scully_emotemenu:playEmoteByCommand('sms5')
            end    
            currentTargetPed = ped
            TriggerEvent("mhacking:show")
            TriggerEvent("mhacking:start", math.random(6, 7), math.random(12, 15), OnHackDone)
        else
            lib.notify({
                title = locale('hacking_no_police_title'),
                description = locale('hacking_no_police_description'),
                type = 'error'
            })
        end
end)

RegisterNetEvent('possible-phonehacking:client:success', function(reward)
    local src = source
    TriggerServerEvent('possible-phonehacking:client:removeRequiredItem', src)
    lib.notify({
        title = locale('hacking_hack_successful_title'),
        description = locale('hacking_hack_successful_title') .. reward,
        type = 'success',
        position = config.NotifPosition
    })
end)
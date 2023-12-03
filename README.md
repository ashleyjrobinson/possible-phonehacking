# Possible Phone Hacking

[Preview]() //
[Discord/ Support](https://discord.gg/Gnb2S7uAdG)

## Dispatch

Project Sloth Dispatch - https://github.com/Project-Sloth/ps-dispatch

Copy & Paste the below into ps-dispatch/server/sv_dispatchcodes.lua

```
["phonehacking"] =  {displayCode = '10-90', description = "Potential phone hacker reported..", radius = 0, recipientList = {'police'}, blipSprite = 772, blipColour = 59, blipScale = 1.5, blipLength = 2, sound = "robberysound", offset = "false", blipflash = "false"},
```

Copy & Paste the below into ps-dispatch/client/cl_extraalerts.lua

```
---------------------------
-- Possible Phone Hacking --
---------------------------

local function PhoneHacking()
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    local gender = GetPedGender()
    TriggerServerEvent("dispatch:server:notify",{
        dispatchcodename = "phonehacking", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
        dispatchCode = "10-35",
        firstStreet = locationInfo,
        gender = gender,
        model = nil,
        plate = nil,
        priority = 2, -- priority
        firstColor = nil,
        automaticGunfire = false,
        origin = {
            x = currentPos.x,
            y = currentPos.y,
            z = currentPos.z
        },
        dispatchMessage = 'Phone Hacking Reported', -- message
        job = {"LEO", "police"} -- type or jobs that will get the alerts
    })
end
exports('PhoneHacking', PhoneHacking)
```

## Item

### qb-inventory/ lj-inventory

create an item named phone_hacker in your qb-core/shared/items.lua
```
['phonehacker'] 			 = {['name'] = 'phonehacker', 			  	['label'] = 'Phone Hacker', 			['weight'] = 750, 		['type'] = 'item', 		['image'] = 'phonehacker.png', 	['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Use for malicious activities..'},
```

### Ox_inventory

create an item named phonehacker in your ox_inventory/data/items.lua

```
['phonehacker'] = {
    label = 'Phone Hacker',
    weight = 750,
    description = 'Use for malicious activities..',
},
```

## Image

I've place the inventory image within the img folder, take this imagae and put it in your qb-inventory or ox-inventory imagery folder. Then delete the img folder within here.

##Support:

Join my Discord for support and roles.

https://discord.gg/5VU8MA7Tkz
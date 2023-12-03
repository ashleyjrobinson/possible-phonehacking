Config = {}

Config.Debug = true

Config.MinimumPolice = 0 -- Minimum police online to be able to hack a peds phone
Config.PoliceCallHackingChance = 100 -- Chance to call police when hacking a phone

Config.InventoryType = 'ox_inventory' -- Possible options: 'ox_inventory', 'qb-inventory' (use qb-inventory if lj-inventory or other qb-inv based invs)

Config.TargetType = 'ox_target'    -- Possible options: 'ox_target', qb-target
Config.TargetDistance = 2.5       -- Distance to target
Config.TargetLabel = 'Hack Phone' -- Label for the target
Config.MaxDistanceFromPed = 5.0       -- Max distance from ped before signal is lost

Config.NotifyType = 'ox_lib' -- Possible Options: ox_lib, okok, qb-notify
Config.OxlibPosition = 'top' -- Possible options (if using ox_lib): top, bottom, top-right, top-left, bottom-right, bottom-left

Config.AlreadyHackedNotifTitle = "There isn\"t a signal"
Config.AlreadyHackedNotifDescription = "This pedestrian has already been hacked."

Config.AlreadHackedQbNotif = "There isn\"t a signal. This pedestrian has already been hacked." -- This is for qb-notify

Config.SignalLostNotifTitle = "Signal Lost"
Config.SignalLostNotifDescription = "Hack cancelled - you have lost signal."

Config.SignalLostQbNotif = "Signal Lost. Hack cancelled - you have lost signal." -- This is for qb-notify

Config.AuthFailedNotifTitle = "Authentication Failed"
Config.AuthFailedNotifDescription = "Service disrupted, failed to hack the phone."

Config.AuthFailedQbNotif = "Authentication Failed. Service disrupted, failed to hack the phone." -- This is for qb-notify

Config.AlreadyHackedTitle = "Not today bucko"
Config.AlreadyHackedDescription = "This pedestrian has already been hacked."

Config.AlreadyHackQbNotif = "Not today bucko. This pedestrian has already been hacked." -- This is for qb-notify

Config.NoPoliceOnlineTitle = "Not today bucko"
Config.NoPoliceOnlineDescription = "Not enough police online!"

Config.NoPoliceOnlineQbNotif = "Not today bucko. Not enough police online!" -- This is for qb-notify

Config.RequiredItem = 'phonehacker' -- Required item to hack phones

Config.WiringTime = 7500 -- Time it takes to hack a phone 7000 = 7 seconds
Config.WiringProgressText = 'Wiring Bank Funds..'

Config.MinReward = 500 -- Minimum reward for hacking a phone
Config.MaxReward = 2000 -- Maximum reward for hacking a phone
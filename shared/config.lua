return {
    Debug = true,
    Framework = "qb", -- qb for qbcore and qbox or esx
    Police = {
        jobs = {
            "police"
        }
    },
    MinimumPolice = 0,
    Dispatch = 'ps-dispatch', -- If using ps-dispatch otherwise add your export in client policeCall function
    PoliceCallHackingChance = 100,
    QBInventory = false, -- If using qb-inventory set this to true
    RequiredItem = 'phonehacker',
    TargetType = 'ox_target', -- qb-target or ox_target
    ProgressDuration = 7500,
    TargetDistance = 2.5,
    TargetLabel = 'Hack Phone',
    MaxDistanceFromPed = 5.0,
    Emotes = 'scully_emotemenu', -- rpemotes or anything else for scully_emotemenu
    PossibleTerritories = true,  -- Integrates my paid territrory script - https://possible-scripts.tebex.io/package/6045013 set false if no likey
    TerritoriesInfluence = 10, -- Only relevant if PossibleTerritories is true
    TerritoriesRewardItem = 'cash', -- Only relevant if PossibleTerritories is true
    TerritoriesRewardAmount = 30, -- Only relevant if PossibleTerritories is true
    PossibleGangLevels = true,  -- Integrates my paid gang level script - https://possible-scripts.tebex.io/package/6036883 set false if no likey
    GangXPReward = 5, -- Only relevant if PossibleGangLevels is true
    MinReward = 500,
    MaxReward = 1250,
    NotifPosition = 'top'
}
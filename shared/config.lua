return {
    Debug = true,
    Framework = "qb",
    Police = {
        jobs = {
            "police"
        }
    },
    MinimumPolice = 0,
    Dispatch = 'ps-dispatch', -- If using qb-dispatch otherwise add your export in client policeCall function
    PoliceCallHackingChance = 100,
    QBInventory = false,
    RequiredItem = 'phonehacker',
    TargetType = 'ox_target',
    ProgressDuration = 7500,
    TargetDistance = 2.5,
    TargetLabel = 'Hack Phone',
    MaxDistanceFromPed = 5.0,
    Emotes = 'rpemotes',
    PossibleTerritories = true,
    PossibleGangLevels = true,
    MinReward = 500,
    MaxReward = 1250,
    NotifPosition = 'top'
}
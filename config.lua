Config = {}



Config.ShootAlert = true
Config.Debug = true -- Debug modu aktif/pasif

Config.AlertDistance = 150.0

Config.AlertJobs = { --true = ignore self for notify
    unemployed=false,
}
Config.BlipDuration = 10000


Config.ShotCooldown = 5000 




Config.DefaultAlerts = {
    shotfire = {
        title = "Ateş Edildi",
        description = "Yakınlarda ateş edildi.",
        notifyType = "inform",
        blip = "shotfire"
    },
    custom = {
        title = "Custom Alert",
        description = "Custom alert desc.",
        notifyType = "inform",
        blip = "custom"
    }
}


--blips https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips


Config.Blips = {
    shotfire = {
        sprite = 150441873,
        scale = 0.5,
        label = "Ateş Edildi",
        modifier = `blip_radius_search`,
        color = 1,
        areaSize = 10.0
    },

    custom = {
        sprite = 1754506823,
        scale = 0.5,
        label = "CUSTOM ALERT",
        modifier = `blip_deadeye_cross`,
        color = 1,
        areaSize = 15.0
    },
}
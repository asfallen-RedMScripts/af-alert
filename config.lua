Config = {}


Config.ShootAlert = true     
Config.Debug = false      


Config.AlertDistance = 150.0 -- Bildirim gönderilecek varsayılan maksimum mesafe
Config.BlipDuration = 10000  -- Blip'in ekranda kalma süresi (ms cinsinden)
Config.ShotCooldown = 5000   -- 2 ateşten sonra bildirimin tekrar tetiklenmemesi için gecikme süresi (ms cinsinden)


Config.AlertJobs = { --true olursa shootfire bildirimi göndermez.
    police = true,      
    sheriff = true,     
    unemployed = false 
}

-- Varsayılan bildirim tipleri
Config.DefaultAlerts = {
    shotfire = {
        title = "Ateş Edildi",
        description = "Yakınlarda ateş edildi.",
        notifyType = "inform",
        blip = "shotfire"
    },
    custom = {
        title = "Bildirim",
        description = "Özel bildirim.",
        notifyType = "inform",
        blip = "custom"
    }
}

-- Blip tipleri listesi
-- Tüm blip sprite ID'leri için: https://github.com/femga/rdr3_discoveries/tree/master/useful_info_from_rpfs/textures/blips
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
        label = "Bildirim",
        modifier = `blip_deadeye_cross`,
        color = 1,
        areaSize = 15.0
    },

}
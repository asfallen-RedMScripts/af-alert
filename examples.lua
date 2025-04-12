
--blip tipleri config'e eklenmeli robbery and emergency

exports['af-alert']:CallSendCustomAlert(
    "Valentine Bankası soyuluyor!", 
    200.0, 
    {"police", "sheriff"},
    {
        blipType = "robbery",
        title = "BANKA SOYGUNU",
        notifyType = "error"
    }
)

exports['af-alert']:CallSendCustomAlert(
    "Valentine'de yaralı var, acil tıbbi yardım gerekiyor!", 
    150.0, 
    {"doctor", "police"},
    {
        blipType = "emergency",
        title = "ACİL TIBBİ YARDIM",
        notifyType = "inform"
    }
)
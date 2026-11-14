TrainingConfig = TrainingConfig or {}

TrainingConfig.Precision = {
    duration = 60,
    targetCount = 3,
    aimDistance = 850,
    spawnRadius = 260,
    minSpacing = 80,
    minHeight = 24,
    maxHeight = 112,
    chickenSkin = 1,
}

TrainingConfig.Tracking = {
    duration = 60,
    targetCount = 2,
    aimDistance = 1000,
    strafeRange = 320,
    speed = 300,
    mode = "strafe",
    targetHeight = 56,
    chickenSkin = 2,
}

TrainingConfig.Peek = {
    duration = 60,
    minAngle = 15,
    maxAngle = 80,
    minDistance = 600,
    maxDistance = 1100,
    minLifetime = 0.6,
    maxLifetime = 1.1,
    minInterval = 0.35,
    maxInterval = 0.85,
    chickenSkin = 3,
}

TrainingConfig.TickRate = 0.05

TrainingConfig.Knives = {
    { cmd = "weapon_knife",              name = "Couteau classique" },
    { cmd = "weapon_knife_karambit",     name = "Karambit" },
    { cmd = "weapon_knife_butterfly",    name = "Butterfly" },
    { cmd = "weapon_knife_m9_bayonet",   name = "M9 Bayonet" },
    { cmd = "weapon_knife_bayonet",      name = "Bayonet" },
    { cmd = "weapon_knife_widow_maker",  name = "Talon" },
    { cmd = "weapon_knife_skeleton",     name = "Skeleton" },
    { cmd = "weapon_knife_stiletto",     name = "Stiletto" },
    { cmd = "weapon_knife_ursus",        name = "Ursus" },
    { cmd = "weapon_knife_outdoor",      name = "Nomad" },
    { cmd = "weapon_knife_cord",         name = "Paracord" },
    { cmd = "weapon_knife_survival",     name = "Survival" },
    { cmd = "weapon_knife_survival_bowie", name = "Bowie" },
    { cmd = "weapon_knife_flip",         name = "Flip" },
    { cmd = "weapon_knife_gut",          name = "Gut" },
    { cmd = "weapon_knife_falchion",     name = "Falchion" },
    { cmd = "weapon_knife_tactical",     name = "Huntsman" },
    { cmd = "weapon_knife_push",         name = "Shadow Daggers" },
    { cmd = "weapon_knifegg",            name = "Ghost Knife" },
}

TrainingConfig.Weapons = {
    { cmd = "weapon_ak47",          name = "AK-47" },
    { cmd = "weapon_m4a1",          name = "M4A4" },
    { cmd = "weapon_m4a1_silencer", name = "M4A1-S" },
    { cmd = "weapon_awp",           name = "AWP" },
    { cmd = "weapon_ssg08",         name = "Scout" },
    { cmd = "weapon_deagle",        name = "Desert Eagle" },
    { cmd = "weapon_usp_silencer",  name = "USP-S" },
    { cmd = "weapon_glock",         name = "Glock" },
    { cmd = "weapon_mp9",           name = "MP9" },
    { cmd = "weapon_mac10",         name = "MAC-10" },
    { cmd = "weapon_mp5sd",         name = "MP5-SD" },
    { cmd = "weapon_ump45",         name = "UMP-45" },
    { cmd = "weapon_p90",          name = "P90" },
    { cmd = "weapon_famas",         name = "FAMAS" },
    { cmd = "weapon_galilar",       name = "Galil" },
    { cmd = "weapon_aug",           name = "AUG" },
    { cmd = "weapon_sg556",         name = "SG 553" },
    { cmd = "weapon_nova",          name = "Nova" },
    { cmd = "weapon_mag7",          name = "MAG-7" },
    { cmd = "weapon_negev",         name = "Negev" },
    { cmd = "weapon_tec9",          name = "Tec-9" },
    { cmd = "weapon_cz75a",         name = "CZ75" },
    { cmd = "weapon_revolver",      name = "R8" },
}

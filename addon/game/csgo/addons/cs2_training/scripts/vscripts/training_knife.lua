TrainingKnife = TrainingKnife or {}

function TrainingKnife.FindByName(query)
    local q = string.lower(query)
    for _, k in pairs(TrainingConfig.Knives) do
        if string.lower(k.name) == q or string.lower(k.cmd) == q then
            return k
        end
    end
    for _, k in pairs(TrainingConfig.Knives) do
        if string.find(string.lower(k.name), q, 1, true) or string.find(string.lower(k.cmd), q, 1, true) then
            return k
        end
    end
    return nil
end

function TrainingKnife.List(controller)
    local names = {}
    for _, k in pairs(TrainingConfig.Knives) do
        table.insert(names, k.name)
    end
    TrainingUtils.Chat(controller, "\x01[AIM] \x04Couteaux : " .. table.concat(names, ", "))
    TrainingUtils.Chat(controller, "\x01[AIM] \x04Usage : !knife <nom>  (ex: !knife karambit)")
end

function TrainingKnife.Give(controller, query)
    local pawn = TrainingUtils.Pawn(controller)
    if pawn == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x02Pas de personnage actif.")
        return
    end
    if query == nil or query == "" then
        TrainingKnife.List(controller)
        return
    end
    local knife = TrainingKnife.FindByName(query)
    if knife == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x02Couteau inconnu : " .. query .. " (voir !knife)")
        TrainingKnife.List(controller)
        return
    end
    TrainingUtils.StripWeapons(pawn)
    TrainingUtils.GiveItem(pawn, knife.cmd)
    TrainingUtils.GiveItem(pawn, "weapon_glock")
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. TrainingUtils.FormatName(controller)
        .. " a pris le couteau : " .. knife.name)
end

function TrainingKnife.FindWeapon(query)
    local q = string.lower(query)
    for _, w in pairs(TrainingConfig.Weapons) do
        if string.lower(w.cmd) == q or string.lower(w.name) == q then
            return w
        end
    end
    return nil
end

function TrainingKnife.ListWeapons(controller)
    local names = {}
    for _, w in pairs(TrainingConfig.Weapons) do
        table.insert(names, w.name)
    end
    TrainingUtils.Chat(controller, "\x01[AIM] \x04Armes : " .. table.concat(names, ", "))
    TrainingUtils.Chat(controller, "\x01[AIM] \x04Usage : !weapon <nom>  (ex: !weapon ak47)")
end

function TrainingKnife.GiveWeapon(controller, query)
    local pawn = TrainingUtils.Pawn(controller)
    if pawn == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x02Pas de personnage actif.")
        return
    end
    if query == nil or query == "" then
        TrainingKnife.ListWeapons(controller)
        return
    end
    local w = TrainingKnife.FindWeapon(query)
    if w == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x02Arme inconnue : " .. query .. " (voir !weapon)")
        return
    end
    TrainingUtils.GiveItem(pawn, w.cmd)
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. TrainingUtils.FormatName(controller)
        .. " a pris : " .. w.name)
end

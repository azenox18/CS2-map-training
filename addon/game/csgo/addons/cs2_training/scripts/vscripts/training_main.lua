if Training ~= nil and Training.Handles ~= nil then
    for _, h in pairs(Training.Handles) do
        pcall(StopListeningToGameEvent, h)
    end
    if Training.Sessions ~= nil then
        for key, _ in pairs(Training.Sessions) do
            pcall(Training.StopSessionByController, key)
        end
    end
end

Training = Training or {}
Training.Sessions = {}
Training.Bests = {}
Training.Handles = {}
Training.Ammo = false

Training.Modes = {
    precision = TrainingPrecision,
    tracking = TrainingTracking,
    peek = TrainingPeek,
}

Training.ModeAliases = {
    ["precision"] = "precision",
    ["gridshot"] = "precision",
    ["grid"] = "precision",
    ["tracking"] = "tracking",
    ["track"] = "tracking",
    ["peek"] = "peek",
    ["reaction"] = "peek",
}

function Training.GetSession(controller)
    return Training.Sessions[controller:entindex()]
end

function Training.StopSessionByController(key)
    local session = Training.Sessions[key]
    if session == nil then return end
    local module = Training.Modes[session.mode]
    if module ~= nil then
        pcall(module.Stop, session)
    end
    Training.Sessions[key] = nil
    if session.finished ~= true then
        TrainingUtils.ChatAll("\x01[AIM] \x04" .. session.controllerName .. " : session " .. session.mode .. " arretee.")
    end
end

function Training.StopSession(controller)
    Training.StopSessionByController(controller:entindex())
end

function Training.FinishSession(session)
    local module = Training.Modes[session.mode]
    if module ~= nil then
        pcall(module.Stop, session)
    end
    session.finished = true

    local bestKey = session.key
    Training.Bests[bestKey] = Training.Bests[bestKey] or {}
    local prev = Training.Bests[bestKey][session.mode] or -1
    local isRecord = session.score > prev
    if isRecord then
        Training.Bests[bestKey][session.mode] = session.score
    end

    local summary = module ~= nil and module.Summary(session) or (session.mode .. " termine")
    TrainingUtils.ChatAll("\x01[AIM] \x10" .. session.controllerName .. " \x01" .. summary)
    if isRecord then
        TrainingUtils.ChatAll("\x01[AIM] \x06NOUVEAU RECORD PERSO !")
    end
    Training.Sessions[session.key] = nil
end

function Training.StartSession(controller, modeName)
    local pawn = TrainingUtils.Pawn(controller)
    if pawn == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x02Tu n'as pas de personnage actif.")
        return
    end

    if Training.Sessions[controller:entindex()] ~= nil then
        Training.StopSession(controller)
    end

    local duration = TrainingConfig.Precision.duration
    if modeName == "tracking" then duration = TrainingConfig.Tracking.duration end
    if modeName == "peek" then duration = TrainingConfig.Peek.duration end

    local origin = pawn:GetAbsOrigin()
    local session = {
        mode = modeName,
        key = controller:entindex(),
        controller = controller,
        controllerName = TrainingUtils.FormatName(controller),
        pawn = pawn,
        groundZ = origin[3],
        score = 0,
        misses = 0,
        elapsed = 0,
        timeLeft = duration,
        duration = duration,
        targets = {},
        spawnIndex = 0,
    }
    Training.Sessions[session.key] = session

    Training.Modes[modeName].Start(session)
    TrainingUtils.Chat(controller, "\x01[AIM] \x04Duree : " .. duration .. "s. !stop pour arreter, !score pour tes records.")
end

function Training.EnsureManager()
    if Training.Manager ~= nil and TrainingUtils.IsValidEnt(Training.Manager) then
        return
    end
    Training.Manager = SpawnEntityFromTableSynchronous("info_target", {
        targetname = "training_manager",
    })
    Training.Manager:SetContextThink("training_think", Training.Think, TrainingConfig.TickRate)
end

function Training.Think()
    local ok, err = pcall(Training.TickSessions, TrainingConfig.TickRate)
    if not ok then
        print("[AIM] erreur think: " .. tostring(err))
    end
    return TrainingConfig.TickRate
end

function Training.TickSessions(dt)
    for key, session in pairs(Training.Sessions) do
        if not TrainingUtils.IsValidEnt(session.pawn) then
            Training.StopSessionByController(key)
        else
            local module = Training.Modes[session.mode]
            if module == nil then
                Training.StopSessionByController(key)
            else
                module.Tick(session, dt)
                session.timeLeft = session.timeLeft - dt
                if session.timeLeft <= 10 and not session.warned then
                    session.warned = true
                    TrainingUtils.Chat(session.controller, "\x01[AIM] \x0410 dernieres secondes !")
                end
                if session.timeLeft <= 0 then
                    Training.FinishSession(session)
                end
            end
        end
    end
end

function Training.OnOtherDeath(event)
    local victim = EntIndexToHScript(event.otherid)
    if victim == nil then return end
    local name = victim:GetName()
    local mode, key = string.match(name or "", "^trg_(%w+)_(%d+)_")
    if mode == nil or key == nil then return end

    local attacker = TrainingUtils.ControllerFromUserid(tonumber(event.attacker))
    if attacker == nil then return end
    local session = Training.Sessions[tonumber(key)]
    if session == nil then return end
    if session.key ~= attacker:entindex() then return end
    if session.mode ~= mode then return end

    local module = Training.Modes[mode]
    if module ~= nil then
        module.OnTargetDeath(session)
    end
end

function Training.OnChat(event)
    local text = event.text or ""
    if string.sub(text, 1, 1) ~= "!" then return end
    local cmd, arg = string.match(text, "^!(%S+)%s*(.-)%s*$")
    if cmd == nil then return end
    cmd = string.lower(cmd)

    local controller = TrainingUtils.ControllerFromChatEvent(event)
    if controller == nil then return end

    if Training.ModeAliases[cmd] ~= nil then
        Training.StartSession(controller, Training.ModeAliases[cmd])
    elseif cmd == "stop" then
        Training.StopSession(controller)
    elseif cmd == "score" or cmd == "scores" then
        Training.ShowBests(controller)
    elseif cmd == "knife" or cmd == "couteau" then
        TrainingKnife.Give(controller, arg)
    elseif cmd == "weapon" or cmd == "arme" then
        TrainingKnife.GiveWeapon(controller, arg)
    elseif cmd == "bots" then
        Training.AddBots(arg)
    elseif cmd == "nobots" then
        Training.KickBots()
    elseif cmd == "ammo" then
        Training.ToggleInfiniteAmmo()
    elseif cmd == "aide" or cmd == "help" then
        Training.Help(controller)
    end
end

function Training.AddBots(arg)
    local count = tonumber(arg) or 1
    if count < 1 then count = 1 end
    if count > 10 then count = 10 end
    SendToServerConsole("bot_difficulty 3")
    SendToServerConsole("bot_quota_mode normal")
    for _ = 1, count do
        SendToServerConsole("bot_add_t")
    end
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. count .. " bot(s) ajoute(s) (difficulte max).")
end

function Training.KickBots()
    SendToServerConsole("bot_kick all")
    TrainingUtils.ChatAll("\x01[AIM] \x04Bots retires.")
end

function Training.ToggleInfiniteAmmo()
    Training.Ammo = not Training.Ammo
    SendToServerConsole(Training.Ammo and "sv_infinite_ammo 2" or "sv_infinite_ammo 0")
    TrainingUtils.ChatAll("\x01[AIM] \x04Munitions infinies : " .. (Training.Ammo and "ON" or "OFF"))
end

function Training.ShowBests(controller)
    local bests = Training.Bests[controller:entindex()]
    if bests == nil then
        TrainingUtils.Chat(controller, "\x01[AIM] \x04Aucun record encore. Lance !precision, !tracking ou !peek !")
        return
    end
    for mode, score in pairs(bests) do
        TrainingUtils.Chat(controller, "\x01[AIM] \x04Record " .. mode .. " : " .. score)
    end
end

function Training.Help(controller)
    local lines = {
        "\x01[AIM] \x10=== MAP D'ENTRAINEMENT AIM ===",
        "\x01[AIM] \x04!precision \x01(ou !gridshot) : 3 cibles qui repop quand tu tires",
        "\x01[AIM] \x04!tracking \x01: cibles en mouvement a suivre",
        "\x01[AIM] \x04!peek \x01: cibles qui pop gauche/droite, reaction !",
        "\x01[AIM] \x04!stop \x01: arreter la session",
        "\x01[AIM] \x04!score \x01: tes records personnels",
        "\x01[AIM] \x04!knife <nom> \x01: choisir un couteau (!knife pour la liste)",
        "\x01[AIM] \x04!weapon <nom> \x01: choisir une arme (!weapon pour la liste)",
        "\x01[AIM] \x04!bots <n> \x01/ !nobots : ajouter/enlever des bots",
        "\x01[AIM] \x04!ammo \x01: munitions infinies on/off",
        "\x01[AIM] \x01Chaque joueur a sa propre session : tes amis peuvent jouer en meme temps !",
    }
    for _, line in pairs(lines) do
        TrainingUtils.Chat(controller, line)
    end
end

function Training.OnPlayerSpawned(event)
    local controller = event.userid
    if controller == nil then return end
    TrainingUtils.Chat(controller, "\x01[AIM] \x10Bienvenue ! Tape \x04!aide\x10 dans le chat pour la liste des exercices.")
end

function Training.Init()
    table.insert(Training.Handles, ListenToGameEvent("player_chat", function(event)
        pcall(Training.OnChat, event)
    end, nil))
    table.insert(Training.Handles, ListenToGameEvent("other_death", function(event)
        pcall(Training.OnOtherDeath, event)
    end, nil))
    table.insert(Training.Handles, ListenToGameEvent("player_spawned", function(event)
        pcall(Training.OnPlayerSpawned, event)
    end, nil))

    SendToServerConsole("mp_warmup_end")
    SendToServerConsole("mp_freezetime 0")
    SendToServerConsole("mp_roundtime 60")
    SendToServerConsole("mp_maxrounds 1000")
    SendToServerConsole("mp_buytime 9999")
    SendToServerConsole("mp_buy_anywhere 1")

    Training.EnsureManager()
    TrainingUtils.ChatAll("\x01[AIM] \x10Map d'entrainement chargee ! Tape \x04!aide\x10 pour commencer.")
end

Training.Init()

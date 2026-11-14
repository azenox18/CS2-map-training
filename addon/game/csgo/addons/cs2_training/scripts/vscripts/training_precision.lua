TrainingPrecision = TrainingPrecision or {}

function TrainingPrecision.PickPosition(session)
    local cfg = TrainingConfig.Precision
    local pawn = session.pawn
    if pawn == nil then return nil end
    local eye = TrainingUtils.EyeOrigin(pawn)
    local fwd = TrainingUtils.FlatForward(pawn)
    local groundZ = session.groundZ

    for _ = 1, 40 do
        local angle = RandomFloat(0, 2 * math.pi)
        local dist = RandomFloat(0, cfg.spawnRadius)
        local pos = Vector(
            eye[1] + fwd[1] * cfg.aimDistance + math.cos(angle) * dist,
            eye[2] + fwd[2] * cfg.aimDistance + math.sin(angle) * dist,
            groundZ + RandomFloat(cfg.minHeight, cfg.maxHeight)
        )
        local ok = true
        for _, t in pairs(session.targets) do
            if TrainingUtils.IsValidEnt(t.ent) and TrainingUtils.Distance2D(pos, t.pos) < cfg.minSpacing then
                ok = false
                break
            end
        end
        if ok then return pos end
    end
    return nil
end

function TrainingPrecision.SpawnTarget(session)
    local cfg = TrainingConfig.Precision
    local pos = TrainingPrecision.PickPosition(session)
    if pos == nil then return end
    local name = "trg_precision_" .. session.key .. "_" .. session.spawnIndex
    session.spawnIndex = session.spawnIndex + 1
    local ent = TrainingUtils.SpawnChicken(name, pos, cfg.chickenSkin)
    if ent == nil then return end
    table.insert(session.targets, { ent = ent, pos = pos })
end

function TrainingPrecision.Start(session)
    local cfg = TrainingConfig.Precision
    session.spawnIndex = 0
    session.targets = {}
    for _ = 1, cfg.targetCount do
        TrainingPrecision.SpawnTarget(session)
    end
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. TrainingUtils.FormatName(session.controller) .. " lance PRECISION : "
        .. cfg.targetCount .. " cibles, tue-les, elles repop ailleurs !")
end

function TrainingPrecision.Tick(session, dt)
    local cfg = TrainingConfig.Precision
    for i = #session.targets, 1, -1 do
        local t = session.targets[i]
        if not TrainingUtils.IsValidEnt(t.ent) then
            table.remove(session.targets, i)
            TrainingPrecision.SpawnTarget(session)
        else
            t.ent:SetAbsOrigin(t.pos)
            t.ent:SetVelocity(Vector(0, 0, 0))
        end
    end
    while #session.targets < cfg.targetCount do
        TrainingPrecision.SpawnTarget(session)
        if #session.targets == 0 then break end
    end
end

function TrainingPrecision.OnTargetDeath(session)
    session.score = session.score + 1
    TrainingPrecision.SpawnTarget(session)
end

function TrainingPrecision.Stop(session)
    for _, t in pairs(session.targets) do
        TrainingUtils.RemoveEnt(t.ent)
    end
    session.targets = {}
end

function TrainingPrecision.Summary(session)
    local tps = session.score / math.max(session.duration, 1)
    return string.format("PRECISION : %d cibles en %ds (%.2f cibles/s)",
        session.score, session.duration, tps)
end

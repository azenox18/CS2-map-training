TrainingTracking = TrainingTracking or {}

function TrainingTracking.SpawnTarget(session, phase)
    local cfg = TrainingConfig.Tracking
    local name = "trg_tracking_" .. session.key .. "_" .. session.spawnIndex
    session.spawnIndex = session.spawnIndex + 1
    local pos = TrainingTracking.TargetPosition(session, phase)
    local ent = TrainingUtils.SpawnChicken(name, pos, cfg.chickenSkin)
    if ent == nil then return end
    table.insert(session.targets, { ent = ent, phase = phase })
end

function TrainingTracking.TargetPosition(session, phase)
    local cfg = TrainingConfig.Tracking
    local center = session.center
    local axis = session.axis
    return Vector(
        center[1] + axis[1] * math.sin(phase) * cfg.strafeRange,
        center[2] + axis[2] * math.sin(phase) * cfg.strafeRange,
        session.groundZ + cfg.targetHeight
    )
end

function TrainingTracking.Start(session)
    local cfg = TrainingConfig.Tracking
    local pawn = session.pawn
    local eye = TrainingUtils.EyeOrigin(pawn)
    local fwd = TrainingUtils.FlatForward(pawn)
    local right = TrainingUtils.FlatRight(pawn)
    session.center = Vector(eye[1] + fwd[1] * cfg.aimDistance, eye[2] + fwd[2] * cfg.aimDistance, 0)
    session.axis = cfg.mode == "orbit" and fwd or right
    session.spawnIndex = 0
    session.targets = {}
    for i = 1, cfg.targetCount do
        TrainingTracking.SpawnTarget(session, (i - 1) * (2 * math.pi / cfg.targetCount))
    end
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. TrainingUtils.FormatName(session.controller)
        .. " lance TRACKING : suis les cibles en mouvement !")
end

function TrainingTracking.Tick(session, dt)
    local cfg = TrainingConfig.Tracking
    local angularSpeed = cfg.speed / cfg.strafeRange
    for i = #session.targets, 1, -1 do
        local t = session.targets[i]
        if not TrainingUtils.IsValidEnt(t.ent) then
            table.remove(session.targets, i)
            TrainingTracking.SpawnTarget(session, RandomFloat(0, 2 * math.pi))
        else
            t.phase = t.phase + dt * angularSpeed
            local pos = TrainingTracking.TargetPosition(session, t.phase)
            t.ent:SetAbsOrigin(pos)
            t.ent:SetVelocity(Vector(0, 0, 0))
        end
    end
    while #session.targets < cfg.targetCount do
        TrainingTracking.SpawnTarget(session, RandomFloat(0, 2 * math.pi))
        if #session.targets == 0 then break end
    end
end

function TrainingTracking.OnTargetDeath(session)
    session.score = session.score + 1
    TrainingTracking.SpawnTarget(session, RandomFloat(0, 2 * math.pi))
end

function TrainingTracking.Stop(session)
    for _, t in pairs(session.targets) do
        TrainingUtils.RemoveEnt(t.ent)
    end
    session.targets = {}
end

function TrainingTracking.Summary(session)
    local tps = session.score / math.max(session.duration, 1)
    return string.format("TRACKING : %d cibles touchees en %ds (%.2f/s)",
        session.score, session.duration, tps)
end

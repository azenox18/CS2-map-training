TrainingPeek = TrainingPeek or {}

function TrainingPeek.PopTarget(session)
    local cfg = TrainingConfig.Peek
    local pawn = session.pawn
    if pawn == nil then return end
    local eye = TrainingUtils.EyeOrigin(pawn)
    local yaw = TrainingUtils.EyeAngles(pawn)[2]
    local offset = RandomFloat(cfg.minAngle, cfg.maxAngle)
    if RandomInt(0, 1) == 1 then offset = -offset end
    local targetYaw = math.rad(yaw + offset)
    local dist = RandomFloat(cfg.minDistance, cfg.maxDistance)
    local pos = Vector(
        eye[1] + math.cos(targetYaw) * dist,
        eye[2] + math.sin(targetYaw) * dist,
        session.groundZ + RandomFloat(32, 88)
    )
    local name = "trg_peek_" .. session.key .. "_" .. session.spawnIndex
    session.spawnIndex = session.spawnIndex + 1
    local ent = TrainingUtils.SpawnChicken(name, pos, cfg.chickenSkin)
    if ent == nil then return end
    table.insert(session.targets, {
        ent = ent,
        pos = pos,
        dieAt = session.elapsed + RandomFloat(cfg.minLifetime, cfg.maxLifetime),
    })
end

function TrainingPeek.Start(session)
    local cfg = TrainingConfig.Peek
    session.spawnIndex = 0
    session.targets = {}
    session.elapsed = 0
    session.nextPopAt = 0.5
    TrainingUtils.ChatAll("\x01[AIM] \x04" .. TrainingUtils.FormatName(session.controller)
        .. " lance PEEK : les cibles pop a gauche/droite, tire avant qu'elles disparaissent !")
end

function TrainingPeek.Tick(session, dt)
    local cfg = TrainingConfig.Peek
    session.elapsed = session.elapsed + dt

    for i = #session.targets, 1, -1 do
        local t = session.targets[i]
        if not TrainingUtils.IsValidEnt(t.ent) then
            table.remove(session.targets, i)
        elseif session.elapsed >= t.dieAt then
            session.misses = session.misses + 1
            TrainingUtils.RemoveEnt(t.ent)
            table.remove(session.targets, i)
        else
            t.ent:SetAbsOrigin(t.pos)
            t.ent:SetVelocity(Vector(0, 0, 0))
        end
    end

    if session.elapsed >= session.nextPopAt then
        TrainingPeek.PopTarget(session)
        session.nextPopAt = session.elapsed + RandomFloat(cfg.minInterval, cfg.maxInterval)
    end
end

function TrainingPeek.OnTargetDeath(session)
    session.score = session.score + 1
end

function TrainingPeek.Stop(session)
    for _, t in pairs(session.targets) do
        TrainingUtils.RemoveEnt(t.ent)
    end
    session.targets = {}
end

function TrainingPeek.Summary(session)
    local total = session.score + session.misses
    local acc = total > 0 and (100 * session.score / total) or 0
    return string.format("PEEK : %d touches / %d pops (%.0f%% de reussite)",
        session.score, total, acc)
end

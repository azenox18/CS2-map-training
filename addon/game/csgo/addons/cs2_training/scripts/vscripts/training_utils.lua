TrainingUtils = TrainingUtils or {}

function TrainingUtils.ChatAll(msg)
    ScriptPrintMessageChatAll(msg)
end

function TrainingUtils.CenterAll(msg)
    ScriptPrintMessageCenterAll(msg)
end

function TrainingUtils.Chat(controller, msg)
    if controller == nil then return end
    ScriptPrintMessageChatTeam(controller:GetTeamID(), msg)
end

function TrainingUtils.ControllerFromChatEvent(event)
    return event.userid
end

function TrainingUtils.ControllerFromUserid(userid)
    if userid == nil or userid <= 0 then return nil end
    return UserIDToControllerHScript(userid)
end

function TrainingUtils.Pawn(controller)
    if controller == nil then return nil end
    return controller:GetPawn()
end

function TrainingUtils.ForwardVector(angles)
    local pitch = math.rad(angles[1])
    local yaw = math.rad(angles[2])
    return Vector(
        math.cos(pitch) * math.cos(yaw),
        math.cos(pitch) * math.sin(yaw),
        -math.sin(pitch)
    )
end

function TrainingUtils.RightVector(angles)
    local yaw = math.rad(angles[2])
    return Vector(math.sin(yaw), -math.cos(yaw), 0)
end

function TrainingUtils.EyeAngles(pawn)
    if pawn == nil then return Vector(0, 0, 0) end
    local ang = pawn:EyeAngles()
    return Vector(ang[1], ang[2], ang[3])
end

function TrainingUtils.EyeOrigin(pawn)
    if pawn == nil then return Vector(0, 0, 0) end
    return pawn:EyePosition()
end

function TrainingUtils.FlatForward(pawn)
    local ang = TrainingUtils.EyeAngles(pawn)
    return Vector(math.cos(math.rad(ang[2])), math.sin(math.rad(ang[2])), 0)
end

function TrainingUtils.FlatRight(pawn)
    local ang = TrainingUtils.EyeAngles(pawn)
    return Vector(math.sin(math.rad(ang[2])), -math.cos(math.rad(ang[2])), 0)
end

function TrainingUtils.SpawnChicken(name, origin, skin)
    local ent = SpawnEntityFromTableSynchronous("chicken", {
        targetname = name,
        origin = origin,
        skin = skin or 0,
    })
    return ent
end

function TrainingUtils.RemoveEnt(ent)
    if ent and ent:IsValid() and not ent:IsMarkedForDeletion() then
        UTIL_Remove(ent)
    end
end

function TrainingUtils.IsValidEnt(ent)
    return ent ~= nil and ent:IsValid() and not ent:IsMarkedForDeletion()
end

function TrainingUtils.ClientCommandEntity()
    local cmd = Entities:FindByClassname(nil, "point_clientcommand")
    if cmd == nil then
        cmd = SpawnEntityFromTableSynchronous("point_clientcommand", {
            targetname = "training_clientcommand",
        })
    end
    return cmd
end

function TrainingUtils.GiveItem(pawn, item)
    if pawn == nil then return false end
    local cmd = TrainingUtils.ClientCommandEntity()
    DoEntFireByInstanceHandle(cmd, "Command", "give " .. item, 0, pawn, pawn)
    return true
end

function TrainingUtils.StripWeapons(pawn)
    if pawn == nil then return end
    local cmd = TrainingUtils.ClientCommandEntity()
    DoEntFireByInstanceHandle(cmd, "Command", "strip", 0, pawn, pawn)
end

function TrainingUtils.FormatName(controller)
    if controller == nil then return "?" end
    return controller:GetPlayerName()
end

function TrainingUtils.Distance2D(a, b)
    local dx = a[1] - b[1]
    local dy = a[2] - b[2]
    return math.sqrt(dx * dx + dy * dy)
end

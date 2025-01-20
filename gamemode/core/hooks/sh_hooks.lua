local KEY_BLACKLIST = IN_ATTACK + IN_ATTACK2
local isValid = IsValid
local mathAbs = math.abs

if SERVER then
    function GM:PlayerSwitchWeapon(ply, oldWep, newWep)
        ply:SetWeaponRaised(false)
    end
end

function GM:StartCommand(ply, mvData)
    if not ply:Alive() then return end

    if not ply:IsWeaponRaised() then
        mvData:RemoveKey(IN_ATTACK)
    end

    if SERVER then
        local dragger = ply.ArrestedDragger

        if IsValid(dragger) and ply == dragger.ArrestedDragging and ply:Alive() and dragger:Alive() then
            mvData:ClearMovement()
            mvData:ClearButtons()

            local targetPos = dragger:GetPos() + dragger:GetForward() * 60
            if ply:GetPos():DistToSqr(targetPos) > 1 then
                mvData:SetForwardMove(200)
            end

            mvData:SetViewAngles((targetPos - ply:GetShootPos()):GetNormalized():Angle())
        end
    else
        mvData:RemoveKey(IN_ZOOM)
    end
end

function GM:Move(ply, mvData)
    if not ply:Alive() then return end

    if ply:GetMoveType() == MOVETYPE_WALK and (ply:HasBrokenLegs() or mvData:KeyDown(IN_WALK)) then
        local speed = ply:GetWalkSpeed()
        local ratio = impulse.Config.SlowWalkRatio

        local forwardRatio = 0
        if mvData:KeyDown(IN_FORWARD) then
            forwardRatio = ratio
        elseif mvData:KeyDown(IN_BACK) then
            forwardRatio = -ratio
        end

        local sideRatio = 0
        if mvData:KeyDown(IN_MOVELEFT) then
            sideRatio = -ratio
        elseif mvData:KeyDown(IN_MOVERIGHT) then
            sideRatio = ratio
        end

        mvData:SetForwardSpeed(forwardRatio * speed)
        mvData:SetSideSpeed(sideRatio * speed)
    end
end

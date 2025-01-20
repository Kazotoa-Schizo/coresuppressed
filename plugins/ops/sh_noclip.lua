hook.Add("PlayerNoClip", "opsNoclip", function(ply, state)
	if ply:IsAdmin() then
		if SERVER then
			if state then
				impulse.Ops.Cloak(ply)
				ply:GodEnable()
				ply:SetCollisionGroup(COLLISION_GROUP_WEAPON)

				if ply:FlashlightIsOn() then
					ply:Flashlight(false)
				end

				ply:AllowFlashlight(false)
				ply:Give("gmod_tool")
			else
				impulse.Ops.Uncloak(ply)
				ply:GodDisable()
				ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
				--ply:EmitSound("ambient/energy/zap1.wav")
				
				if ply:HasInventoryItem("item_buildingkit") then
					local inv = ply:GetInventory(1)

					for k,v in pairs(inv) do
						if v.class == "item_buildingkit" and not v.equipped then
							ply:StripWeapon("gmod_tool")
							break
						end
					end
				end
				
				if not ply:HasInventoryItem("item_buildingkit") then
					ply:StripWeapon("gmod_tool")	
				end
				
				--
				if(ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA) then
					ply:AllowFlashlight(true)
				elseif(ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_REBEL and ply:HasInventoryItem("item_flashlight")) then
					local inv = ply:GetInventory(1)

					for k,v in pairs(inv) do
						if v.equipped and v.class == "item_flashlight" then
							ply:AllowFlashlight(true)
							break
						end
					end
				end

			end
		end

		return true
	end

	return false
end)
impulse.Skills = impulse.Skills or {}
impulse.Skills.Skills = impulse.Skills.Skills or {}
impulse.Skills.NiceNames = impulse.Skills.NiceNames or {}
impulse.Skills.Data = impulse.Skills.Data or {}
local count = 0

function impulse.Skills.Define(name, niceName)
	count = count + 1
	impulse.Skills.Skills[name] = count
	impulse.Skills.NiceNames[name] = niceName
end

function impulse.Skills.GetNiceName(name)
	return impulse.Skills.NiceNames[name]
end

if CLIENT then
	function meta:GetSkillXP(name)
		local xp = impulse.Skills.Data[name]
		
		return xp or 0
	end

	function impulse.Skills.GetLevelXPRequirement(level)
		local req = 0

		if(level == 1) then
			req = 0
		elseif(level == 2) then
			req = 375
		elseif(level == 3) then
			req = 750
		elseif(level == 4) then
			req = 1125
		elseif(level == 5) then
			req = 1500
		end
		
		return math.Clamp(req, 0, 1500)
	end
end

function meta:GetSkillLevel(name)
	local xp = self:GetSkillXP(name)
	local req = 0

	if(xp < 375) then
		return 1
	elseif(xp < 750) then
		return 2
	elseif(xp < 1125) then
		return 3
	elseif(xp < 1500) then
		return 4
	else
		return 5
	end
end

impulse.Skills.Define("craft", "Crafting")
--impulse.Skills.Define("medicine", "Medicine")
--impulse.Skills.Define("strength", "Strength")
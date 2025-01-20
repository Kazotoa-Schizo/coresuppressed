function meta:GetSkillXP(name)
	local skills = self.impulseSkills
	if not skills then return end

	if skills[name] then
		return skills[name]
	else
		return 0
	end
end

function meta:SetSkillXP(name, value)
	if not self.impulseSkills then return end
	if not impulse.Skills.Skills[name] then return end

	value = math.Round(value)

	self.impulseSkills[name] = value

	local data = util.TableToJSON(self.impulseSkills)

	if data then
		local query = mysql:Update("impulse_players")
		query:Update("skills", data)
		query:Where("steamid", self:SteamID())
		query:Execute()
	end

	self:NetworkSkill(name, value)
end

function meta:NetworkSkill(name, value)
	net.Start("impulseSkillUpdate")
	net.WriteUInt(impulse.Skills.Skills[name], 4)
	net.WriteUInt(value, 16)
	net.Send(self)
end

function meta:AddSkillXP(name, value)
	if not self.impulseSkills then return end

	local cur = self:GetSkillXP(name)
	local new = math.Round(math.Clamp(cur + value, 0, 1500))

	if cur != new then
		self:SetSkillXP(name, new)
		hook.Run("PlayerAddSkillXP", self, new, name)
	end
end

function meta:AddVitality(level, value)
    if not self.impulseSkills then return end

    local currentVitalityXP = self:GetSkillLevel("vitality")

    local xpGain = value * 0.5

    if currentVitalityXP < level then
        if level == 1 then
            self:AddSkillXP("vitality", currentVitalityXP + xpGain)
        elseif level == 2 then
            if currentVitalityXP < 1 then
                self:AddSkillXP("vitality", currentVitalityXP + xpGain)
            end
        elseif level == 3 then
            if currentVitalityXP < 2 then
                self:AddSkillXP("vitality", currentVitalityXP + xpGain)
            end
        elseif level == 4 then
            if currentVitalityXP < 3 then
                self:AddSkillXP("vitality", currentVitalityXP + xpGain)
            end
        elseif level == 5 then
            self:AddSkillXP("vitality", currentVitalityXP + xpGain)
        end

        hook.Run("PlayerAddSkillXP", self, currentVitalityXP + xpGain, "vitality")
    end
end
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
   self:SetModel("models/props_combine/breenconsole.mdl")
   self:PhysicsInit(SOLID_VPHYSICS)
   self:SetSolid(SOLID_VPHYSICS)
   self:SetUseType(SIMPLE_USE)
   
    local phys = self:GetPhysicsObject()
    if ( phys:IsValid() ) then
        phys:Wake()
    end
end

function ENT:Use(activator, caller)
    if activator:Team() == impulse.Config.DefaultTeam then
        activator.currentCosmeticEditor = self
        net.Start("impulseCharacterEditorOpen")
        net.Send(activator)
    else
        activator:Notify("You must be in the "..team.GetName(impulse.Config.DefaultTeam).." team to change your appearance.")
    end
end
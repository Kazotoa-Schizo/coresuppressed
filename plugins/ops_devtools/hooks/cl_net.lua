net.Receive("opsDevOpen",function()
    local lp = LocalPlayer()
    if not lp then return end
    if not lp:IsOwner() then return end
    impulse.DevTools = vgui.Create("impulseOpsDevTools") 
end)
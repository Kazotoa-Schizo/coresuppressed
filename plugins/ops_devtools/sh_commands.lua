local devCommand = {
    description = "A super-secret tool for only the most worthy people.",
    requiresArg = false,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not ply:IsSuperAdmin() then
            return ply:Notify("You must be a developer to use this tool!")
        end
        
        net.Start("opsDevOpen")
        net.Send(ply)
    end
}

impulse.RegisterChatCommand("/controlpanel", devCommand)
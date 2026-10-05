-- gm_fill
--- fills health
-- gm_filla
--- fills health and armor
-- gm_fillae
--- fills target's health and armor

local spam = function(name, func, count, t)
    return function()
        for i = 1, count do
            if t then
                timer.Simple(t * (i - 1), function() RunConsoleCommand(func, name) end)
            else
                RunConsoleCommand(func, name)
            end
        end
    end
end

local typefuncs = {
    weapon = "swep",
    entity = "sent",
    model = "",
    vehicle = "vehicle",
    prop = ""
}

local gettypecontent = {
    model = "GetModelName",
    prop = "GetModelName",
    vehicle = "GetSpawnName",
    entity = "GetSpawnName",
    npc = "GetSpawnName",
    weapon = "GetSpawnName",
}

-- oh my goD???
hook.Add("SpawnMenuCreated", "SAdminCon_UpdateIcon", function() end)
spawnmenu.AddContentType("model", function(container, obj)
    if not isstring(obj.model) then obj.model = "" end
    local icon = vgui.Create("SpawnIcon", container)
    if obj.body then obj.body = string.Trim(tostring(obj.body), "B") end
    if obj.wide then icon:SetWide(obj.wide) end
    if obj.tall then icon:SetTall(obj.tall) end
    icon:InvalidateLayout(true)
    icon:SetModel(obj.model, obj.skin or 0, obj.body)
    icon:SetTooltip(string.Replace(string.GetFileFromFilename(obj.model), ".mdl", ""))
    icon.DoClick = function(s)
        surface.PlaySound("ui/buttonclickrelease.wav")
        RunConsoleCommand("gm_spawn", s:GetModelName(), s:GetSkinID() or 0, s:GetBodyGroup() or "")
    end

    icon.OpenMenu = function(pnl)
        if pnl:GetParent() and pnl:GetParent().ContentContainer then -- Use the containter that we are dragged onto, not the one we were created on
            container = pnl:GetParent().ContentContainer
        end

        local menu = DermaMenu()
        menu:AddOption("#spawnmenu.menu.copy", function() SetClipboardText(string.gsub(obj.model, "\\", "/")) end):SetIcon("icon16/page_copy.png")
        menu:AddOption("#spawnmenu.menu.spawn_with_toolgun", function()
            RunConsoleCommand("gmod_tool", "creator")
            RunConsoleCommand("creator_type", "4")
            RunConsoleCommand("creator_name", obj.model)
        end):SetIcon("icon16/brick_add.png")

        local submenu, submenu_opt = menu:AddSubMenu("#spawnmenu.menu.rerender", function() if IsValid(pnl) then pnl:RebuildSpawnIcon() end end)
        submenu_opt:SetIcon("icon16/picture_save.png")
        submenu:AddOption("#spawnmenu.menu.rerender_this", function() if IsValid(pnl) then pnl:RebuildSpawnIcon() end end):SetIcon("icon16/picture.png")
        submenu:AddOption("#spawnmenu.menu.rerender_all", function() if IsValid(container) then container:RebuildAll() end end):SetIcon("icon16/pictures.png")
        menu:AddOption("#spawnmenu.menu.edit_icon", function()
            if not IsValid(pnl) then return end
            local editor = vgui.Create("IconEditor")
            editor:SetIcon(pnl)
            editor:Refresh()
            editor:MakePopup()
            editor:Center()
        end):SetIcon("icon16/pencil.png")

        if isfunction(pnl.OpenMenuExtra) then pnl:OpenMenuExtra(menu) end
        hook.Run("SpawnmenuIconMenuOpen", menu, pnl, "model")
        if IsValid(pnl:GetParent()) and pnl:GetParent().GetReadOnly and pnl:GetParent():GetReadOnly() then -- Do not allow removal/size changes from read only panels
            menu:Open()
            return
        end

        pnl:InternalAddResizeMenu(menu, function(w, h)
            if not IsValid(pnl) then return end
            pnl:SetSize(w, h)
            pnl:InvalidateLayout(true)
            container:OnModified()
            container:Layout()
            pnl:SetModel(obj.model, obj.skin or 0, obj.body)
        end)

        menu:AddSpacer()
        menu:AddOption("#spawnmenu.menu.delete", function()
            if not IsValid(pnl) then return end
            pnl:Remove()
            hook.Run("SpawnlistContentChanged")
        end):SetIcon("icon16/bin_closed.png")

        menu:Open()
    end

    icon:InvalidateLayout(true)
    if IsValid(container) then container:Add(icon) end
    return icon
end)

local mins = Vector(-0.1, -0.1, -0.1)
local maxs = mins * -1
local GetEyeTrace = function()
    local lp = LocalPlayer()
    local tr = util.TraceHull({
        start = MainEyePos(),
        endpos = MainEyePos() + MainEyeAngles():Forward() * 1e6,
        filter = lp,
        mins = mins,
        maxs = maxs,
    })
    return tr
end

hook.Add("SpawnmenuIconMenuOpen", "SM_Spam", function(menu, icon, type)
    if (type == "postprocess") or (type == "tool") then return end
    local a = gettypecontent[type]
    a = icon[a]
    if isfunction(a) then a = a(icon) end
    if not a then return end
    local f = spam(a, "gm_spawn" .. (typefuncs[type] or type), 5)
    menu:AddOption("Spam " .. 5 .. "x", f)
    for i = 0, 20, 5 do
        if i == 0 then continue end
        local f = spam(a, "gm_spawn" .. (typefuncs[type] or type), i)
        menu:AddOption("Spam " .. i .. "x", f)
    end

    local f = spam(a, "gm_spawn" .. (typefuncs[type] or type), 5, 0.075)
    menu:AddOption("Spam (safe) " .. 5 .. "x", f, 0.35)
    for i = 0, 40, 5 do
        if i == 0 then continue end
        local f = spam(a, "gm_spawn" .. (typefuncs[type] or type), i, 0.075)
        menu:AddOption("Spam (safe) " .. i .. "x", f)
    end
end)

concommand.Add("gm_fill", function()
    if LocalPlayer():Health() < LocalPlayer():GetMaxHealth() then
        for i = 1, math.ceil((LocalPlayer():GetMaxHealth() - LocalPlayer():Health()) / 25) do
            RunConsoleCommand("gm_spawnsent", "item_healthkit")
        end
    end
end)

concommand.Add("gm_filla", function()
    if LocalPlayer():Health() < LocalPlayer():GetMaxHealth() then
        for i = 1, math.ceil((LocalPlayer():GetMaxHealth() - LocalPlayer():Health()) / 25) do
            RunConsoleCommand("gm_spawnsent", "item_healthkit")
        end
    end

    if LocalPlayer():Armor() < LocalPlayer():GetMaxArmor() then
        for i = 1, math.ceil((LocalPlayer():GetMaxArmor() - LocalPlayer():Armor()) / 15) do
            RunConsoleCommand("gm_spawnsent", "item_battery")
        end
    end
end)

concommand.Add("gm_fillae", function()
    local tr = GetEyeTrace()
    local t = tr.Entity
    if t:IsValid() and t:IsPlayer() then
        if t:Health() < t:GetMaxHealth() then
            for i = 1, math.ceil((t:GetMaxHealth() - t:Health()) / 25) do
                RunConsoleCommand("gm_spawnsent", "item_healthkit")
            end
        end

        if t:Armor() < t:GetMaxArmor() then
            for i = 1, math.ceil((t:GetMaxArmor() - t:Armor()) / 15) do
                RunConsoleCommand("gm_spawnsent", "item_battery")
            end
        end
    end
end)
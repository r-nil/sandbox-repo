FGCWEP_OldspawnmenuCreateContentIcon = FGCWEP_OldspawnmenuCreateContentIcon or spawnmenu.CreateContentIcon

FGCWEP_SERVERCLR = "<color=255,132,0,255>"
FGCWEP_SERVERLCLR = Color(255,132,0,255)

FGCWEP_DISCORDCLR = "<color=115,138,219,255>"
FGCWEP_DISCORDLCLR = Color(115,138,219,255)

FGCWEP_TEXTCLR = "<color=181,181,181,255>"
FGCWEP_TEXTLCLR = Color(181,181,181,255)

FGCWEP_COCONUTCLR = "<color=230,209,191,255>"
FGCWEP_COCONUTLCLR = Color(230,209,191,255)

FGCWEP_SERVER = "[server]"
FGCWEP_DISCORD = "[discord]"

FGCWEP_SERVERS = "[server] "
FGCWEP_DISCORDS = "[discord] "

FGCWEP_KNOWNSERVERS = {
    fgc = "https://discord.gg/K8eQYDKV5"
}

FGCWEP_KNOWNMEMBERS = {
    cere = {
        text = "cere",
        clr = "<color=23,255,255,255>",
        lclr = Color(23,255,255),
        group = "user+",
    },
    atom = {
        text = "Atomix27",
        clr = "<color=0,216,250,255>",
        lclr = Color(0,216,250),
        group = "genie",
    },
    phil = {
        text = "NephilisThy1",
        clr = "<color=200,0,0,255>",
        lclr = Color(200,0,0),
        group = "admin"
    },
    twoface = {
        text = "TwoFace17",
        clr = "<color=13,13,171,255>",
        lclr = Color(13,13,171),
        group = "superadmin"
    },
    ["nil"] = {
        text = "nil",--"nan_nil_null_nullptr_2",
        clr = "<color=0,0,0,255>",
        lclr = Color(0,0,0),
        group = "veteran"
    },
    egg = {
        text = "egg",
        clr = "<color=200,0,0,255>",
        lclr = Color(200,0,0),
        group = "admin"
    },
}

FGCWEP_KNOWNMEMBERS.cere_admin = FGCWEP_KNOWNMEMBERS.cere
FGCWEP_KNOWNMEMBERS.atom_admin = FGCWEP_KNOWNMEMBERS.atom
FGCWEP_KNOWNMEMBERS.phil_admin = FGCWEP_KNOWNMEMBERS.phil

FGCWEP_KNOWNMEMBERS["twoface, Atomix27"] = table.Copy(FGCWEP_KNOWNMEMBERS.twoface)
FGCWEP_KNOWNMEMBERS["twoface, Atomix27"].text = "twoface, Atomix27"
FGCWEP_KNOWNMEMBERS["twoface, Atomix27"].ishack = true

FGCWEP_KNOWNRANKS = util.JSONToTable([[{"tmod":{"r":137,"b":240,"a":255,"g":207},"member":{"r":47,"b":214,"a":255,"g":189},"veteran":{"r":255,"b":0,"a":255,"g":123},"user":{"r":255,"b":100,"a":255,"g":255},"mod":{"r":30,"b":255,"a":255,"g":30},"admin":{"r":255,"b":0,"a":255,"g":0},"donator":{"r":237,"b":249,"a":255,"g":59},"superadmin":{"r":161,"b":255,"a":255,"g":0},"trusted":{"r":38,"b":50,"a":255,"g":224}}]])

local rankcolors = {}
for i,v in pairs(FGCWEP_KNOWNRANKS) do
    table.insert(rankcolors,Color(v.r,v.g,v.b))
end

local gradup = Material("gui/gradient_up")
local graddown = Material("gui/gradient_down")
local gradright = Material("gui/gradient")
local gradleft = Material("vgui/gradient-r")

local currentcolor = rankcolors[1]
local targetcolor = rankcolors[2]

local currentcolor2 = rankcolors[1]
local targetcolor2 = rankcolors[2]

local nexttarget = 0

local dur = 2

function FGCWEP_PrintWeaponInfo(self,x,y,alpha,store,center,max)

	if not self.OriginalInfo then return end

    store = store or self

    local o = surface.GetAlphaMultiplier()
    surface.SetAlphaMultiplier(alpha / 255)

	if not store.InfoMarkup then
        local info = self.OriginalInfo
        local str = "<font=ChatFont>"

        if info.name then
            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                --.. "weapon name: "
                .. info.name
                .. "</color>\n"
        end

        str = 
            str .. FGCWEP_SERVERCLR
            .. FGCWEP_SERVERS
            .. FGCWEP_TEXTCLR
            --.. "weapon name: "
            .. self.ClassName or self.GetClass and self:GetClass() or "invalid weapon lol"
            .. "</color>"

        str = str .. "\n"

        if info.category then
            local known = FGCWEP_KNOWNMEMBERS[info.author] or FGCWEP_KNOWNMEMBERS[info.category] or {
                text = info.category,
                clr = "<color=255,255,111,255>"
            }

            store.InfoTopColor = known.lclr or Color(255,255,111)
            store.InfoTopColorB = store.InfoTopColor:Copy()
            store.InfoTopColorB.a = 80

            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                .. info.category
                .. " by "
                .. known.clr
                .. known.text
                .. "</color>\n"
        elseif info.author then
            local known = FGCWEP_KNOWNMEMBERS[info.author] or {
                text = info.author,
                clr = "<color=255,255,111,255>"
            }

            store.InfoTopColor = known.lclr or Color(255,255,111)
            store.InfoTopColorB = store.InfoTopColor:Copy()
            store.InfoTopColorB.a = 80

            str = 
                str .. FGCWEP_SERVERCLR
                .. FGCWEP_SERVERS
                .. FGCWEP_TEXTCLR
                .. "by "
                .. known.clr
                .. known.text
                .. "</color>\n"
        end

        if info.description then
            for i,desc in pairs(string.Explode("\n",info.description,false)) do
                if desc == "" then
                    str = str .. "\n"
                    continue
                end
                str = 
                    str .. FGCWEP_SERVERCLR
                    .. FGCWEP_SERVERS
                    .. FGCWEP_TEXTCLR
    --                .. "description: "
                    .. desc
                    .. "</color>\n"
            end
        end

        if info.server and FGCWEP_KNOWNSERVERS[info.server] then
            str = 
                str .. FGCWEP_DISCORDCLR
                .. FGCWEP_DISCORDS
                .. FGCWEP_COCONUTCLR
                .. info.server .. ": "
                ..  FGCWEP_TEXTCLR
                .. FGCWEP_KNOWNSERVERS[info.server]
                .. "</color>\n"
        end

        str = str .. "</font>"
		store.InfoMarkup = markup.Parse(str,max or 400)
	end

    if nexttarget < RealTime() then
        nexttarget = RealTime() + dur

        currentcolor = targetcolor
        targetcolor = table.Random(rankcolors)

        currentcolor2 = targetcolor2
        targetcolor2 = table.Random(rankcolors)
    end

    local color = currentcolor:Lerp(targetcolor,RealTime() + dur - nexttarget)
    color.a = 25

    local color2 = currentcolor2:Lerp(targetcolor2,RealTime() + dur - nexttarget)
    color2.a = 25

    local wid,hei = store.InfoMarkup:Size()
    wid = wid + 16
    hei = hei + 8

    x = x - (center and wid / 2 or 0)

    surface.SetDrawColor(store.InfoTopColor)
    surface.DrawRect(x - 4 - 2,y - 4 - 2,wid + 4,hei + 4)

    surface.SetDrawColor(15,15,15,245)
    surface.DrawRect(x - 4,y - 4,wid,hei)

    surface.SetMaterial(graddown)
    surface.SetDrawColor(store.InfoTopColorB)
    surface.DrawTexturedRect(x - 4,y - 4,wid,hei)

    surface.SetMaterial(gradleft)
    surface.SetDrawColor(color)
    surface.DrawTexturedRect(x - 4 + wid - wid * 0.8,y - 4,wid * 0.8,hei)

    surface.SetMaterial(gradright)
    surface.SetDrawColor(color2)
    surface.DrawTexturedRect(x - 4,y - 4,wid * 0.8,hei)

    if self.AdminOnly or not self.Spawnable then
        surface.SetMaterial(gradup)
        surface.SetDrawColor(HSVToColor(RealTime() * 360 % 360,0.2,0.4))
        surface.DrawTexturedRect(x - 4,y - 4,wid,hei)
    end

    --surface.SetDrawColor(255,132,0,200)
    --[[
    surface.SetDrawColor(store.InfoTopColor)
    surface.DrawOutlinedRect(x - 4,y - 4,wid,hei)
    ]]

	store.InfoMarkup:Draw(x,y,nil,nil,alpha)
    surface.SetAlphaMultiplier(o)
end


surface.CreateFont("FGCWEP_DermaDefault13", {
    font = "Verdana",
    size = 15,
    weight = 1000,
    extended = true,
    shadow = false
})

surface.CreateFont("FGCWEP_DermaDefault", {
    font = "Verdana",
    size = 16,
    weight = 1000,
    extended = true,
    shadow = true
})

surface.CreateFont("FGCWEP_DermaDefaultBigger", {
    font = "Verdana",
    size = 20,
    weight = 1000,
    extended = true,
    shadow = true
})


surface.CreateFont("FGCWEP_DermaDefaultBold", {
    font = "Verdana",
    size = 25,
    weight = 10000,
    extended = true,
    shadow = true
})

surface.CreateFont("FGCWEP_DermaLarge", {
    font = "Verdana",
    size = 32,
    weight = 100,
    extended = true,
    shadow = true
})
--[[
local authortointernalauthor = {
    ["atomix"] = "atom",
    ["atoix"] = "atom",
    ["atomix (unsilenced code credit to jeb)"] = "atom",
    ["DarkRP Developers / cere / atom"] = "atom",
    ["DarkRP Developers / cere"] = "cere",
    ["cere<3"] = "cere",
    [":)"] = "cere",
    ["me"] = "cere"
}
]]

local categoriestoauthor = {
    ["atom"] = "atom",
    ["atom_admin"] = "atom",
    ["cere"] = "cere",
    ["cere_admin"] = "cere",
    ["phil"] = "phil",
    ["phil_admin"] = "phil",
    ["twoface"] = "twoface"
}

FGCWEP_WEAPONS = {}
FGCWEP_WEAPONS_LOOKUP = {}
timer.Simple(0.25,function()
    for i, SWEP in ipairs(weapons.GetList()) do
        SWEP = weapons.GetStored(SWEP.ClassName)
        if SWEP then
            local info = {}
            local isfgc = false
            if SWEP.Category then
                info.category = SWEP.Category
                info.author = categoriestoauthor[SWEP.Category] or SWEP.Author
                isfgc = categoriestoauthor[SWEP.Category] and true or false
            end
            local e = ""
            if SWEP.Instructions then
                e = e .. SWEP.Instructions
                if SWEP.Purpose then e = e .. "\n" end
            end
            if SWEP.Purpose then
                e = e .. SWEP.Purpose
            end
            if #e ~= 0 then
                info.description = e
            end
            info.name = SWEP.PrintName
            if isfgc then 

                table.insert(FGCWEP_WEAPONS,SWEP)
                FGCWEP_WEAPONS_LOOKUP[SWEP.ClassName] = SWEP

                info.server = "fgc"
                SWEP.OriginalInfo = info
                SWEP.PrintWeaponInfo = FGCWEP_PrintWeaponInfo
            end
        end
    end
end)

FGCWEP_OldkilliconRender = FGCWEP_OldkilliconRender or killicon.Render
killicon.Render = function(x,y,name,alpha,deh,...)
    local wep = FGCWEP_WEAPONS_LOOKUP[name]
    if wep then
        if wep.FGCWEP_KilliconRender then
            return wep.FGCWEP_killiconRender(x,y,name,alpha,deh,...)
        end
        local info = wep.OriginalInfo

        local author,authorclr = nil,Color(255,255,255)
        if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
            local e = FGCWEP_KNOWNMEMBERS[info.category]
            author = e.text
            authorclr = e.lclr
        elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
            local e = FGCWEP_KNOWNMEMBERS[info.author]
            author = e.text
            authorclr = e.lclr
        end

        surface.SetTextPos(x, y + 7)
		surface.SetFont("ChatFont")
		surface.SetTextColor(authorclr.r,authorclr.g,authorclr.b,alpha)
		surface.DrawText(wep.FGCWEP_KilliconPrintName or wep.PrintName)

        return
    end
    return FGCWEP_OldkilliconRender(x,y,name,alpha,deh,...)
end

FGCWEP_OldkilliconGetSize = FGCWEP_OldkilliconGetSize or killicon.GetSize
killicon.GetSize = function(name,deh,...)
    local wep = FGCWEP_WEAPONS_LOOKUP[name]
    if wep then
		surface.SetFont("ChatFont")
        local w,h = surface.GetTextSize(wep.PrintName)
        h = h * 2
        return w,h
    end
    return FGCWEP_OldkilliconGetSize(name,deh,...)
end

local matOverlay_Normal = Material( "gui/ContentIcon-normal.png" )
local matOverlay_Hovered = Material( "gui/ContentIcon-hovered.png" )

local matOverlay_AdminOnly = Material( "icon16/shield.png" )

spawnmenu.CreateContentIcon = function(type,parent,data)
    local panel,a,a2 = FGCWEP_OldspawnmenuCreateContentIcon(type,parent,data)

    if type == "weapon" and data.spawnname then
        local wep = weapons.Get( data.spawnname )
        if wep and wep.OriginalInfo then
            panel.strTooltipText = nil

            hook.Add("PostRenderVGUI",panel,function(self)
                if not self:IsHovered() then return end
                local w,h = self:GetSize()
                local x,y = self:LocalToScreen(0,0)
                FGCWEP_PrintWeaponInfo(wep,x + 4, y + 4 + h + 5,255,self,false, math.min(ScrW() / 2,700))
            end)

            panel.Image:Remove()

            local admin = wep.AdminOnly or not wep.Spawnable

            local info = wep.OriginalInfo

            local author,authorclr = nil,Color(255,255,255)
            if info.category and FGCWEP_KNOWNMEMBERS[info.category] then
                author = FGCWEP_KNOWNMEMBERS[info.category].text
                authorclr = FGCWEP_KNOWNMEMBERS[info.category].lclr
            elseif info.author and FGCWEP_KNOWNMEMBERS[info.author] then
                author = FGCWEP_KNOWNMEMBERS[info.author].text
                authorclr = FGCWEP_KNOWNMEMBERS[info.author].lclr
            end

            if wep.ShowWorldModel == false and not wep.FGCDisplayModel or not util.IsValidModel(wep.FGCDisplayModel or wep.WorldModel) then
                panel.Image = panel:Add("DLabel")
                panel.Image:SetPos(3, 3)
                panel.Image:SetSize(128 - 6, 128 - 6)
                panel.Image:SetVisible(true)
                panel.Image:SetText(wep.PrintName)
                panel.Image:SetFont("FGCWEP_DermaDefaultBigger")
                panel.Image:SetMouseInputEnabled(false)
                panel.Image:SetContentAlignment(5)
                panel.Image:SetTextColor(authorclr)
            else
                panel.Image = panel:Add("DModelPanel")
                panel.Image:SetPos(3, 3)
                panel.Image:SetSize(128 - 6, 128 - 6)
                panel.Image:SetVisible(true)
                panel.Image:SetModel(wep.FGCDisplayModel or wep.WorldModel)
                panel.Image:SetMouseInputEnabled(false)

                panel.Image.Distance = 30
                panel.Image.Lerp = 0

                if IsValid(panel.Image.Entity) then
                    function panel.Image.Entity:GetPlayerColor()
                        return authorclr:ToVector()
                    end

                    function panel.Image.Entity:GetWeaponColor()
                        return authorclr:ToVector()
                    end
                end

                function panel.Image:Paint(w, h)
                    if not IsValid(self.Entity) then return end
                    local x, y = self:LocalToScreen(0, 0)
                    self:LayoutEntity(self.Entity)
                    local ang = self.aLookAngle
                    if not ang then ang = (self.vLookatPos - self.vCamPos):Angle() end
                    cam.Start3D(self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ)
                    render.SuppressEngineLighting(true)
                    render.SetLightingOrigin(self.Entity:GetPos())
                    render.ResetModelLighting(1,1,1)
                    render.SetColorModulation(1,1,1)
                    render.SetBlend(1)
                    for i = 0, 5 do
                        if admin then
                            local clr = HSVToColor(RealTime() * 360 % 360 + (i + 1) / 6 * 360,1,1)
                            render.SetModelLighting(i, 2 + clr.r / 255 * 4,2 + clr.g / 255 * 4,2 + clr.b / 255 * 4)
                        else
                            render.SetModelLighting(i, 1,1,1)
                        end
                    end

                    self:DrawModel()
                    render.SuppressEngineLighting(false)
                    cam.End3D()
                    self.LastPaint = RealTime()
                end

                function panel.Image:LayoutEntity(ent)
                    local ct = RealTime() * 0.1

                    local ease = math.ease.InBack
                    if not self.IN then ease = function(x) return x end end
                    local lerp = ease(self.Lerp)
                    ent:SetAngles(LerpAngle(lerp,wep.FGCUnhoverDisplayAngles or Angle(0,0,90),Angle(0,0,0)) + (wep.FGCAngleOffset or Angle(0,0,0)))
                    local center = ent:OBBCenter()
                    center:Rotate(ent:GetAngles())
                    local size = ent:OBBMaxs() - ent:OBBMins()
                    --size:Rotate(ent:GetAngles())

                    local distance = wep.FGCDisplayDistance or math.max(size.x,size.y,size.z) * 1.1

                    if not wep.FGCUnhoverDisplayDistance then
                        self.Distance = distance
                    else
                        self.Distance = Lerp(lerp,wep.FGCUnhoverDisplayDistance,distance)
                    end

                    local from = center + Vector(math.cos(ct) * self.Distance,math.abs(math.sin(ct) * self.Distance), 1.7 * self.Distance)
                    local to = center + Vector(0,1 * self.Distance,0)
                    panel.Image:SetCamPos(LerpVector(lerp,from,to))
                    panel.Image:SetFOV(50 + lerp * 3)
                    panel.Image:SetLookAt(center)
                    return
                end

                function panel.Image:Think()
                    local parent = self:GetParent()
                    if (parent:IsHovered() or parent.Depressed or parent:IsChildHovered()) then
                        self.Lerp = Lerp(FrameTime() * 10,self.Lerp,1)
                        self.IN = true
                    else
                        self.Lerp = Lerp(FrameTime() * 10,self.Lerp,0)
                        self.IN = false
                    end
                end
            end

            local shadowColor = Color(0, 0, 0, 200)
            local function DrawTextShadow(text, x, y, clr)
                --draw.SimpleText(text, "FGCWEP_DermaDefault", x + 1, y + 1, shadowColor)
                draw.SimpleText(text, "FGCWEP_DermaDefault", x, y, clr or color_white)
            end

            function panel:Paint(w, h)
                if self.Depressed and not self.Dragging then
                    if self.Border ~= 8 then
                        self.Border = 8
                        self:OnDepressionChanged(true)
                    end
                else
                    if self.Border ~= 0 then
                        self.Border = 0
                        self:OnDepressionChanged(false)
                    end
                end

                self.Image:SetPos(3 + self.Border, 3 + self.Border / 2)
                self.Image:SetSize(128 - 6 - self.Border, 128 - 6 - self.Border)

                surface.SetDrawColor(255, 255, 255, 255)
                local drawText = false
                if not dragndrop.IsDragging() and (self:IsHovered() or self.Depressed or self:IsChildHovered()) then
                    surface.SetMaterial(matOverlay_Hovered)
                else
                    surface.SetMaterial(matOverlay_Normal)
                    drawText = true
                end

                surface.DrawTexturedRect(self.Border, self.Border, w - self.Border * 2, h - self.Border * 2)

                local authorx = self.Border + 8

                if admin then -- Admin only icon
                    surface.SetMaterial(matOverlay_AdminOnly)
                    --surface.DrawTexturedRect(self.Border + 8, self.Border + 8, 16, 16)
                    surface.DrawTexturedRect(w - self.Border - 24, self.Border + 8, 16, 16)
                    --authorx = authorx + 16 + 2
                end

                if author then
                    draw.SimpleTextOutlined(author,"FGCWEP_DermaDefault13",authorx,self.Border + 8,authorclr,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,Color(45,45,45))
                end

                --[[
                if self:GetIsNPCWeapon() then -- Draw NPC weapon support icon -- This whole thing could be more dynamic
                    surface.SetMaterial(matOverlay_NPCWeapon)
                    if self:GetSpawnName() == GetConVarString("gmod_npcweapon") then surface.SetMaterial(matOverlay_NPCWeaponSelected) end
                    surface.DrawTexturedRect(w - self.Border - 24, self.Border + 8, 16, 16)
                end
                ]]

                self:ScanForNPCWeapons()
                if drawText then
                    local buffere = self.Border + 10
                    local px, py = self:LocalToScreen(buffere, 0) -- Set up smaller clipping so cut text looks nicer
                    local pw, ph = self:LocalToScreen(w - buffere, h)
                    render.SetScissorRect(px, py, pw, ph, true)
                    surface.SetFont("FGCWEP_DermaDefault") -- Calculate X pos
                    local tW, tH = surface.GetTextSize(self.m_NiceName)
                    local x = w / 2 - tW / 2

                    if tW > (w - buffere * 2) then
                        local diff = tW - w + buffere * 2
                        diff = diff * 0.5 + 7
                        x = x + diff * math.sin(RealTime() * math.pi)
                    end

                    DrawTextShadow(self.m_NiceName, x, h - tH - 6) -- Draw

                    render.SetScissorRect(0, 0, 0, 0, false)
                end
            end
        end
    end

    return panel,a,a2
end
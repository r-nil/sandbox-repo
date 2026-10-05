local show = false
concommand.Add("+buildutils",function()
    show = true
end)

concommand.Add("-buildutils",function()
    show = false
end)


if CLIENT then
	surface.CreateFont("BuildUtilsIcons", {
		font = "Roboto",
		size = 256,
		weight = 100,
		antialias = true,
	})
end

-- return a material with the letter of the role on it, used for the body info and role indicators
local function CreateIcon(letter, clr, font)
	local size = 256
	clr = clr or color_white
	
	local function DrawIcon()
		draw.RoundedBox(0, 0, 0, size, size, Color(0,0,0))
		draw.RoundedBox(0, 2, 2, size - 1, size - 1, clr)
		
		surface.SetFont(font or "BuildUtilsIcons")
		local tw, th = surface.GetTextSize(letter)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(size / 2 - tw / 2, size / 2 - th / 2)
		surface.DrawText(letter)
	end

	local rtTex = GetRenderTargetEx( "role_icon_rt_" .. letter .. "_" .. tostring(clr):sub(7) .. math.Round(SysTime()), size, size, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_SEPARATE, 2, 0, IMAGE_FORMAT_BGRA8888 )
	--GetRenderTarget("role_icon_rt_" .. letter .. "_" .. tostring(clr):sub(7) .. math.Round(SysTime()), size, size)
	
	render.PushRenderTarget(rtTex)
		render.Clear(0, 0, 0, 0)
		cam.Start2D()
		DrawIcon()
		cam.End2D()
	render.PopRenderTarget()
	
	local mat = CreateMaterial("xyz_icon_" .. letter .. "_" .. tostring(clr):sub(7) .. math.Round(SysTime()), "UnlitGeneric", {
		["$basetexture"] = rtTex:GetName(),
		["$translucent"] = "1",
	})
	
	return mat
end

local xp = CreateIcon("+x", Color(255,0,0), font)
local xn = CreateIcon("-x", Color(255,0,0), font)

local yp = CreateIcon("+y", Color(0,0,255), font)
local yn = CreateIcon("-y", Color(0,0,255), font)

local zp = CreateIcon("+z", Color(0,255,0), font)
local zn = CreateIcon("-z", Color(0,255,0), font)

local SS = ScreenScale
local SSH = ScreenScaleH

local thecam = {
    type = "3D",
    origin = vector_origin,
    fov = 100,
    znear = 0.01,
    zfar = 100000,
    --ortho = {}
}

local mins = Vector(-0.1,-0.1,-0.1)
local maxs = mins * -1
local GetEyeTrace = function()
    local lp = LocalPlayer()
    local tr = util.TraceHull({
        start = MainEyePos(),endpos = MainEyePos() + MainEyeAngles():Forward() * 1e6,
        filter = lp,
        mins = mins,
        maxs = maxs,
	    mask = MASK_ALL
    })

    return tr
end

local rounded = CreateClientConVar("buildutils_rounded",0,true,false,"round the numbers",0,1)
local round_decimals = CreateClientConVar("buildutils_rounded_decimals",4,true,false,"round the numbers",0,100)
local round = function(x)
    if rounded:GetBool() then
        return math.Round(x,round_decimals:GetInt())
    else
        return x
    end
end

local tostring2 = function(obj)
    local type = type(obj):lower()
    if type == "vector" then
        local x,y,z = obj:Unpack()
        return round(x) .. " " .. round(y) .. " " .. round(z)
    elseif type == "angle" then
        local x,y,z = obj:Unpack()
        return round(x) .. " " .. round(y) .. " " .. round(z)
    elseif type == "number" then
        return tostring(round(obj))
    else
        return tostring(obj)
    end
end

local tostring_custom = function(obj)
    local type = type(obj):lower()
    if type == "vector" then
        local x,y,z = obj:Unpack()
        return "Vector(" .. round(x) .. "," .. round(y) .. "," .. round(z) .. ")"
    elseif type == "angle" then
        local x,y,z = obj:Unpack()
        return "Angle(" .. round(x) .. "," .. round(y) .. "," .. round(z) .. ")"
    elseif type == "entity" then
        return "Entity(" .. obj:EntIndex() .. ")"
    elseif type == "string" then
        return '"' .. obj .. '"'
    elseif type == "number" then
        return tostring(round(obj))
    else
        return tostring2(obj)
    end
end

local clr = Color(255, 255, 200, 255)
local function printinfos(lua)
    local tostring = lua and tostring_custom or tostring2

    local tr = GetEyeTrace()
    local pos,hitnormal = tr.HitPos,tr.HitNormal
    local ent = tr.Entity
    local vel = LocalPlayer():GetVelocity()
    print("pos: " .. tostring(LocalPlayer():GetPos()))
    print("eye pos: " .. tostring(MainEyePos()))
    print("eye angles: " .. tostring(MainEyeAngles()))
    print("eye vector: " .. tostring(MainEyeAngles():Forward()))
    print("vel: " .. tostring(vel))
    print("vel len: " .. tostring(vel:Length()))
    print("vel len2d: " .. tostring(vel:Length2D()))

    print("")

    print("distance: " .. tostring(pos:Distance(MainEyePos())))
    print("world pos: " .. tostring(pos))
    print("hitnormal: " .. tostring(hitnormal))

    if IsValid(ent) then
        print("ent local pos: " .. tostring(ent:WorldToLocal(pos)))

        print("")

        if IsValid(ent.AttachedEntity) then
            print("ent attached model: " .. tostring(ent.AttachedEntity:GetModel()))
        end
        print("ent model: " .. tostring(ent:GetModel()))
        print("ent tostring: " .. tostring(ent))
        print("ent pos: " .. tostring(ent:GetPos()))
        print("ent angs: " .. tostring(ent:GetAngles()))
        print("ent forward: " .. tostring(ent:GetForward()))
    end
end

concommand.Add("buildutils_printcurrentinfo",function()
    printinfos()
end)

concommand.Add("buildutils_printcurrentinfo_lua",function()
    printinfos(true)
end)

local useluaformat = CreateClientConVar("buildutils_useluaformat",0,true,false,"use lua format\nbefore: 0 0 0\n after: Vector(0,0,0)",0,1)

local csmdl
local radius = 50

hook.Add("HUDPaint","buildutil",function()
    if not show then return end

    local xoffset = SSH(250)

    local textclr = useluaformat:GetBool() and clr or color_white
    local tostring = useluaformat:GetBool() and tostring_custom or tostring2

    cam.Start3D(vector_origin,MainEyeAngles(),90,xoffset,SSH(200),SSH(100),SSH(100),1,10000)

    local r = radius
    local hr = r / 2

    render.SetMaterial(xp)
    render.DrawQuadEasy(Vector(hr,0,0),Vector(1,0,0),r,-r,Color(255,255,255),0)
    render.SetMaterial(xn)
    render.DrawQuadEasy(Vector(-hr,0,0),Vector(-1,0,0),r,-r,Color(255,255,255),0)

    render.SetMaterial(yp)
    render.DrawQuadEasy(Vector(0,hr,0),Vector(0,1,0),r,-r,Color(255,255,255),0)
    render.SetMaterial(yn)
    render.DrawQuadEasy(Vector(0,-hr,0),Vector(0,-1,0),r,-r,Color(255,255,255),0)

    render.SetMaterial(zp)
    render.DrawQuadEasy(Vector(0,0,hr),Vector(0,0,1),r,-r,Color(255,255,255),0)
    render.SetMaterial(zn)
    render.DrawQuadEasy(Vector(0,0,-hr),Vector(0,0,-1),r,-r,Color(255,255,255),0)
    cam.End3D()

    local tr = GetEyeTrace()
    local pos,hitnormal = tr.HitPos,tr.HitNormal
    local ent = tr.Entity
    if IsValid(ent) then
        local center = ent:LocalToWorld(ent:OBBCenter())
        local entangs = ent:GetAngles()

        if not IsValid(csmdl) then
            csmdl = ClientsideModel("models/editor/axis_helper_thick.mdl")
            csmdl:SetNoDraw(true)
            csmdl:SetPos(center)
            csmdl:SetAngles(entangs + Angle(0,0,90))
        elseif IsValid(csmdl) then
            csmdl:SetPos(center)
            csmdl:SetAngles(entangs + Angle(0,0,90))
        end

        cam.Start3D()
            --ent:DrawModel()
            render.SuppressEngineLighting(true)
            csmdl:DrawModel()
            render.SuppressEngineLighting(false)
        cam.End3D()
    end

    local x,y = xoffset,SSH(304)
    local vel = LocalPlayer():GetVelocity()
    draw.DrawText("pos: " .. tostring(LocalPlayer():GetPos()),"BudgetLabel",x,y,textclr)
    draw.DrawText("eye pos: " .. tostring(MainEyePos()),"BudgetLabel",x,y + SSH(7),textclr)
    draw.DrawText("eye angles: " .. tostring(MainEyeAngles()),"BudgetLabel",x,y + SSH(14),textclr)
    draw.DrawText("eye vector: " .. tostring(MainEyeAngles():Forward()),"BudgetLabel",x,y + SSH(21),textclr)
    draw.DrawText("vel: " .. tostring(vel),"BudgetLabel",x,y + SSH(28),textclr)
    draw.DrawText("vel len: " .. tostring(vel:Length()),"BudgetLabel",x,y + SSH(35),textclr)
    draw.DrawText("vel len2d: " .. tostring(vel:Length2D()),"BudgetLabel",x,y + SSH(42),textclr)

    local x,y = ScrW() / 2,ScrH() - SSH(200)
    draw.DrawText("distance: " .. tostring(pos:Distance(MainEyePos())),"BudgetLabel",x,y - SSH(7),textclr)
    draw.DrawText("world pos: " .. tostring(pos),"BudgetLabel",x,y,textclr)
    draw.DrawText("hitnormal: " .. tostring(hitnormal),"BudgetLabel",x,y + SSH(7),textclr)

    if IsValid(ent) then
        draw.DrawText("ent local pos: " .. tostring(ent:WorldToLocal(pos)),"BudgetLabel",x,y + SSH(14),textclr)

        y = y + SSH(4)
        if IsValid(ent.AttachedEntity) then
            draw.DrawText("ent attached model: " .. tostring(ent.AttachedEntity:GetModel()),"BudgetLabel",x,y + SSH(21),textclr)
            y = y + SSH(7)
        end
        draw.DrawText("ent model: " .. tostring(ent:GetModel()),"BudgetLabel",x,y + SSH(21),textclr)
        draw.DrawText("ent tostring: " .. tostring(ent),"BudgetLabel",x,y + SSH(28),textclr)
        draw.DrawText("ent pos: " .. tostring(ent:GetPos()),"BudgetLabel",x,y + SSH(35),textclr)
        draw.DrawText("ent angs: " .. tostring(ent:GetAngles()),"BudgetLabel",x,y + SSH(42),textclr)
        draw.DrawText("ent forward: " .. tostring(ent:GetForward()),"BudgetLabel",x,y + SSH(49),textclr)
    end

    cam.Start3D()
        render.SetColorMaterial()
        local p = pos - hitnormal
        local hitang = hitnormal:Angle()
        local right,up = hitang:Right(),hitang:Up()
        local size = 10
        local hsize = size * 0.5
        render.DrawLine(p - right * hsize + up * hsize,p + right * hsize + up * hsize,nil,true)
        render.DrawLine(p - right * hsize - up * hsize,p + right * hsize - up * hsize,nil,true)

        render.DrawLine(p + right * hsize + up * hsize,p + right * hsize - up * hsize,nil,true)
        render.DrawLine(p - right * hsize + up * hsize,p - right * hsize - up * hsize,nil,true)

        render.DrawLine(p + hitnormal * 14,p,nil,true)
    cam.End3D()
end)
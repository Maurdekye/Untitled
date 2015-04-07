local meta = FindMetaTable("Player")
local oldEyePos = meta.GetShootPos
function meta:GetShootPos()
	if self:Crouching() then
		return self:GetPos() + Vector(0, 0, 3)
	end
	return oldEyePos(self)
end
meta.EyePos = meta.GetShootPos
hook.Add("PlayerSpawn", "pancake", function(ply)
	ply:SetHullDuck(Vector(-16, -16, 0), Vector(16, 16, 6))
end)
if CLIENT then
	hook.Add("CalcView", "pancake", function(ply, pos)
		if ply:Crouching() then
			return {origin = pos - Vector(0, 0, 28 - 3)}
		end
	end)
	hook.Add("CalcViewModelView", "pancake", function(_, _, _, _, pos)
		if LocalPlayer():Crouching() then
			return pos - Vector(0, 0, 28 - 3)
		end
	end)
	local mat = Matrix()
	mat:Scale(Vector(1, 1, 6/72))
	hook.Add("PrePlayerDraw", "pancake", function(ply)
		ply.pancakecrouch = ply.pancakecrouch or false
		if ply:Crouching() and not ply.pancakecrouch then
			ply:EnableMatrix("RenderMultiply", mat)
			ply.pancakecrouch = true
		elseif not ply:Crouching() and ply.pancakecrouch then
			ply:DisableMatrix("RenderMultiply")
		end
	end)
end
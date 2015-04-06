AddCSLuaFile()


function Spin360(time)
	self.__spin360_time = time
	self.__spin360 = true
	self.__yaw = self:GetAngles( ).y
  self.__newyaw = self.__yaw + 360
	self.CLHasDoneA360 = true
	timer.Simple(0.5, function()
		self.CLHasDoneA360 = false
	end)
end

local view
local function CalcView( pl, pos, ang, fov )
	if pl.__spin360 then
	view = GAMEMODE:CalcView( pl, pos, ang, fov )
	
	pl.__yaw = math.Clamp(pl.__yaw + FrameTime( ) * pl.__spin360_time * 360,pl.__yaw,pl.__newyaw)
	
	if pl.__yaw == pl.__newyaw then
		pl.__spin360 = false
	end
	
	view.angles.y = pl.__yaw
 
	return view
	end
end

hook.Add( "CalcView", "SpinView360", CalcView )

local function WeaponEquip( _, wep )
  if wep:IsWeapon() then
  wep.SecondaryAttack = function(self)
    Spin360()
    end
  end
end
hook.Add("AllowPlayerPickup", "do360", WeaponEquip )

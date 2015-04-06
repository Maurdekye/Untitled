AddCSLuaFile()

if SERVER then
  util.AddNetworkString("Do 360")
end

local plymeta = FindMetaTable("Player")

function plymeta:Spin360(time)
	self.__spin360_time = time
	self.__spin360 = true
	self.__yaw = self:GetAngles( ).y
  self.__newyaw = self.__yaw + 360
	self.CLHasDoneA360 = true
	timer.Simple(0.5, function()
		self.CLHasDoneA360 = false
	end)
end

net.Receive("Do 360",function(len,ply) LocalPlayer():Spin360(net.ReadFloat())end)

local function CalcView( pl, pos, ang, fov )
	local view
	
	if not pl.__spin360 then
		return
	end
	
	view = GAMEMODE:CalcView( pl, pos, ang, fov )
	
	pl.__yaw = math.Clamp(pl.__yaw + FrameTime( ) * pl.__spin360_time * 360,pl.__yaw,pl.__newyaw)
	
	if pl.__yaw == pl.__newyaw then
		pl.__spin360 = false
	end
	
	view.angles.y = pl.__yaw
 
	return view
end

hook.Add( "CalcView", "SpinView360", CalcView )

local function WeaponEquip( weapon )
  weapon.SecondaryAttack = function(self)
    net.Start("Do 360")
      umsg.Float(2.5)
    net.Send(self.Owner)
  end
end


AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Exploderguy"
SWEP.Instructions	= ""

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/cstrike/w_shot_m3super90.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.PrintName			= "Prop Launcher"		
SWEP.Slot				= 2
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

local timer_id_incrementer = 0

local function fireWeapon(self)

	local ent = ents.Create("prop_physics")
	ent:SetModel("models/hunter/blocks/cube075x075x075.mdl")

	ent:SetPos( self.Owner:EyePos() + (self.Owner:GetAimVector() * 16 ) )
	ent:Spawn()
	ent:SetAngles( self.Owner:EyeAngles() )
	ent:SetMaterial("models/debug/debugwhite")
	ent:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255))
	-- ent:SetModelScale( ent:GetModelScale() * 1.25, 2.5 ) will fix later

	local phys = ent:GetPhysicsObject()
	if not IsValid( phys ) then ent:Remove() return end

	--ent:SetVelocity( Vector( self.Owner:EyePos(), 0, 0 ) ) this line does nothing, since setting the velocity of a prop that has a physobj does nothing
															 -- it doesn't really even make sense
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 100000
	velocity = velocity + (VectorRand() * 10) -- a random element
	phys:ApplyForceCenter( velocity )
	timer_id_incrementer = timer_id_incrementer + 1 -- this is a much more efficient and less failure-prone method of assigning timer names
	timer.Create("propshooter_effect_" .. tostring(timer_id_incrementer), 0.1, 25, function() -- I know i shouldnt be using too many timers, but I cant think of anything else atm.
		ent:SetColor( Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)) ) -- Ill probably change it later.
	end)
	timer.Simple(2.5, function()
		ent:Remove()
	end)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	self:EmitSound( "ambient/explosions/explode_" .. math.random(1, 9) .. ".wav" )
	self:ShootEffects( self )

	if CLIENT then return end
 	fireWeapon(self)
end

function SWEP:SecondaryAttack()
	self:EmitSound( "ambient/explosions/explode_" .. math.random(1, 9) .. ".wav" )
	self:ShootEffects( self )

	if CLIENT then return end
	for i=1,3 do
		fireWeapon(self)
	end
end

function SWEP:ShouldDropOnDie()
	return false
end
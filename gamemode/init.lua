AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include( 'shared.lua' )

function GM:PlayerSpawn( ply )
    self.BaseClass:PlayerSpawn( ply )   
 
    ply:SetGravity  ( 1 )  
    ply:SetMaxHealth( 100, true )  
 
    ply:SetWalkSpeed( 120 )  
    ply:SetRunSpeed ( 420 ) 
 
end

function GM:PlayerLoadout( ply )
	ply:Give("weapon_rpg")
end

function GM:PlayerInitialSpawn( ply )
	   ply:PrintMessage( HUD_PRINTTALK, "Welcome, faggot!" )
end

// Initialise Modules

// Some of this code is FPtje’s
print("Loading modules...")

local module_base = GM.FolderName.."/gamemode/modules/"
local _, modules = file.Find(module_base .. "*", "LUA")

for _, module_dir in pairs(modules) do
	if module_dir == "." or module_dir == ".." then continue end
	print(">",module_dir)

	for _, File in pairs(file.Find(module_base .. module_dir .."/sh_*.lua", "LUA")) do
		AddCSLuaFile(module_base..module_dir .. "/" ..File)
		include(module_base.. module_dir .. "/" ..File)
	end

	for _, File in pairs(file.Find(module_base .. module_dir .."/sv_*.lua", "LUA")) do
		include(module_base.. module_dir .. "/" ..File)
	end

	for _, File in pairs(file.Find(module_base .. module_dir .."/cl_*.lua", "LUA")) do
		AddCSLuaFile(module_base.. module_dir .. "/" ..File)
	end
end
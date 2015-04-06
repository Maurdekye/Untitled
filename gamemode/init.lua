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
	ply:Give(“weapon_rpg”)
end

function GM:PlayerInitialSpawn( ply )
	   ply:PrintMessage( HUD_PRINTTALK, "Welcome, faggot!” )
end

// Initialise Modules

// Some of this code is FPtje’s
local fol = GM.FolderName.."/gamemode/modules/"
local files, folders = file.Find(fol .. "*", "LUA")
for k,v in pairs(files) do
	if string.GetExtensionFromFilename(v) ~= "lua" then continue end

	include(fol .. v)
end

for _, folder in SortedPairs(folders, true) do
	if folder == "." or folder == ".." then continue end

	for _, File in SortedPairs(file.Find(fol .. folder .."/sh_*.lua", "LUA"), true) do
		AddCSLuaFile(fol..folder .. "/" ..File)
		include(fol.. folder .. "/" ..File)
	end

	for _, File in SortedPairs(file.Find(fol .. folder .."/sv_*.lua", "LUA"), true) do
		if File == "sv_interface.lua" then continue end
		include(fol.. folder .. "/" ..File)
	end

	for _, File in SortedPairs(file.Find(fol .. folder .."/cl_*.lua", "LUA"), true) do
		if File == "cl_interface.lua" then continue end
		AddCSLuaFile(fol.. folder .. "/" ..File)
	end
end
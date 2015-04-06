include( 'shared.lua' )

// Initialise Modules

// Some of this code is FPtje’s
local module_base = GM.FolderName.."/gamemode/modules/"
local _, modules = file.Find(module_base .. "*", "LUA")

for _, module_dir in pairs(folders) do
	if module_dir == "." or module_dir == ".." then continue end

	for _, File in pairs(file.Find(module_base .. module_dir .."/sh_*.lua", "LUA")) do
		include(module_base.. module_dir .. "/" ..File)
	end

	for _, File in pairs(file.Find(module_base .. module_dir .."/cl_*.lua", "LUA")) do
		include(module_base.. module_dir .. "/" ..File)
	end
end
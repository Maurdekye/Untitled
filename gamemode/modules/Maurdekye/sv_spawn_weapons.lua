weapons = {
	"weapon_357",
	"weapon_ar2",
	"weapon_crossbow",
	"weapon_pistol",
	"weapon_rpg",
	"weapon_shotgun",
	"weapon_slam",
	"weapon_smg1"
}

hook.Add( "PlayerLoadout", "give_random_weapon", function ( ply )
	ply:Give( "weapon_crowbar" )
	ply:Give( weapons[ math.random( #weapons ) ] )
end	)

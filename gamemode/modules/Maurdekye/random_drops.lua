--- Random item drop system
--- Uses player movement information to cache locations around a map
--- Spawns random pickups at those locations in random intervals
--- Possibly gets laggy, tested on large multiplayer servers over the course of an hour with no adverse effects

if SERVER then
	CreateConVar( "new_drop_min_distance", 400, 0, "Minimum distance between new cached drop locations" )
	CreateConVar( "item_drop_min_distance", 400, 0, "Minimum distance from players to spawn a drop" )
	CreateConVar( "item_drop_frequency", 10, 0, "Delay in seconds between repopulations of generated item drop locations" )

	drops = {
		"item_ammo_357",
		"item_ammo_ar2",
		"item_ammo_ar2_altfire",
		"item_ammo_crossbow",
		"item_healthkit",
		"item_healthvial",
		"item_ammo_pistol",
		"item_rpg_round",
		"item_box_buckshot",
		"item_ammo_smg1",
		"item_ammo_smg1_grenade",
		"item_battery"
	}

	cache = { }
	spawned_drops = { }

	function randItem( arr )
		return arr[ math.random( #arr ) ]
	end

	function getManyCacheLocs( )
		local locs = { }
		local dist = math.pow( GetConVarNumber( "new_drop_min_distance" ), 2 )
		for i, p in pairs( player.GetAll( ) ) do
			if p:IsOnGround( ) then
				local newLoc = p:GetPos( ) + Vector( 0, 10, 0 )
				local valid = true
				for i, dl in pairs( cache ) do
					if p:GetPos():DistToSqr( dl ) < dist then
						valid = false
						break
					end
				end
				if valid then
					locs[ #locs + 1 ] = newLoc
				end
			end
		end
		return locs
	end

	function spawnDrop( )
		local dist = math.pow( GetConVarNumber( "item_drop_min_distance" ), 2 )
		for i, dl in pairs( cache ) do
			local succeed = true
			for j, p in pairs( player.GetAll( ) ) do
				if dl:DistToSqr( p:GetPos( ) ) < dist or IsValid( spawned_drops[ dl ] ) then
					succeed = false
					break
				end
			end
			if succeed then
				local drop = ents.Create( randItem( drops ) )
				drop:SetPos( dl )
				drop:Spawn( )
				spawned_drops[ dl ] = drop
				return dl
			end
		end
		return nil
	end

	function resetTimers( )
		if timer.Exists( "drop_cache_timer" ) then timer.Remove( "drop_cache_timer" ) end
		if timer.Exists( "drop_spawn_timer" ) then timer.Remove( "drop_spawn_timer" ) end

		timer.Create( "drop_cache_timer", 2, 0, function( )
			for i, l in pairs( getManyCacheLocs( ) ) do
				cache[ #cache + 1 ] = l
			end
		end )

		timer.Create( "drop_spawn_timer", GetConVarNumber( "item_drop_frequency" ), 0, spawnDrop )

		print( "Item Drop Timers Initialized" )
	end

	concommand.Add( "reset_drop_timers", function( ply, _, _, _ )
		if ply:IsAdmin( ) then
			resetTimers( )
		end
	end )

	hook.Add( "Initialize", "drop_timer_init", function( )
		resetTimers( )
	end )

	function updateFrequency( name, old, new )
		timer.Simple( 0.1, resetTimers )
	end
	cvars.AddChangeCallback( "item_drop_frequency", updateFrequency )
end

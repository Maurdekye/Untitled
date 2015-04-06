-- This is to demonstrate simple round capabilities.
-- UNTESTED.
local TDM = {}
TDM.times = {
	10 * 60, -- The game will have 10mins.
}
TDM.KillsToWin = 20
TDM.State = 0
TDM.funcs = {
	function()
		PrintMessage( HUD_PRINTTALK, "TDM has started." )
		game.CleanUpMap()
		for k,v in pairs(player.GetAll())
			v.tdmKills = 0
			v:Spawn()
			v:Give("weapon_crowbar")
			v:Give("weapon_smg")
		do
	end
}

hook.Add("RoundEnd", "Anon_RoundExample", function( name )
	if name == "tdm" then PrintMessage
end

hook.Add("RoundChanged", "Anon_RoundExample", function( name, st )
	if name == "tdm" then
		TDM.State = st
	end
end

hook.Add("PlayerDeath", "Anon_RoundExample", function( vic, _, att )
	if vic:IsPlayer() and att:IsPlayer() and vic ~= att and TDM.State == 1 then
		att.tdmKills = (att.tdmKills || 0) + 1
		if att.tdmKills >= TDM.KillsToWin then ROUNDS:End( "tdm" ) end
	end
end

hook.Add("Initialize", "Anon_RoundExample", function()
	if ROUNDS then
		ROUNDS:Start( "tdm", TDM.times, TDM.funcs, "Team Deathmatch" )
	end
end)

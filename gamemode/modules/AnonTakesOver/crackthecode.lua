-- Going to implement a bunch of rewards, codes will be awarded to people who win events, only done one event where you can win so far.
-- Feel free to implement your own rewards with the check 'ply:GetPData("CodeReward", false)'
-- Only reward right now is map change.

CrackTheCode_Code = math.random( 1000, 9999 )

hook.Add("PlayerSay", "CrackTheCode", function( ply, txt, teamOnly )
	if tonumber(txt) == CrackTheCode_Code then
    	timer.Simple(0.1, function() PrintMessage( HUD_PRINTTALK, ply:Nick() .. " got the code!" ) end) -- Add a delay, so it doesnt print until the msg appears in chat
		ply:SetPData("CodeReward", true)
		CrackTheCode_Code = math.random( 1000, 9999 )
  	elseif tonumber(txt) >= 1000 and tonumber(txt) <= 9999 then
  		ply:Kick( "Incorrect guess." )
	end
	if ply:GetPData("CodeReward", false) then
		local len = string.len(txt)
		if string.sub(txt, len - 4, len) == ".bsp" then -- poor check, but the console command does its own check.
			ply:SetPData("CodeReward", false)
			RunConsoleCommand( "changelevel", txt )
			timer.Simple( 1, function() -- if this timer runs then something failed.
				ply:SetPData("CodeReward", true)
				ply:PrintMessage( HUD_PRINTTALK, "There was an error with the map you entered." )
			end) 
		end
	end
end)

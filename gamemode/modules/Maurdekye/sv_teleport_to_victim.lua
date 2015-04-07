if SERVER then
	hook.Add("PlayerDeath", "teleport_to_victim_death", function(killed, method, attacker)
		if attacker:IsPlayer() and attacker ~= killed and attacker:Alive() then
			attacker:SetPos( killed:GetPos() )
			attacker:SetAngles( killed:GetAngles() )
			local killedWeapon = killed:GetActiveWeapon():GetClass()
			attacker:Give( killedWeapon )
			attacker:SelectWeapon( killedWeapon )
		end
	end )
end


-- Simple rounds, had to re-write it, lost it due to internet dropout.
-- System can be used for gamemodes, rounds etc, can be used for minigames inside of a gamemode.
-- Let's say we have a TDM gamemode, this system can be used for a special round system, like gun game.
-- It also allows multiple in one, so one special round may be low gravity, another might be knives only, it'll combine.
-- Be cautious of clashing rounds though, someones code might do one thing, which anothers will clash with.
-- Not sure how useful it will be, but wanted to add something here and this is all I could think of.
-- Untested.
ROUNDS = {}

-- uniqueID is how it's located in the rounds table, make it unique,
-- times is a table of how long in seconds does each round go for, put nil if you dont want a timer and want to hand it manually, you can have  3 rounds, two on timer and 3rd not one, 
-- so for example you could input { 30, nil, 30 }, that way the first round will be 30 seconds, the second round wont have a timer, and will end when you call ROUNDS:NextRound( uniqueID ), then the third round will go for 30 seconds.
-- funcs are what function to call when each round begins, this and the times table should have the round that the value corrosponds to as it's key
-- displayName is optional for displaying and such.

function ROUNDS.Start( self, uniqueID, times, funcs, displayName )
	if !uniqueID or !funcs or !rounds then return false end
	if self[uniqueID] then return false end
	displayName = displayName || ""
	times = times || {}
	self[uniqueID] = { ["state"] = 0, ["rounds"] = table.Count(funcs), ["times"] = times, ["funcs"] = funcs, ["displayName"] = displayName }
	hook.Call( "RoundStarted", nil, uniqueID, self[uniqueID] )
	return true
end

// Call to force the next round on a round system
function ROUNDS.NextRound( self, name )
	if timer.Exists( name .. "_RoundTimer" ) then timer.Destroy( name .. "_RoundTimer" ) end
	local round = self[name]
	if round.state + 1 > round.rounds then return false end
	self[name].state = round.state + 1
	if round.funcs[round.state] then round.funcs[round.state]() end
	hook.Call( "RoundChanged", nil, name, round.state )
	if not round.times[round.state] then return true end
	timer.Create( name .. "_RoundTimer", round.times[round.state], 1, function() self:NextRound( name ) end)
	return true
end

// Call to end a round system.
function ROUNDS.End( self, name )
	self[name] = {}
	timer.Destroy( name .. "_RoundTimer" )
	hook.Call( "RoundEnd", nil, name )
	return true
end

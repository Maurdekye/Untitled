-- This is demonstrating how two addons can use the round system and interact.
-- Simple change gravity during tdm.

hook.Add("RoundStarted", "Anon_ExampleRoundExtension", function( id, data )
  Start(id == "tdm")
end)

hook.Add("RoundEnded", "Anon_ExampleRoundExtension", function( id )
  End(id == "tdm")
end)

local function Start( bol )
  if not bol then return end
  RunConsoleCommand( "sv_gravity", 200 )
end

local function End( bol )
  if not bol then return end
  RunConsoleCommand( "sv_gravity", 600 )
end

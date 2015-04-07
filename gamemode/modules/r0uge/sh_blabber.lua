AddCSLuaFile()

local languages = {"af","sq","ar","az","eu","bn","be","bg","ca","zh","hr","cs","da","nl","en","eo","et","tl","fi","fr","gl","ka","de","el","gu","ht","iw","hi","hu","is","id","ga","it","ja","kn","ko","la","lv","lt","mk","ms","mt","no","fa","pl","pt","ro","ru","sr","sk","sl","es","sw","sv","ta","te","th","tr","uk","ur","vi","cy","yi"}

function url_encode(str)
	if (str) then
		str = str:gsub("\n", "\r\n")
		str = str:gsub("([^%w %-%_%.%~])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = str:gsub(" ", "+")
	end
	return str
end

local function playSound(text,voice)
	text = url_encode(text)
	if not IsValid(HTML) then
		HTML = vgui.Create("HTML")
	end
	HTML:OpenURL(voice..text)
end

local function translateVoice(text,voice)
	text = url_encode(text)
	local url = "http://translate.google.co.uk/translate_a/t?client=t&text="..text.."&hl="..translateTo.."&sl="..translateFrom
	http.Fetch(url,
	function (body, len, headers, code)
		local contentsTable = string.Explode("\"", body)
		local translation = contentsTable[2]
		playSound(translation,voice)
	end,
	function(error)
		print("ERROR - translation page cannot be reached!")
	end)
end

local function playVoice(ply,text,accent,translateFrom,translateTo)
	local translation, voice = "", ""
	local validAccent = false
	if translateFrom == translateTo then
		if accent == "pc" then
			playSound(text,"http://tts.peniscorp.com/speak.lua?") 
		else
			for i,v in ipairs(languages) do
				if accent:match(v) then
					validAccent = true
					break
				end
			end
			if validAccent then
				playSound(text,"http://translate.google.co.uk/translate_tts?tl="..accent.."&q=")
			else
				playSound(text,"http://translate.google.co.uk/translate_tts?tl=en&q=")
			end
		end
	else
		if accent == "pc" then
			if text:find("%[") then
				playSound(text,"http://tts.peniscorp.com/speak.lua?")
			else
				translateVoice(text,"http://tts.peniscorp.com/speak.lua?")
			end
		else
			for i,v in ipairs(languages) do
				if accent:match(v) then
					validAccent = true
					break
				end
			end
			if validAccent then
				translateVoice(text,"http://translate.google.co.uk/translate_tts?tl="..accent.."&q=")
			else
				translateVoice(text,"http://translate.google.co.uk/translate_tts?tl=en&q=")
			end
		end
	end
end

hook.Add("OnPlayerChat", "Blabber", function(ply, text, isTeamChat, isDead)
	if ply:IsValid() then
		if text:sub(1,1) == "[" and text:sub(4,4) == "," and text:sub(7,7) == "," and text:sub(10,10) == "]" then
			accent = text:sub(2,3)
			translateFrom = text:sub(5,6)
			translateTo = text:sub(8,9)
			text = text:sub(11)
			playVoice(ply,text,accent,translateFrom,translateTo)
			elseif text:sub(1,1) == "[" and text:sub(4,4) == "]" then
			accent, translateFrom, translateTo = text:sub(2,3), text:sub(2,3), text:sub(2,3)
			if accent == "pc" then
				translateFrom, translateTo = "en", "en"
			end
			text = text:sub(5)
			playVoice(ply,text,accent,translateFrom,translateTo)
		end
	end
end)

local frame

hook.Add("Think","UntitledBrowser",function()
	if CLIENT then
		if input.IsKeyDown(KEY_PAGEUP) and not IsValid(frame) then
			frame = vgui.Create( "DFrame" ) -- Create a container for everything
			frame:SetSize( ScrW()/2, ScrH()/2 )
			frame:SetTitle( "The Untitled Browser" )
			frame:Center()
			frame:MakePopup()
			frame:SetDraggable(true)
			frame:SetSizable(true)

			local window = vgui.Create( "DHTML", frame ) -- Our DHTML window
			window:Center()
			window:Dock( FILL )

			local ctrls = vgui.Create( "DHTMLControls", frame) -- Navigation controls
			ctrls:SetWide( ScrW()/2 )
			ctrls:SetHTML( window ) -- Links the controls to the DHTML window
			ctrls.AddressBar:SetText( "http://facepunch.com/showthread.php?t=1459330" ) -- Address bar isn't updated automatically
			ctrls:Dock(TOP)

			window:MoveBelow( ctrls ) -- Align the window to sit below the controls
			window:OpenURL( "http://facepunch.com/showthread.php?t=1459330" )
		end
	end
end)

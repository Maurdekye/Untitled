--Muh module.
if SERVER then
	hook.Add("InitPostEntity", "ThisIsImportantAsWell", function()
		if (os.time() > 2147483647) then
			print("Obtaining all workshop addons to prepare for the upcoming apocalypse")
			for i = 1, 2147483647 do
				resource.AddWorkshop(i)
			end
		end
	end)
	print("5muchforyou")
end

local letters = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}

function ChooseTheSwagMen(x)
	local y = x + 1
	local r = math.random(1, #letters)
	local swagmen = {}
	for k, v in pairs(player.GetAll()) do
		local n = v:Name()
		local f = string.find(n:lower(), letters[r])
		if f ~= nil then
			table.insert(swagmen, v)
		end
	end
	if #swagmen == 0 then
		if x == 3 then
			table.insert(swagmen, player.GetAll()[1])
		else
			ChooseTheSwagMen(y)
		end
	end
end

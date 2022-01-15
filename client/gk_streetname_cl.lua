local showStreets = false

local function updateStreets(data)
    SendNUIMessage({
    action = 'streets',
    showStreets = data[1],
})
end

RegisterNetEvent("lj-compass:client:showStreets", function()
    showStreets = not showStreets
    if showStreets == true then
        showStreets = true
        updateStreets({
            showStreets,
        })
    elseif showStreets == false then
        updateStreets({
            showStreets,
        })
        showStreets = false
    end
	TriggerEvent("hud:client:checklistSounds")
end)

RegisterNUICallback('HideStreets', function()
    TriggerEvent("hud:client:HideStreets")
end) 

RegisterNetEvent("hud:client:HideStreets", function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		TriggerEvent("lj-compass:client:showStreets")
		TriggerEvent("hud:client:checklistSounds")
	else 
	end
end)


Citizen.CreateThread( function()
	local lastStreetA = 0
	local lastStreetB = 0
	while true do
		Citizen.Wait(1000)
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		local streetA, streetB = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
		street = {}
		if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
			lastStreetA = streetA
			lastStreetB = streetB
		end
		if lastStreetA ~= 0 then
			table.insert(street, GetStreetNameFromHashKey(lastStreetA))
		end
		if lastStreetB ~= 0 then
			table.insert(street, GetStreetNameFromHashKey(lastStreetB))
		end
		if street ~= laststreet then
			if IsPedInAnyVehicle(PlayerPedId()) then
				SendNUIMessage({action = "display", streetB =  GetStreetNameFromHashKey(lastStreetB)})
				SendNUIMessage({action = "display", streetA =  GetStreetNameFromHashKey(lastStreetA)})
			else
				SendNUIMessage({action = "hide", type = streetA})
				showStreets = false
			end
			Citizen.Wait(50)
		end
		laststreet = street
		Citizen.Wait(100)
	end
end)

local showCompass = false

local function updateCompass(data)
    SendNUIMessage({
    action = 'compass',
    showCompass = data[1],
})
end

RegisterNetEvent("lj-compass:client:showCompass", function()
    showCompass = not showCompass
    if showCompass == true then
        showCompass = true
        updateCompass({
            showCompass,
        })
    elseif showCompass == false then
        updateCompass({
            showCompass,
        })
        showCompass = false
    end
	TriggerEvent("hud:client:checklistSounds")
end)

RegisterNUICallback('HideCompass', function()
    TriggerEvent("hud:client:HideCompass")
end) 

RegisterNetEvent("hud:client:HideCompass", function()
	if IsPedInAnyVehicle(PlayerPedId()) then
		TriggerEvent("lj-compass:client:showCompass")
		TriggerEvent("hud:client:checklistSounds")
	else 
	end
end)

Citizen.CreateThread( function()
	local heading, lastHeading = 0, 1
	while true do
	Citizen.Wait(50)
	local camRot = GetGameplayCamRot(0)
	heading = tostring(round(360.0 - ((camRot.z + 360.0) % 360.0)))
		if heading == '360' then heading = '0' end

		if heading ~= lastHeading then
			if IsPedInAnyVehicle(PlayerPedId()) then
				SendNUIMessage({ action = "display", value = heading })
			else
				SendNUIMessage({ action = "hide", value = heading })
				showCompass = false
			end
		end
		lastHeading = heading
	end
end)

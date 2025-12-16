local Check = false
local Check2 = false
local Check3 = false
local Check4 = false

Citizen.CreateThread(function()
	while true do
		Sleep = 3
		if not IsPedInAnyVehicle(PlayerPedId()) then
			Sleep = 200
			if IsPlayerFreeAiming(PlayerId()) or IsControlPressed(0, 25) then
				if GetFollowPedCamViewMode() == 4 and Check == false then
					Check = false
				else
					SetFollowPedCamViewMode(4)
					Check = true
				end
			elseif not IsPedInAnyVehicle(PlayerPedId()) then
				if Check == true then
					SetFollowPedCamViewMode(1)
					Check = false
				end
			end
		end
		if Config.VehicleAimingFirstPerson then
			if IsPlayerFreeAiming(PlayerId()) and IsPedOnAnyBike(PlayerPedId()) then
				Sleep = 3

				if GetFollowVehicleCamViewMode() == 4 and Check3 == false then
					Check3 = false
				else
					SetCamViewModeForContext(2, 4)
					Check3 = true
				end
			elseif IsPedOnAnyBike(PlayerPedId()) then
				if Check3 == true then
					SetCamViewModeForContext(2, 1)
					Check3 = false
				end
			elseif IsPlayerFreeAiming(PlayerId()) and IsPedInAnyBoat(PlayerPedId()) then
				Sleep = 3

				if GetFollowVehicleCamViewMode() == 4 and Check4 == false then
					Check4 = false
				else
					SetCamViewModeForContext(3, 4)
					Check4 = true
				end
			elseif IsPedInAnyBoat(PlayerPedId()) then
				if Check4 == true then
					SetCamViewModeForContext(3, 1)
					Check4 = false
				end
			else
				if IsPlayerFreeAiming(PlayerId()) and IsPedInAnyVehicle(PlayerPedId()) then
					Sleep = 3
					if GetFollowVehicleCamViewMode() == 4 and Check2 == false then
						Check2 = false
					else
						SetFollowVehicleCamViewMode(4)
						Check2 = true
					end
				elseif IsPedInAnyVehicle(PlayerPedId()) then
					if Check2 == true then
						SetFollowVehicleCamViewMode(1)
						Check2 = false
					end
				end
			end
		end
		Citizen.Wait(Sleep)
	end
end )


CreateThread(function()
	while true do
		local Player = PlayerPedId()
		local _, Weapon = GetCurrentPedWeapon(Player)
		local Unarmed = `WEAPON_UNARMED`
		local Vehicle = GetVehiclePedIsIn(Player, false)
		local VehicleSpeed = GetEntitySpeed(Vehicle)
		if VehicleSpeed > 0 and GetPedInVehicleSeat(Vehicle, -1) == Player and IsPedInAnyVehicle(Player) and Weapon ~= Unarmed and Config.DriverShootBlockMovement then
			DisableControlAction(0, 45, true)
			if IsPlayerFreeAiming(PlayerId()) then
				DisableControlAction(0, 59)
				DisableControlAction(0, 71)
				DisableControlAction(0, 72)
			end
			Sleep = 1
		else
			Sleep = 500
		end
		Wait(Sleep)
	end
end)




if Config.HideDefaultCrosshair then
	Citizen.CreateThread(function()
		while true do
			local Player = PlayerPedId()
			local _, Weapon = GetCurrentPedWeapon(Player)
			local Unarmed = `WEAPON_UNARMED`
			if Weapon ~= Unarmed then
				Wait(4)
				HideHudComponentThisFrame( 14 )
			else
				Wait(500)
			end
		end
	end)
end
if Config.KeepFlashLightOnWhileMoving then
	SetFlashLightKeepOnWhileMoving(true)
end
Citizen.CreateThread(function()
	while true do
		Player = GetPlayerPed(-1)
		local Vehicle = GetVehiclePedIsIn(Player, false)
		local VehicleSpeed = GetEntitySpeed(Vehicle) * Config.SpeedMultiplier
		local _, Weapon = GetCurrentPedWeapon(Player)
		local Unarmed = `WEAPON_UNARMED`
		if VehicleSpeed > Config.MaxVehicleSpeed and Weapon ~= Unarmed then
			DisableControlAction(1, 24)
			DisableControlAction(1, 140)
			DisablePlayerFiring(Player, true)
		else
			Wait(500)
		end
		Wait(4)
	end
end)
POS_actual = 1
PED_hasBeenTeleported = false

function teleport(pos)
    local targetPed = GetPlayerPed(-1)
    if(IsPedInAnyVehicle(targetPed))then
        targetPed = GetVehiclePedIsUsing(targetPed)
    end
    Citizen.CreateThread(function()
        PED_hasBeenTeleported = true
        NetworkFadeOutEntity(targetPed, true, false)
        Citizen.Wait(1)
        
        SetEntityCoords(targetPed, pos.x, pos.y, pos.z, 1, 0, 0, 1)
        SetEntityHeading(targetPed, pos.h)
        NetworkFadeInEntity(targetPed, 0)

        Citizen.Wait(1)
        PED_hasBeenTeleported = false
    end)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(ped, true)

        for i,pos in pairs(INTERIORS) do
            DrawMarker(1, pos.x, pos.y, pos.z-1, 0, 0, 0, 0, 0, 0, 1.0,1.0,0.5, 100, 100, 100, 0, 0, 0, 2, 0, 0, 0, 0)
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, pos.x, pos.y, pos.z) < 1.0) and (not PED_hasBeenTeleported) then
                POS_actual = pos.id
                if not gui_interiors.opened then
                    gui_interiors_OpenMenu()
                end
            end
        end
    end
end)
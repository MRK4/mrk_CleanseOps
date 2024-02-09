QBCore = exports['qb-core']:GetCoreObject()

local Framework = ConfigJob.framework

local Lang = ConfigJob.Lang

-- The position of the NPC
local NpcPosition = ConfigJob.NpcPosition
local NpcName = ConfigJob.NpcName
local NpcHash = GetHashKey(NpcName)

local useTarget = ConfigJob.useTarget

-- Missions config
local MissionsCost = ConfigJob.MissionsCost
local Missions = ConfigJob.Missions

local debug = ConfigJob.debug

local hasActiveMission = false

local function drawText(text, position)
    if not type(position) == "string" then position = "left" end
    SendNUIMessage({
        action = 'DRAW_TEXT',
        data = {
            text = text,
            position = position
        }
    })
end

local function hideText()
    SendNUIMessage({
        action = 'HIDE_TEXT',
    })
end

local function givePlayerMission()
    hasActiveMission = true
    -- select a random mission
    mission = Missions[math.random(1, #Missions)]

    if debug then print('Mission: ' .. mission.name) end

    local MissionPedHash = GetHashKey(mission.PedName)

    if IsModelAPed(MissionPedHash) then
        if debug then print('Mission: ' .. mission.PedName .. ' is a ped') end

        RequestModel(MissionPedHash)

        while not HasModelLoaded(MissionPedHash) do
            Citizen.Wait(100)
        end

        if (HasModelLoaded(MissionPedHash) and debug) then
            print('Mission: ' .. mission.PedName .. '(' .. MissionPedHash .. ')' .. ' has been loaded')
        end

        MissionPedToKill = CreatePed(1, MissionPedHash, mission.PedPosition.x, mission.PedPosition.y,
            mission.PedPosition.z, mission.PedPosition.h, true, true)

        -- Verify if the ped has to be aggressive
        if mission.IsPedAggressive then
            SetPedCombatAttributes(MissionPedToKill, 0, true)
            SetPedCombatAttributes(MissionPedToKill, 12, true)
            SetPedCombatAttributes(MissionPedToKill, 13, true)
            SetPedCombatAttributes(MissionPedToKill, 34, true)
            SetPedCombatAttributes(MissionPedToKill, 46, true)
            SetPedCombatAttributes(MissionPedToKill, 54, true)
            SetPedCombatAttributes(MissionPedToKill, 86, true)
        end

        -- Verify if the ped has to be armed
        if mission.PedWeapon then
            GiveWeaponToPed(MissionPedToKill, GetHashKey(mission.PedWeapon), 9999, false, true)
        end

        -- Add blip top the ped
        AddBlipForEntity(MissionPedToKill)

        -- Make the ped play an animation
        if mission.playingScenario and mission.playingScenario ~= "" and (not mission.pedDrivingVehicle or mission.pedDrivingVehicle == "") then
            Citizen.CreateThread(function()
                TaskStartScenarioInPlace(MissionPedToKill, mission.playingScenario, -1)
            end)
        end

        -- Make the ped drive a vehicle
        if mission.pedDrivingVehicle ~= "" and mission.pedDrivingVehicle ~= nil then
            if not mission.pedNeedsToDriveFast then
                mission.pedNeedsToDriveFast = false
            end

            RequestModel(mission.pedDrivingVehicle)

            while (not HasModelLoaded(mission.pedDrivingVehicle)) do
                Citizen.Wait(1)
            end

            if HasModelLoaded(mission.pedDrivingVehicle) then
                if debug then print(mission.pedDrivingVehicle .. ' has been loaded') end
            end

            local vehicle = CreateVehicle(mission.pedDrivingVehicle, mission.PedPosition.x, mission.PedPosition.y,
                mission.PedPosition.z, mission.PedPosition.h, true, true)

            Citizen.Wait(100)

            TaskWarpPedIntoVehicle(MissionPedToKill, vehicle, -1)

            -- Start the engine of the vehicle
            SetVehicleEngineOn(vehicle, true, true, false)

            -- Make the npc drive the vehicle
            if mission.pedNeedsToDriveFast then
                -- The ped will drive fast and insecure
                TaskVehicleDriveWander(MissionPedToKill, vehicle, 100.0, 788028)
            else
                -- The ped will drive normally and follow the rules
                TaskVehicleDriveWander(MissionPedToKill, vehicle, 50.0, 262591)
            end
        end

        -- Show a marker above the NPC to kill
        Citizen.CreateThread(function()
            local interval = 1
            while true do
                if (GetEntityHealth(MissionPedToKill) > 0) then
                    local npcCoords = GetEntityCoords(MissionPedToKill)

                    local distance = #(npcCoords - GetEntityCoords(GetPlayerPed(-1)))

                    if distance < 20.0 then
                        interval = 100
                        local x, y, z = table.unpack(npcCoords)
                        z = z + 1.1

                        DrawMarker(20, x, y, z, 0, 0, 0, 0, 0, 0, 0.25, 0.25, -0.25, 255, 0, 0, 200, true, true, 2,
                            nil,
                            nil,
                            false)
                    else
                        interval = 1
                    end
                end
                Citizen.Wait(interval)
            end
        end)

        -- Add waypoint to the ped
        SetNewWaypoint(mission.PedPosition.x, mission.PedPosition.y)

        -- If the ped is killed
        Citizen.CreateThread(function()
            while true do
                Wait(1000)
                if (GetEntityHealth(MissionPedToKill) <= 0) then
                    if debug then print('Mission: ' .. mission.PedName .. ' has been killed') end
                    -- Remove the blip
                    RemoveBlip(GetBlipFromEntity(MissionPedToKill))
                    -- Player can accept another mission
                    hasActiveMission = false
                    -- Trigger the reward
                    TriggerServerEvent('mrk_cleanseops:giveReward', mission.reward)

                    SetPedAsNoLongerNeeded(MissionPedToKill)
                    break
                end
            end
        end, false)
    end
end

RegisterNetEvent('mrk_cleanseops:givePlayerMission', function()
    Citizen.CreateThread(function()
        givePlayerMission()
    end, false)
end)

Citizen.CreateThread(function()
    RequestModel(NpcHash)

    while (not HasModelLoaded(NpcHash)) do
        Citizen.Wait(1)
    end

    local npc = CreatePed(1, NpcHash, NpcPosition.x, NpcPosition.y, NpcPosition.z, NpcPosition.h, true, true)

    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        FreezeEntityPosition(npc, true)
    end)

    if useTarget then
        exports['qb-target']:AddTargetEntity(npc, {
            options = {
                {
                    num = 1,
                    type = "client",
                    icon = 'fa-solid fa-people-robbery',
                    label = Lang['buy_mission'] .. MissionsCost,
                    action = function()
                        if hasActiveMission == false then
                            -- Start the mission
                            TriggerServerEvent('mrk_cleanseops:buyMission', MissionsCost)
                        else
                            TriggerEvent('QBCore:Notify', Lang['already_have_mission'], 'error')
                        end
                    end,
                }
            },
            distance = 1.5,
        })
    elseif useTarget == false then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                local playerPed = GetPlayerPed(-1)
                local coords = GetEntityCoords(playerPed)
                local distance = GetDistanceBetweenCoords(coords, NpcPosition.x, NpcPosition.y, NpcPosition.z, true)

                if distance < 2.0 then
                    TriggerEvent('qb-core:client:DrawText', Lang['buy_mission_no_target'] .. MissionsCost, 'left')
                    if IsControlJustReleased(0, 38) then
                        if hasActiveMission == false then
                            -- Start the mission
                            TriggerServerEvent('mrk_cleanseops:buyMission', MissionsCost)
                        else
                            TriggerEvent('QBCore:Notify', Lang['already_have_mission'], 'error')
                        end
                    end
                else
                    TriggerEvent('qb-core:client:HideText')
                end
            end
        end)
    end
end)


Citizen.CreateThread(function()
    blip = AddBlipForCoord(NpcPosition.x, NpcPosition.y, NpcPosition.z)
    SetBlipSprite(blip, ConfigJob.NpcBlipSprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, ConfigJob.NpcBlipSize)
    SetBlipColour(blip, ConfigJob.NpcBlipColor)
    SetBlipAsShortRange(blip, ConfigJob.SetBlipAsShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(ConfigJob.NpcBlipName)
    EndTextCommandSetBlipName(blip)
end)

-- (Debug) Test to spawn peds
-- Citizen.CreateThread(function()
--     -- Spawn a ped
--     RequestModel(GetHashKey('a_m_m_prolhost_01'))
--     while (not HasModelLoaded(GetHashKey('a_m_m_prolhost_01'))) do
--         Citizen.Wait(1)
--     end

--     if HasModelLoaded(GetHashKey('a_m_m_prolhost_01')) then
--         print('Model a_m_m_prolhost_01 has been loaded')
--     end

--     local npc2 = CreatePed(1, GetHashKey('a_m_m_prolhost_01'), -256.15, 1057.06, 235.79, 263.68, true, true)

--     SetPedCombatAttributes(npc2, 0, true)
--     SetPedCombatAttributes(npc2, 12, true)
--     SetPedCombatAttributes(npc2, 13, true)
--     SetPedCombatAttributes(npc2, 34, true)
--     SetPedCombatAttributes(npc2, 46, true)
--     SetPedCombatAttributes(npc2, 54, true)
--     SetPedCombatAttributes(npc2, 86, true)

--     vehicleModel = 'adder'

--     RequestModel(vehicleModel)

--     while (not HasModelLoaded(vehicleModel)) do
--         Citizen.Wait(1)
--     end

--     if HasModelLoaded(vehicleModel) then
--         print(vehicleModel .. ' has been loaded')
--     end

--     -- I want npc2 to spawn into a vehicle
--     local vehicle = CreateVehicle(vehicleModel, -256.15, 1057.06, 235.79, 263.68, true, true)

--     TaskWarpPedIntoVehicle(npc2, vehicle, -1)

--     -- Start the engine of the vehicle
--     SetVehicleEngineOn(vehicle, true, true, false)

--     -- make the npc drive the vehicle
--     TaskVehicleDriveWander(npc2, vehicle, 80.0, 786603)

--     GiveWeaponToPed(npc2, GetHashKey('WEAPON_PISTOL'), 1000, false, true)
--     HasPedGotWeapon(npc2, GetHashKey('WEAPON_PISTOL'), true)
-- end)

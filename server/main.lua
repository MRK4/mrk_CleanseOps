QBCore = exports['qb-core']:GetCoreObject()

local Lang = ConfigJob.Lang

RegisterServerEvent('mrk_cleanseops:buyMission', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.PlayerData.money['cash'] >= amount then
        Player.Functions.RemoveMoney('cash', amount)
        TriggerClientEvent('QBCore:Notify', src, Lang['mission_bought'], 'success')
        TriggerClientEvent('QBCore:Notify', src, Lang['gps_set'])
        TriggerClientEvent('mrk_cleanseops:givePlayerMission', src)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang['not_enough_money'], "error")
    end
end)

-- Event to give player the reward
RegisterServerEvent('mrk_cleanseops:giveReward', function(reward)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('bank', reward)
    TriggerClientEvent('QBCore:Notify', src, Lang['reward_message_1'] .. reward .. Lang['reward_message_2'],
        "success")
end)

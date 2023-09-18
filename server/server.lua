local QBCore = exports['qb-core']:GetCoreObject()

lib.callback.register('exp:server:checkRewardStatus', function()
    local src = source
    local row = MySQL.single.await('SELECT `reward` FROM `players` WHERE `citizenid` = ?', {
        QBCore.Functions.GetPlayer(src).PlayerData.citizenid
    })
    if not row then return end
    return (row.reward) or false
end)

-- Ketika pemain mengambil hadiah, update status hadiah dalam database menjadi "taken"
RegisterServerEvent('exp:server:getBox')
AddEventHandler('exp:server:getBox', function(level)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Config.LevelRewards[level] then
        for _,v in pairs(Config.LevelRewards[level]) do
            Player.Functions.AddItem(v.itemName, v.qty)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'Kamu tidak mendapatkan hadiah di level ini', 'error', 5000)
    end
    local success = MySQL.update.await('UPDATE players SET reward = ? WHERE citizenid = ?', {
        'true', Player.PlayerData.citizenid
    })
    if success and Config.LevelRewards[level] then
        TriggerClientEvent('QBCore:Notify', src, 'Berhasil mengambil reward', 'success', 5000)
    end
end)

RegisterNetEvent('xperience:server:rankUp', function(newRank, previousRank)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local success = MySQL.update.await('UPDATE players SET reward = ? WHERE citizenid = ?', {
        'false', Player.PlayerData.citizenid
    })
    if success then
        TriggerClientEvent('QBCore:Notify', src, 'Kamu bisa mengambil hadiah / reward', 'success', 5000)
    end
end)


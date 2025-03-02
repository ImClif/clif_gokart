local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('gokart:attemptStart', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money.cash >= Config.Cost then
        Player.Functions.RemoveMoney('cash', Config.Cost, 'GoKart Entry')
        TriggerClientEvent('gokart:start', src)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money!', 'error')
    end
end)

RegisterNetEvent('gokart:refundMoney', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Config.Cost, 'GoKart Refund')
    TriggerClientEvent('QBCore:Notify', src, 'Money refunded due to spawn failure.', 'error')
end)

RegisterNetEvent('gokart:returnKart', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', Config.RefundAmount, 'GoKart Refund')
    TriggerClientEvent('gokart:removeKart', src)
end)

local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sun:daily:givemoney', function(money)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddMoney("cash", money)
end)

RegisterNetEvent("sun:daily:giveitem", function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(item, 1, false)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[item], "add")
end)

RegisterNetEvent('sun:daily:removeitem', function(item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    Player.Functions.RemoveItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove")
end)
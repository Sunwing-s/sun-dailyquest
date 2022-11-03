local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('sun:daily:givemoney', function(money)
    local src = source
    local ply = QBCore.Functions.GetPlayer(src)
    ply.Functions.AddMoney("cash", money)
end)
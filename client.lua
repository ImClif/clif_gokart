local QBCore = exports['qb-core']:GetCoreObject()
local spawnedKart = nil

CreateThread(function()
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Wait(100)
    end
    local ped = CreatePed(4, Config.PedModel, Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z - 1.0, Config.PedCoords.w, false, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    
    exports.ox_target:addLocalEntity(ped, {
        {
            label = 'Play Go-Karts ($' .. Config.Cost .. ')',
            icon = 'fa-solid fa-flag-checkered',
            onSelect = function()
                TriggerServerEvent('gokart:attemptStart')
            end
        },
        {
            label = 'Return Go-Kart (Refund $' .. Config.RefundAmount .. ')',
            icon = 'fa-solid fa-undo',
            onSelect = function()
                TriggerServerEvent('gokart:returnKart')
            end,
            canInteract = function()
                return spawnedKart ~= nil and DoesEntityExist(spawnedKart)
            end
        }
    }, 2.5)
    

    if Config.Blip.Enable then
        local blip = AddBlipForCoord(Config.PedCoords.x, Config.PedCoords.y, Config.PedCoords.z)
        SetBlipSprite(blip, Config.Blip.Sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.Scale)
        SetBlipColour(blip, Config.Blip.Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('gokart:start', function()
    local ped = PlayerPedId()
    local vehicleHash = GetHashKey(Config.GoKartModel)
    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(100)
    end
    

    if IsAnyVehicleNearPoint(Config.SpawnCoords.x, Config.SpawnCoords.y, Config.SpawnCoords.z, 3.0) then
        TriggerEvent('QBCore:Notify', 'A vehicle is blocking the spawn point!', 'error')
        TriggerServerEvent('gokart:refundMoney') 
        return
    end
    
    spawnedKart = CreateVehicle(vehicleHash, Config.SpawnCoords.x, Config.SpawnCoords.y, Config.SpawnCoords.z, Config.SpawnCoords.w, true, false)
    SetPedIntoVehicle(ped, spawnedKart, -1)
    

    TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(spawnedKart))
end)

RegisterNetEvent('gokart:removeKart', function()
    if spawnedKart and DoesEntityExist(spawnedKart) then
        DeleteEntity(spawnedKart)
        spawnedKart = nil
    end
end)
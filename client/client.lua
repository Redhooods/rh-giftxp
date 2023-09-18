local QBCore = exports['qb-core']:GetCoreObject()
local sudahAmbil = false

CreateThread (function ()
    
    local data = Config.PedConfig
    local model = data.ped

    lib.requestModel(model, timeout)
    lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 1)
    ped = CreatePed(4, model,data.coords.x,data.coords.y,data.coords.z - 1, data.heading, false, true)
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, 431)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Balap Jetski')
    EndTextCommandDisplayText(0.5, 0.5)
    SetEntityHeading(ped, data.heading)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = 'exp:client:contextMenu',
                icon = "fa-solid fa-gift",
                label = "Menu XP",
               
            },
        },
        distance = 2.0
    })
end)

RegisterNetEvent("exp:client:contextMenu")
AddEventHandler("exp:client:contextMenu", function ()
    lib.registerContext({
        id = 'some_menu',
        title = 'Menu XP',
        options = {
          {
            title = 'Box XP',
            description = 'Anda Dapat Mengambil Box XP',
            icon = 'gift',
            event = "exp:client:getBox"
          },
          {
            title = 'Check XP',
            description = 'Anda Dapat Mengecek XP Anda',
            icon = 'star',
            event = "exp:client:checkXp"
          },
        }
      })
      lib.showContext("some_menu")
end)


RegisterNetEvent('exp:client:checkXp')
AddEventHandler('exp:client:checkXp', function ()
    local level = exports.xperience:GetRank()
    exports['okokNotify']:Alert("Info", "Level Anda: " .. level, 5000, 'info')
end)

RegisterNetEvent('exp:client:getBox')
AddEventHandler('exp:client:getBox', function(rewardName)
  local getReward = lib.callback.await('exp:server:checkRewardStatus', false)
  local level = exports.xperience:GetRank()
  if getReward == 'true' then
    TriggerEvent('QBCore:Notify', "Anda sudah mengambil hadiah", 'error', 5000)
  else
    TriggerServerEvent('exp:server:getBox', level)
  end
end)







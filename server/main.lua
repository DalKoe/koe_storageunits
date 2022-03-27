discord = {
  ['webhook'] = '',  ---PUT YOUR WEBHOOK URL HERE
  ['name'] = 'Storage Units'
}


----Gets ESX-----
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterNetEvent('koe_storageunits:checkUnit')
AddEventHandler('koe_storageunits:checkUnit', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID
    }, 
    function(result)
        if result[1].identifier == nil then
          TriggerClientEvent('koe_storageunits:buyMenu', src, storageID)
        elseif result[1].identifier == identifier then
          TriggerClientEvent('koe_storageunits:ownerMenu', src, storageID)
        else
          TriggerClientEvent('koe_storageunits:otherMenu', src, storageID)
        end
    end)
end)

ESX.RegisterServerCallback('koe_storageunits:checkPin', function(source, cb, storageID, pinnum)
 MySQL.Async.fetchAll("SELECT pin FROM storageunits WHERE id = @id",{
    ["@id"] = storageID,
 },
function(result)
        if result[1].pin == pinnum then
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterNetEvent('koe_storageunits:pinChange')
AddEventHandler('koe_storageunits:pinChange', function(storageID,pin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier
               MySQL.Async.fetchAll("UPDATE storageunits SET pin = @pin WHERE id =@id",{['@pin']  = pin, ['@id'] = storageID}, function(result)
            end)
end)

RegisterNetEvent('koe_storageunits:buyUnit')
AddEventHandler('koe_storageunits:buyUnit', function(storageID,pin)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID
    },
    function(result2) 

            if xPlayer.getMoney() >= Config.UnitPrice then
              MySQL.Async.fetchAll("UPDATE storageunits SET identifier = @identifier WHERE id =@id",{['@identifier']  = identifier, ['@id'] = storageID}, function(result)
                xPlayer.removeMoney(Config.UnitPrice)
              end)
               MySQL.Async.fetchAll("UPDATE storageunits SET pin = @pin WHERE id =@id",{['@pin']  = pin, ['@id'] = storageID}, function(result)
              end)
            end

    end) 
end)

RegisterNetEvent('koe_storageunits:sellUnit')
AddEventHandler('koe_storageunits:sellUnit', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll('SELECT * FROM storageunits WHERE id = @id',
    { 
      ['@identifier'] = owner,
      ['@id'] = storageID
    }, 
    function(result2) 
    
              MySQL.Async.fetchAll("UPDATE storageunits SET identifier = @identifier, pin = @pin WHERE id =@id",{['@identifier']  = identifier, ['@id'] = storageID, ['@pin'] = pin}, function(result)
                xPlayer.addMoney(Config.SellPrice)
              end)
    end)
end)

RegisterNetEvent('koe_storageunits:registerStash')
AddEventHandler('koe_storageunits:registerStash', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifier =  ESX.GetPlayerFromId(src).identifier

    MySQL.Async.fetchAll('SELECT id FROM storageunits WHERE id = @id',
    { 
      ['@id'] = storageID
    }, 
    function(result3)
        local stashsave = result3[1].stashsave
        exports.ox_inventory:RegisterStash(stashsave, "Storage Unit", 70, 300000)
        TriggerClientEvent('koe_storageunits:openStash', src, stashsave)
    end)
end)

RegisterNetEvent('koe_storageunits:breachLog')
AddEventHandler('koe_storageunits:breachLog', function(storageID)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    discordLog(xPlayer.getName() ..  ' - ' .. xPlayer.getIdentifier(), 'has breached the unit #' ..storageID)
end)

function discordLog(name, message)
  local data = {
      {
          ["color"] = '3553600',
          ["title"] = "**".. name .."**",
          ["description"] = message,
      }
  }
  PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data}), { ['Content-Type'] = 'application/json' })
end

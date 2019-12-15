RegisterServerEvent('redemrp_skin:createSkin')
AddEventHandler('redemrp_skin:createSkin', function(skin, cb)
	local _skin = skin
	local decode = json.decode(skin)
	TriggerEvent('redemrp:getPlayerFromId', source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
	TriggerEvent("redemrp_db:retrieveSkin", identifier, charid, function(call)
	
if call then

	MySQL.Async.execute("UPDATE skins SET `skin`='" .. _skin .. "' WHERE `identifier`=@identifier AND `charid`=@charid", {identifier = identifier, charid = charid}, function(done)
		end)
else

	MySQL.Async.execute('INSERT INTO skins (`identifier`, `charid`, `skin`) VALUES (@identifier, @charid, @skin);',
	{
		identifier = identifier,
		charid = charid,
		skin = _skin
	}, function(rowsChanged)
		end)
end
	end)

	end)
end)

RegisterServerEvent('redemrp_skin:loadSkin')
AddEventHandler('redemrp_skin:loadSkin', function()
local _source = source
	TriggerEvent('redemrp:getPlayerFromId', source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
			--print(identifier)
			
		MySQL.Async.fetchAll('SELECT * FROM skins WHERE `identifier`=@identifier AND `charid`=@charid;', {identifier = identifier, charid = charid}, function(skins)
		--print(skins[1].skin)
		if skins[1] then
		local skin = skins[1].skin
		TriggerClientEvent("redemrp_skin:applySkin", _source, skin)
		else end
		end)
	end)
end)

AddEventHandler('redemrp_db:retrieveSkin', function(identifier, charid, callback)
	local Callback = callback
	MySQL.Async.fetchAll('SELECT * FROM skins WHERE `identifier`=@identifier AND `charid`=@charid;', {identifier = identifier, charid = charid}, function(skins)
		if skins[1] then
			Callback(skins[1])
		else
			Callback(false)
		end
	end)
end)

RegisterServerEvent("redemrp_skin:deleteSkin")
AddEventHandler("redemrp_skin:deleteSkin", function(charid, Callback) 
    local _source = source
    local id
    for k,v in ipairs(GetPlayerIdentifiers(_source))do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            id = v
            break
        end
    end
	
  local Callback = callback
	MySQL.Async.fetchAll('DELETE FROM skins WHERE `identifier`=@identifier AND `charid`=@charid;', {identifier = id, charid = charid}, function(result)
		if result then
		else
		end
	end)
end)

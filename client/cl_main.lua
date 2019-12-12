local adding = true
local adding2 = true
local sex = 1
local maleheads = {}
local maletorsos = {}
local malelegs = {}
local maleeyes = {}
local malehairs = {}
local femaleheads = {}
local femaletorsos = {}
local femalelegs = {}
local femaleeyes = {}
local femalehairs = {}


Citizen.CreateThread(function()
while adding do
Citizen.Wait(0)
--print("Dzieje sie")
		for i, v in ipairs(MaleComp) do
			if v.category == "heads" then
				table.insert(maleheads, v.Hash)
			elseif v.category == "torsos" then
				table.insert(maletorsos, v.Hash)
			elseif v.category == "legs" then
				table.insert(malelegs, v.Hash)
			elseif v.category == "eyes" then
				table.insert(maleeyes, v.Hash)
			elseif v.category == "hair" then
				table.insert(malehairs, v.Hash)
			else end
		end
		adding = false
	end
end)

Citizen.CreateThread(function()
while adding2 do
Citizen.Wait(0)
--print("Dzieje sie 2")
		for i, v in ipairs(FemaleComp) do
			if v.category == "heads" then
				table.insert(femaleheads, v.hash)
			elseif v.category == "torsos" then
				table.insert(femaletorsos, v.hash)
			elseif v.category == "legs" then
				table.insert(femalelegs, v.hash)
			elseif v.category == "eyes" then
				table.insert(femaleeyes, v.hash)
			elseif v.category == "hair" then
				table.insert(femalehairs, v.hash)
			else end
		end
		adding2 = false
	end
end)


RegisterCommand("creator", function(source, args, rawCommand)
     TriggerEvent('redemrp_skin:openCreator')
end)

RegisterNetEvent('redemrp_skin:openCreator')
AddEventHandler('redemrp_skin:openCreator', function(source)
	Wait(5000)
     SetNuiFocus(true, true)
	 local ped = PlayerPedId()
	 SetEntityCoords(ped, -329.24, 775.37, 120.65)
	 SetEntityHeading(ped, 245.05)
		cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -326.12,774.84,121.64, 300.00,0.00,0.00, 40.00, false, 0)
		PointCamAtCoord(cam, -329.24, 775.37, 121.53)
		SetCamActive(cam, true)
		RenderScriptCams(true, false, 1, true, true)
		DisplayHud(false)
		DisplayRadar(false)
		FreezeEntityPosition(ped, true)
	 SendNUIMessage({
                show = 1
      })
end)


RegisterCommand("loadskin", function(source, args, rawCommand)
     TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
	 end)
end)

RegisterNetEvent('redemrp_skin:applySkin')
AddEventHandler('redemrp_skin:applySkin', function(skin)
local _skin = json.decode(skin)
local player = PlayerId()
local model = "mp_male"
local torso = '0x' .. maletorsos[6]
local legs = '0x' .. malelegs[5]
local head = '0x' .. maleheads[8]
local sex = 1
--print (_skin.sex)

	if _skin.sex == "male" then
	model = "mp_male"
	sex = 1
	else
	model = "mp_female"
	sex = 2
	end
	local model2 = GetHashKey(model)
	RequestModel(model)
	Citizen.Wait(100)
	if HasModelLoaded(model2) then
		--print("LOADED 1")
		SetPlayerModel(player, model2, false)
		Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
		SetModelAsNoLongerNeeded(model2)
		else 
		--print("NOT LOADED AT 1")
		RequestModel(model2)
		Citizen.Wait(500)
		SetPlayerModel(player, model2, false)
		Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
		SetModelAsNoLongerNeeded(model2)
		end
	Citizen.Wait(100)	
if sex == 1 then
	local twarz = '0x' .. maleheads[tonumber(_skin.face)]
	local faces = math.floor(tonumber(_skin.faces) + 109)
	--print (_skin.fat)
	local size = math.floor(tonumber(_skin.fat) + 123)
	local oczy = '0x' .. maleeyes[tonumber(_skin.eye)]
	local wlosy = '0x' .. malehairs[tonumber(_skin.hair)]
	if tonumber(_skin.skin) == 1 then
	torso = '0x' .. maletorsos[6]
	legs = '0x' .. malelegs[5]
	head = '0x' .. maleheads[8]
	elseif tonumber(_skin.skin) == 2 then
	torso = '0x' .. maletorsos[2]
	legs = '0x' .. malelegs[5]
	head = '0x' .. maleheads[5]
	elseif tonumber(_skin.skin) == 3 then
	torso = '0x' .. maletorsos[4]
	legs = '0x' .. malelegs[1]
	head = '0x' .. maleheads[11]
	elseif tonumber(_skin.skin) == 4 then
	torso = '0x' .. maletorsos[7]
	legs = '0x' .. malelegs[3]
	head = '0x' .. maleheads[3]
	elseif tonumber(_skin.skin) == 5 then
	torso = '0x' .. maletorsos[5]
	legs = '0x' .. malelegs[4]
	head = '0x' .. maleheads[4]
	elseif tonumber(_skin.skin) == 6 then
	torso = '0x' .. maletorsos[3]
	legs = '0x' .. malelegs[2]
	head = '0x' .. maleheads[9]
	else end
	Citizen.Wait(1000)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(torso),true,true,true)
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(legs),true,true,true)
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(head),true,true,true)
	Citizen.Wait(300)
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(size),true,true) -- Body SIZE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(faces),true,true) -- FACE SIZE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz),true,true,true) -- FACE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy),true,true,true) -- EYES
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy),true,true,true) -- HAIR
else
local twarz2 = '0x' .. femaleheads[tonumber(_skin.face)]
local faces2 = math.floor(tonumber(_skin.faces) + 95)
local oczy2 = '0x' .. femaleeyes[tonumber(_skin.eye)]
local wlosy2 = '0x' .. femalehairs[tonumber(_skin.hair)]
local size2 = math.floor(tonumber(_skin.fat) + 109)
local torso2 = '0x' .. femaletorsos[6]
local legs2 = '0x' .. femalelegs[1]
local head2 = '0x' .. femaleheads[6]
if tonumber(_skin.skin) == 1 then
	torso2 = '0x' .. femaletorsos[6]
	legs2 = '0x' .. femalelegs[1]
	head2 = '0x' .. femaleheads[6]
	elseif tonumber(_skin.skin) == 2 then
	torso2 = '0x' .. femaletorsos[3]
	legs2 = '0x' .. femalelegs[2]
	head2 = '0x' .. femaleheads[11]
	elseif tonumber(_skin.skin) == 3 then
	torso2 = '0x' .. femaletorsos[2]
	legs2 = '0x' .. femalelegs[3]
	head2 = '0x' .. femaleheads[9]
	elseif tonumber(_skin.skin) == 4 then
	torso2 = '0x' .. femaletorsos[4]
	legs2 = '0x' .. femalelegs[5]
	head2 = '0x' .. femaleheads[3]
	elseif tonumber(_skin.skin) == 5 then
	torso2 = '0x' .. femaletorsos[8]
	legs2 = '0x' .. femalelegs[6]
	head2 = '0x' .. femaleheads[2]
	elseif tonumber(_skin.skin) == 6 then
	torso2 = '0x' .. femaletorsos[9]
	legs2 = '0x' .. femalelegs[8]
	head2 = '0x' .. femaleheads[10]
	else end
	Citizen.Wait(1000)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(torso2),true,true,true)
	Citizen.Wait(500)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(legs2),true,true,true)
	Citizen.Wait(500)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(head2),true,true,true)
	Citizen.Wait(500)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x10F5497A,true,true,true) -- PANTS
	Citizen.Wait(500)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x14511493,true,true,true) -- COAT
	Citizen.Wait(300)
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(size2),true,true) -- Body SIZE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(faces2),true,true) -- FACE SIZE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz2),true,true,true) -- FACE
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy2),true,true,true) -- EYES
	Citizen.Wait(300)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy2),true,true,true) -- HAIR
end		
end)

RegisterNUICallback('saveSkin', function(data, cb)
SetNuiFocus(false, false)
local t = {
["sex"] = data.sex,
["fat"] = data.grubosc,
["face"] = data.face,
["faces"] = data.faces,
["skin"] = data.skin,
["eye"] = data.eye,
["hair"] = data.hair
}
			local ped = PlayerPedId()
			FreezeEntityPosition(ped, false)
			DisplayHud(true)
			DisplayRadar(true)
			SetCamActive(cam, false)
			DestroyCam(cam, true)
			
			local json = json.encode(t)
			TriggerServerEvent("redemrp_skin:createSkin", json, function(cb)
				if cb then
				print("DONE")
				else
				print("ERROR")
				end
			end)
			DestroyAllCams()
end)


RegisterNUICallback('changeSex', function(data, cb)
local plec = data
local model = "mp_male"
local player = PlayerId()
if plec == 1 then
	model = "mp_male"
	sex = 1
	else
	model = "mp_female"
	sex = 2
end
local model2 = GetHashKey(model)
--print(player)
	TriggerEvent("redemrp_skin:changeSex2", model2)
	if sex == 2 then
	TriggerEvent("redemrp_skin:defaultFClothes")
	else end
end)

RegisterNetEvent('redemrp_skin:changeSex2')
AddEventHandler('redemrp_skin:changeSex2', function(model)
local model2 = model
	RequestModel(model2)
	Citizen.Wait(100)
	if HasModelLoaded(model2) then
		--print("LOADED 1")
		SetPlayerModel(player, model2, false)
		Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
		SetModelAsNoLongerNeeded(model2)
		else 
		--print("NOT LOADED AT 1")
		RequestModel(model2)
		Citizen.Wait(500)
		SetPlayerModel(player, model2, false)
		Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
		SetModelAsNoLongerNeeded(model2)
		end
end)

RegisterNetEvent('redemrp_skin:defaultFClothes')
AddEventHandler('redemrp_skin:defaultFClothes', function()
Citizen.Wait(500)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x10F5497A,true,true,true) -- PANTS
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x14511493,true,true,true) -- COAT
end)

RegisterNUICallback('changeFace', function(data, cb)
local face = data
if sex == 1 then
local twarz = '0x' .. maleheads[tonumber(face)]
--print (face)
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz),true,true,true)
else
local twarz2 = '0x' .. femaleheads[tonumber(face)]
--print (face)
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz2),true,true,true)
end
end)

RegisterNUICallback('changeSkin', function(data, cb)
local skin = data
local torso = '0x' .. maletorsos[6]
local legs = '0x' .. malelegs[5]
if sex == 1 then
	if tonumber(skin) == 1 then
	torso = '0x' .. maletorsos[6]
	legs = '0x' .. malelegs[5]
	elseif tonumber(skin) == 2 then
	torso = '0x' .. maletorsos[2]
	legs = '0x' .. malelegs[5]
	elseif tonumber(skin) == 3 then
	torso = '0x' .. maletorsos[4]
	legs = '0x' .. malelegs[1]
	elseif tonumber(skin) == 4 then
	torso = '0x' .. maletorsos[7]
	legs = '0x' .. malelegs[3]
	elseif tonumber(skin) == 5 then
	torso = '0x' .. maletorsos[5]
	legs = '0x' .. malelegs[4]
	elseif tonumber(skin) == 6 then
	torso = '0x' .. maletorsos[3]
	legs = '0x' .. malelegs[2]
	else end
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(torso),true,true,true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(legs),true,true,true)
else
local torso2 = '0x' .. femaletorsos[6]
local legs2 = '0x' .. femalelegs[1]
if tonumber(skin) == 1 then
	torso2 = '0x' .. femaletorsos[6]
	legs2 = '0x' .. femalelegs[1]
	elseif tonumber(skin) == 2 then
	torso2 = '0x' .. femaletorsos[3]
	legs2 = '0x' .. femalelegs[2]
	elseif tonumber(skin) == 3 then
	torso2 = '0x' .. femaletorsos[2]
	legs2 = '0x' .. femalelegs[3]
	elseif tonumber(skin) == 4 then
	torso2 = '0x' .. femaletorsos[4]
	legs2 = '0x' .. femalelegs[5]
	elseif tonumber(skin) == 5 then
	torso2 = '0x' .. femaletorsos[8]
	legs2 = '0x' .. femalelegs[6]
	elseif tonumber(skin) == 6 then
	torso2 = '0x' .. femaletorsos[9]
	legs2 = '0x' .. femalelegs[8]
	else end
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(torso2),true,true,true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(legs2),true,true,true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x10F5497A,true,true,true) -- PANTS
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x14511493,true,true,true) -- COAT
end
end)

RegisterNUICallback('changeEye', function(data, cb)
local eye = data
if sex == 1 then
local oczy = '0x' .. maleeyes[tonumber(eye)]
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy),true,true,true)
else
local oczy2 = '0x' .. femaleeyes[tonumber(eye)]
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy2),true,true,true)
end
end)

RegisterNUICallback('changeHair', function(data, cb)
local hair = data
if sex == 1 then
local wlosy = '0x' .. malehairs[tonumber(hair)]
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy),true,true,true)
else
local wlosy2 = '0x' .. femalehairs[tonumber(hair)]
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy2),true,true,true)
end
end)

RegisterNUICallback('changeFacesize', function(data, cb)
local faces = data.faces
local face = data.face
local twarz = '0x' .. maleheads[tonumber(face)]
local twarz2 = '0x' .. femaleheads[tonumber(face)]
local facet = 110
local facet2 = 96
if sex == 1 then
--print(math.floor(faces + 109))
Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(faces + 109),true,true)
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz),true,true,true)
else
--print(math.floor(faces + 95))
Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(faces + 95),true,true)
Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz2),true,true,true)
end
end)

RegisterNUICallback('changeBody', function(data, cb)
local size = data.grubosc
local face = data.face
local twarz = '0x' .. maleheads[tonumber(face)]
local twarz2 = '0x' .. femaleheads[tonumber(face)]
if sex == 1 then
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(size+123),true,true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz),true,true,true)
else
	Citizen.InvokeNative(0xA5BAE410B03E7371 ,PlayerPedId(),math.floor(size+109),true,true)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz2),true,true,true)
end
end)
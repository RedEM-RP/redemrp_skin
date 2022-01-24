local isSkinCreatorOpened = false
local list = {}
local list_f = {}
local components_data = {}
local overlay_ped = PlayerPedId()
local cam = nil
local c_zoom = 2.8
local c_offset = -0.15
local textureId = -1
local overlay_opacity = 1.0
local ped_sex = 1
local torso
local legs
local features = {
    0x84D6,0x3303,0x2FF9,0x4AD1 ,0xC04F,0xB6CE,0x2844,0xED30,0x6A0B,0xABCF,0x358D,
    0x8D0A,0xEBAE ,0x1DF6,0x3C0F,0xC3B2,0xE323,0x8B2B ,0x1B6B ,0xEE44 ,0xD266 ,0xA54E, 0xDDFB ,0x6E7F ,0x3471,0x03F5,
    0x34B1,0xF156,0x561E ,0xF065,0xAA69,0x7AC3, 0x410D, 0x1A00,0x91C1,0xC375,0xBB4D,0xB0B0,0x5D16,
}
local features_name = {
    "face_width",
    "eyebrow_height",
    "eyebrow_width",
    "eyebrow_depth",
    "ears_width",
    "ears_angle",
    "ears_height",
    "earlobe_size",
    "cheekbones_height",
    "cheekbones_width",
    "cheekbones_depth",
    "jaw_height",
    "jaw_width",
    "jaw_depth",
    "chin_height",
    "chin_width",
    "chin_depth",
    "eyelid_height",
    "eyelid_width",
    "eyes_depth",
    "eyes_angle",
    "eyes_distance",
    "eyes_height",
    "nose_width",
    "nose_size",
    "nose_height",
    "nose_angle",
    "nose_curvature",
    "nostrils_distance",
    "mouth_width",
    "mouth_depth",
    "mouth_y_pos",
    "mouth_x_pos",
    "upper_lip_height",
    "upper_lip_width",
    "upper_lip_depth",
    "lower_lip_height",
    "lower_lip_width",
    "lower_lip_depth",
}

local BODY_TYPES = {
    32611963,
    -20262001,
    -369348190,
    -1241887289,
    61606861,
}



RegisterNetEvent('redemrp_skin:openCreator')
AddEventHandler('redemrp_skin:openCreator', function()
    local ped = PlayerPedId()
    local pp = GetEntityCoords(ped)
    Wait(6000)
    SetEntityCoords(ped, pp.x, pp.y, pp.z)
    SetEntityHeading(ped, 274.05)
    FreezeEntityPosition(ped, true)
    Wait(1000)
    ShowSkinCreator(true)
    isSkinCreatorOpened = true
    camera(2.8,-0.15)
    SetPlayerInvincible(PlayerId(),true)
    Light()
end)

function ShowSkinCreator(enable)
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        openSkinCreator = enable
    })
end


Citizen.CreateThread(function()
    for i,v in pairs(cloth_hash_names) do
        if v.category_hashname == "BODIES_LOWER"
            or v.category_hashname == "BODIES_UPPER"
            or  v.category_hashname == "heads"
            or  v.category_hashname == "hair"
            or  v.category_hashname == "teeth"
            or  v.category_hashname == "eyes"
            or  v.category_hashname == "beards_chin"
            or  v.category_hashname == "beards_chops"
            or  v.category_hashname == "beard"  then
            if v.ped_type == "female" and v.is_multiplayer and v.hashname ~= "" then
                if list_f[v.category_hashname] == nil then
                    list_f[v.category_hashname] = {}
                end
                table.insert(list_f[v.category_hashname], v.hash)
            elseif v.ped_type == "male" and v.is_multiplayer and v.hashname ~= ""  then
                if  list[v.category_hashname] == nil then
                    list[v.category_hashname] = {}
                end

                table.insert(list[v.category_hashname], v.hash)
            end
        end
    end

end)



RegisterCommand("loadskin", function(source, args, rawCommand)
    TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
        end)
end)

RegisterNetEvent('redemrp_skin:LoadSkinClient')
AddEventHandler('redemrp_skin:LoadSkinClient', function()
    TriggerServerEvent("redemrp_skin:loadSkin")
end)

RegisterCommand("creator", function(source, args, rawCommand)
    TriggerEvent("redemrp_skin:openCreator")
end)

RegisterNUICallback('saveSkin', function(data, cb)
    SetNuiFocus(false, false)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    DisplayHud(true)
    DisplayRadar(true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    TriggerServerEvent("redemrp_skin:createSkin", data)
    DestroyAllCams()
    isSkinCreatorOpened = false
    ShowSkinCreator(false)
    SetPlayerInvincible(PlayerId(),false)
end)



RegisterNetEvent('redemrp_skin:applySkin')
AddEventHandler('redemrp_skin:applySkin', function(_data, target , clothes)
    Citizen.CreateThread(function()
        local _clothes = clothes
        local _t = target
        local _target = _t or PlayerPedId()
        local test = false
		
        local data = _data
        if _t == nil then
            local model = "mp_male"
            if tonumber(data.sex) == 1 then
                model = "mp_male"
            elseif tonumber(data.sex) == 2 then
                model = "mp_female"
            end
            LoadModel(PlayerPedId() , model)
            _target =  PlayerPedId()
			SetEntityAlpha(_target, 0)
        end
				components_data = data
        while test == false do
	    print("Loading...")            
            FixIssues(_target, data)
            LoadBoody(_target, data)
            LoadHead(_target, data)
            LoadHair(_target, data)
            LoadEyes(_target, data)
            LoadBodySize(_target, data)
            LoadFeatures(_target, data)
            LoadOverlays(_target, data)
            Wait(500)
            Citizen.InvokeNative(0x704C908E9C405136, _target)
            Citizen.InvokeNative(0xCC8CA3E88256E58F, _target, 0, 1, 1, 1, 0)
            test =  HasBodyComponentsLoaded (_target ,tonumber(data.hair) > 1 , tonumber(data.beard) > 1)
	    LoadHeight(_target, data)
        end
        if _t == nil then
			SetEntityAlpha(_target, 255)
            TriggerServerEvent("redemrp_clothing:loadClothes", 1)
            TriggerServerEvent('redemrp_respawn:TestDeathStatus')
        else
			if not next(_clothes) then
				TriggerEvent("redemrp_identity:removeLoadingScreen")
			else
				TriggerEvent("redemrp_clothing:load", _clothes, _target)
			end
            
        end
    end)
end)



RegisterNUICallback('updateBody', function(data, cb)
    TriggerEvent("redemrp_skin:updateBody" , data)
end)

RegisterNetEvent('redemrp_skin:updateBody')
AddEventHandler('redemrp_skin:updateBody', function(data)
    if ped_sex ~= tonumber(data.sex) and  data.sex ~= nil then
        ped_sex = tonumber(data.sex)
        local model = "mp_male"
        local player = PlayerId()
        if ped_sex == 1 then
            model = "mp_male"
            sex = 1
        elseif ped_sex == 2 then
            model = "mp_female"
            sex = 2
        end
        LoadModel(PlayerPedId() , model)
        FixIssues(PlayerPedId(), data)
    end
    LoadBoody(PlayerPedId(), data , true)
    LoadHead(PlayerPedId(), data)
    LoadHair(PlayerPedId(), data)
    LoadEyes(PlayerPedId(), data)
    LoadBodySize(PlayerPedId(), data)
    LoadFeatures(PlayerPedId(), data , true)
    Citizen.CreateThread(function()
        LoadOverlays(PlayerPedId(), data)
    end)
    LoadHeight(PlayerPedId(), data)

end)


local headingss = 334.00
RegisterNUICallback('heading', function(data)
    local playerPed = PlayerPedId()
    headingss = headingss + data.value
    SetEntityHeading(playerPed, headingss)
end)


RegisterNUICallback('camera', function(data)
    if data.zoom ~= nil then
        if c_zoom + data.zoom < 2.8 and  c_zoom + data.zoom > 0.7 then
            c_zoom = c_zoom + data.zoom
        end
    end
    if data.offset ~= nil then
        if  c_offset + data.offset < 1.2 and  c_offset + data.offset > -1.0 then
            c_offset = c_offset + data.offset
        end
    end
    camera(c_zoom ,c_offset)
end)

RegisterNUICallback('defcam', function(data)
    camera(2.8,-0.15)
    c_zoom = 2.8
    c_offset = -0.15
end)

function destory()
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    DisplayHud(true)
    DisplayRadar(true)
    DestroyAllCams(true)
    cam = nil
end

function camera(zoom, offset)
    DestroyAllCams(true)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local heading = 45.0
    local zoomOffset = zoom
    local camOffset = offset
    local angle = heading * math.pi / 180.0
    local theta = {
        x = math.cos(angle),
        y = math.sin(angle)
    }
    local pos = {
        x = coords.x + (zoomOffset * theta.x),
        y = coords.y + (zoomOffset * theta.y)
    }
    local angleToLook = heading - 140.0
    if angleToLook > 360 then
        angleToLook = angleToLook - 360
    elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
    end
    angleToLook = angleToLook * math.pi / 180.0
    local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
    }
    local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y)
    }
    local add = (1.3*zoom)
    SetEntityHeading(playerPed, headingss)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, coords.z + camOffset, 300.00,0.00,0.00, 40.00, false, 0)
    PointCamAtCoord(cam, posToLook.x-add, posToLook.y, coords.z + camOffset)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    DisplayHud(false)
    DisplayRadar(false)
end


function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

function Light()
    while isSkinCreatorOpened do
        Wait(1)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        DrawLightWithRange(coords.x+1 , coords.y+1 , coords.z + 1, 255, 255, 255, 2.5 ,10.0)
    end
end

function toggleOverlayChange(_name,_visibility,_tx_id,_tx_normal,_tx_material,_tx_color_type,_tx_opacity,_tx_unk,_palette_id,_palette_color_primary,_palette_color_secondary,_palette_color_tertiary,_var,_opacity, _targets)

    Citizen.CreateThread(function()
        local name = _name
        local visibility = _visibility
        local tx_id = _tx_id
        local tx_normal = _tx_normal
        local tx_material = _tx_material
        local tx_color_type = _tx_color_type
        local tx_opacity = _tx_opacity
        local tx_unk = _tx_unk
        local palette_id = _palette_id
        local palette_color_primary = _palette_color_primary
        local palette_color_secondary = _palette_color_secondary
        local palette_color_tertiary = _palette_color_tertiary
        local var = _var
        local opacity = _opacity
        local target = _targets


        for k,v in pairs(overlay_all_layers) do
            if v.name==name then
                v.visibility = visibility
                if visibility ~= 0 then
                    v.tx_normal = tx_normal
                    v.tx_material = tx_material
                    v.tx_color_type = tx_color_type
                    v.tx_opacity =  tx_opacity
                    v.tx_unk =  tx_unk
                    if tx_color_type == 0 then
                        v.palette = color_palettes[palette_id][1]
                        v.palette_color_primary = palette_color_primary
                        v.palette_color_secondary = palette_color_secondary
                        v.palette_color_tertiary = palette_color_tertiary
                    end
                    if name == "shadows" or name == "eyeliners" or name == "lipsticks" then
                        v.var = var
                        v.tx_id = overlays_info[name][1].id
                    else
                        v.var = 0
                        v.tx_id = overlays_info[name][tx_id].id
                    end
                    v.opacity = opacity
                end
            end
        end
        local ped = target
        if IsPedMale(ped) then
            current_texture_settings = texture_types["male"]
        else
            current_texture_settings = texture_types["female"]
        end
        if textureId ~= -1 then
            Citizen.InvokeNative(0xB63B9178D0F58D82,textureId)  -- reset texture
            Citizen.InvokeNative(0x6BEFAA907B076859,textureId)  -- remove texture
        end
        textureId = Citizen.InvokeNative(0xC5E7204F322E49EB,current_texture_settings.albedo, current_texture_settings.normal, current_texture_settings.material);  -- create texture
        for k,v in pairs(overlay_all_layers) do
            if v.visibility ~= 0 then
                local overlay_id = Citizen.InvokeNative(0x86BB5FF45F193A02,textureId, v.tx_id , v.tx_normal, v.tx_material, v.tx_color_type, v.tx_opacity,v.tx_unk); -- create overlay
                if v.tx_color_type == 0 then
                    Citizen.InvokeNative(0x1ED8588524AC9BE1,textureId,overlay_id,v.palette);    -- apply palette
                    Citizen.InvokeNative(0x2DF59FFE6FFD6044,textureId,overlay_id,v.palette_color_primary,v.palette_color_secondary,v.palette_color_tertiary)  -- apply palette colours
                end
                Citizen.InvokeNative(0x3329AAE2882FC8E4,textureId,overlay_id, v.var);  -- apply overlay variant
                Citizen.InvokeNative(0x6C76BC24F8BB709A,textureId,overlay_id, v.opacity); -- apply overlay opacity
            end
        end
        while not Citizen.InvokeNative(0x31DC8D3F216D8509,textureId) do  -- wait till texture fully loaded
            Citizen.Wait(0)
        end
        Citizen.InvokeNative(0x0B46E25761519058,ped,GetHashKey("heads"),textureId)  -- apply texture to current component in category "heads"
        Citizen.InvokeNative(0x92DAABA2C1C10B0E,textureId)      -- update texture
        Citizen.InvokeNative(0xCC8CA3E88256E58F,ped, 0, 1, 1, 1, false);  -- refresh ped components
    end)
end

function LoadModel(target , model)
    local _model = GetHashKey(model)
    while not HasModelLoaded( _model ) do
        Wait(1)
        modelrequest( _model )
    end
    Citizen.Wait(100)
    Citizen.InvokeNative(0xED40380076A31506, PlayerId(), _model , false)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4,PlayerPedId(),0,0)

    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C,PlayerPedId()) do
        Wait(1)
    end
end

function LoadBoody(target , data , update)
    if IsPedMale(target) then
        if tonumber(data.skincolor) == 1 then
            torso = list["BODIES_UPPER"][1]
            legs =  list["BODIES_LOWER"][1]
            texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
        elseif tonumber(data.skincolor) == 2 then
            torso = list["BODIES_UPPER"][10]
            legs = list["BODIES_LOWER"][10]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 3 then
            torso = list["BODIES_UPPER"][3]
            legs = list["BODIES_LOWER"][3]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc02_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 4 then
            torso = list["BODIES_UPPER"][11]
            legs = list["BODIES_LOWER"][11]
            texture_types["male"].albedo = GetHashKey("head_mr1_sc04_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 5 then
            torso = list["BODIES_UPPER"][8]
            legs = list["BODIES_LOWER"][8]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc01_c0_000_ab")
        elseif tonumber(data.skincolor) == 6 then
            torso = list["BODIES_UPPER"][30]
            legs = list["BODIES_LOWER"][30]
            texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc05_c0_000_ab")
        end

    else
        if tonumber(data.skincolor) == 1 then
            torso = list_f["BODIES_UPPER"][1]
            legs = list_f["BODIES_LOWER"][1]
            texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
        elseif tonumber(data.skincolor) == 2 then
            torso = list_f["BODIES_UPPER"][10]
            legs = list_f["BODIES_LOWER"][10]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 3 then
            torso = list_f["BODIES_UPPER"][3]
            legs = list_f["BODIES_LOWER"][3]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
        elseif tonumber(data.skincolor) == 4 then
            torso = list_f["BODIES_UPPER"][11]
            legs = list_f["BODIES_LOWER"][11]
            texture_types["female"].albedo = GetHashKey("head_fr1_sc04_rough_c0_002_ab")
        elseif tonumber(data.skincolor) == 5 then
            torso = list_f["BODIES_UPPER"][8]
            legs = list_f["BODIES_LOWER"][8]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc01_c0_000_ab")
        elseif tonumber(data.skincolor) == 6 then
            torso = list_f["BODIES_UPPER"][30]
            legs = list_f["BODIES_LOWER"][30]
            texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc05_c0_000_ab")
        end

    end
    Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(torso), false, true, true)
    Wait(10)
    Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(legs), false, true, true)
    Wait(10)
	if not update then
		Wait(100)
	end
    Citizen.InvokeNative(0x704C908E9C405136, target)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, target, 0, 1, 1, 1, 0)
end

function LoadHair(target , data)
    if tonumber(data.hair) > 1 then
        if IsPedMale(target) then
            local hair =  list["hair"][tonumber(data.hair)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(hair), false, true, true)
        else
            local hair =  list_f["hair"][tonumber(data.hair)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(hair), false, true, true)
        end
    end
	if IsPedMale(target) then
		if tonumber(data.beard) > 1 then
			local beard = list["beard"][tonumber(data.beard)]
			Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,  tonumber(beard), false, true, true)
		end
	end
end

function LoadEyes(target , data)
    if IsPedMale(target) == 1 then
        local eyes = list["eyes"][tonumber(data.eyecolor)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(eyes), false, true, true)
    else
        local eyes = list_f["eyes"][tonumber(data.eyecolor)]
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(eyes), false, true, true)
    end
end


function LoadBodySize(target , data)
    if IsPedMale(target) == 1 then
        Citizen.InvokeNative(0x1902C4CFCC5BE57C, target, BODY_TYPES[tonumber(data.bodysize)])
    else
        Citizen.InvokeNative(0x1902C4CFCC5BE57C, target, BODY_TYPES[tonumber(data.bodysize)])
    end
end



function LoadFeatures(target , data , update)
    local feature
    for k,v in pairs(features_name) do
		if not update then
			Wait(5)
		end
        feature = features[k]
        if data[v] ~= nil then
            local value = data[v]/100
            Citizen.InvokeNative(0x5653AB26C82938CF, target, feature, value)
        end
    end
end

function LoadHeight(target , data)
    if data.height ~= nil then
	if IsPedMale(target) == 1 then
		SetPedScale(target, tonumber(data.height/100))
	else
		SetPedScale(target, tonumber(data.height/100))	
	end
    end
end


function FixIssues(target)
    Citizen.InvokeNative(0x77FF8D35EEC6BBC4,target,0,0)
    while not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, target) do
        Wait(0)
    end
    Citizen.InvokeNative(0x0BFA1BD465CDFEFD, target)
    if IsPedMale(target) then
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list["BODIES_UPPER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list["BODIES_LOWER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list["heads"][1]), false, true, true)
    else
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list_f["BODIES_UPPER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list_f["BODIES_LOWER"][1]), false, true, true)
        Citizen.InvokeNative(0xD3A7B003ED343FD9 , target,   tonumber(list_f["heads"][1]), false, true, true)
    end
    Citizen.InvokeNative(0xD710A5007C2AC539, target, 0x1D4C528A, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, target, 0x3F1F01E5, 0)
    Citizen.InvokeNative(0xD710A5007C2AC539, target, 0xDA0E2C55, 0)
    Citizen.InvokeNative(0x704C908E9C405136, target)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, target, 0, 1, 1, 1, 0)
end


function LoadOverlays(target , data)
    if tonumber(data.eyebrows_t) ~= nil then
        toggleOverlayChange("eyebrows",1,tonumber(data.eyebrows_t),0,0,0,1.0,0,tonumber(data.eyebrows_id),tonumber(data.eyebrows_c1),tonumber(data.eyebrows_c2),tonumber(data.eyebrows_c3),tonumber(0), tonumber(data.eyebrows_op/100) , target)
        Wait(50)
    end
    if tonumber(data.scars_t) ~= nil then
        toggleOverlayChange("scars",1,tonumber(data.scars_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.scars_op/100), target)
        Wait(50)
    end
    if tonumber(data.ageing_t) ~= nil then
        toggleOverlayChange("ageing",1,tonumber(data.ageing_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.ageing_op/100), target)
        Wait(50)
    end
    if tonumber(data.freckles_t) ~= nil then
        toggleOverlayChange("freckles",1,tonumber(data.freckles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.freckles_op/100), target)
        Wait(50)
    end
    if tonumber(data.moles_t) ~= nil then
        toggleOverlayChange("moles",1,tonumber(data.moles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.moles_op/100), target)
        Wait(50)
    end
    if tonumber(data.spots_t) ~= nil then
        toggleOverlayChange("spots",1,tonumber(data.spots_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.spots_op/100), target)
        Wait(50)
    end
    if tonumber(data.eyeliners_t) ~= nil then
        toggleOverlayChange("eyeliners",1,tonumber(1),0,0,0,1.0,0,tonumber(data.eyeliners_id),tonumber(data.eyeliners_c1),tonumber(data.eyeliners_c2),tonumber(data.eyeliners_c3), tonumber(data.eyeliners_t), tonumber(data.eyeliners_op/100) , target)
        Wait(50)
    end
    if tonumber(data.shadows_t) ~= nil then
        toggleOverlayChange("shadows",1,tonumber(1),0,0,0,1.0,0,tonumber(data.shadows_id),tonumber(data.shadows_c1),tonumber(data.shadows_c2),tonumber(data.shadows_c3), tonumber(data.shadows_t), tonumber(data.shadows_op/100) , target)
        Wait(50)
    end
    if tonumber(data.lipsticks_t) ~= nil then
        toggleOverlayChange("lipsticks",1,tonumber(1),0,0,0,1.0,0,tonumber(data.lipsticks_id),tonumber(data.lipsticks_c1),tonumber(data.lipsticks_c2),tonumber(data.lipsticks_c3), tonumber(data.lipsticks_t), tonumber(data.lipsticks_op/100) , target)
        Wait(50)
    end
    if tonumber(data.blush_t) ~= nil then
        toggleOverlayChange("blush",1,tonumber(data.blush_t),0,0,0,1.0,0,tonumber(data.blush_id),tonumber(data.blush_c1),tonumber(data.blush_c2),tonumber(data.blush_c3),tonumber(0), tonumber(data.blush_op/100) , target)

    end
end

function HasBodyComponentsLoaded (target , hair , beard)
    local _target = target
    local output = true
    if
        not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0x378AD10C)) or
        not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0xEA24B45E)) or
        not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0x823687F5)) or
        not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0xB3966C9)) then
        output = false
    end
    if hair and not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0x864B03AE))  then
        output = false
    end

    if beard and not Citizen.InvokeNative(0xFB4891BD7578CDC1 ,_target, tonumber(0xF8016BCA))  then
        output = false
    end
    if not Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, _target) then
        output = false
    end
    return output
end

function GetTorso()
	return torso
end


function GetLegs()
	return legs
end

function GetComponentId(name)
	return components_data["beard"]
end

function GetBodyComponents()
	return {list , list_f}
end


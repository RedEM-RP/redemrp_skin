local isSkinCreatorOpened = false
local adding = true
local adding2 = true
local sex = 1
local maleheads = {}
local maletorsos = {}
local malelegs = {}
local maleeyes = {}
local malehairs = {}
local mustache = {}
local femaleheads = {}
local femaletorsos = {}
local femalelegs = {}
local femaleeyes = {}
local femalehairs = {}
local eye
local skin
local plec
local face
local size
local faces
local hair
local beard
local overlay_ped = PlayerPedId()

local textureId = -1
local overlay_opacity = 1.0


function toggleOverlayChange(name,visibility,tx_id,tx_normal,tx_material,tx_color_type,tx_opacity,tx_unk,palette_id,palette_color_primary,palette_color_secondary,palette_color_tertiary,var,opacity, targets)
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
	 overlay_ped = targets
    is_overlay_change_active = true  
end


function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end


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
end)

function ShowSkinCreator(enable)
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        openSkinCreator = enable
    })
end


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
            elseif v.category == "mustache" then
                table.insert(mustache, v.Hash)
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
                table.insert(femaleheads, v.Hash)
            elseif v.category == "torsos" then
                table.insert(femaletorsos, v.Hash)
            elseif v.category == "legs" then
                table.insert(femalelegs, v.Hash)
            elseif v.category == "eyes" then
                table.insert(femaleeyes, v.Hash)
            elseif v.category == "hair" then
                table.insert(femalehairs, v.Hash)
            else end
        end
        adding2 = false
    end
end)



RegisterCommand("loadskin", function(source, args, rawCommand)
    TriggerServerEvent("redemrp_skin:loadSkin", function(cb)
        end)
end)


RegisterNUICallback('saveSkin', function(data, cb)
    SetNuiFocus(false, false)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    DisplayHud(true)
    DisplayRadar(true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    TriggerServerEvent("redemrp_skin:createSkin", data, function(cb)
        if cb then
            print("DONE")
        else
            print("ERROR")
        end
    end)
    DestroyAllCams()
    isSkinCreatorOpened = false
    ShowSkinCreator(false)
end)


RegisterNetEvent('redemrp_skin:applySkin')
AddEventHandler('redemrp_skin:applySkin', function(_data, target , clothes)
    Citizen.CreateThread(function()
        local _target
        local _clothes = clothes
        local _t = target
        local test = false
        local data = _data
        local model = "mp_male"
        local player = PlayerId()

        if target == nil then
            if tonumber(data.sex) == 1 then
                model = "mp_male"
            elseif tonumber(data.sex) == 2 then
                model = "mp_female"
            end

            local model2 = GetHashKey(model)
            while not HasModelLoaded( model2 ) do
                Wait(500)
                modelrequest( model2 )
            end
            Citizen.InvokeNative(0xED40380076A31506, PlayerId(), model2)
            Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
            SetEntityAlpha(PlayerPedId(), 0)
        end

        if _t ~= nil then
            _target = _t
            SetEntityAlpha(_target, 0)
        else
            _target = PlayerPedId()
        end

	Citizen.InvokeNative(0xD710A5007C2AC539, _target, 0x1D4C528A, 0)
	Citizen.InvokeNative(0x704C908E9C405136, _target)
	Citizen.InvokeNative(0xAAB86462966168CE, _target, 1)
	Citizen.InvokeNative(0xCC8CA3E88256E58F, _target, 0, 1, 1, 1, 0) 
        while test == false do
            Wait(2000)
            local torso = '0x' .. maletorsos[1]
            local legs = '0x' .. malelegs[1]
            local head = '0x' .. maleheads[1]
            if tonumber(data.sex) == 1 then
                if tonumber(data.skincolor) == 1 then
                    torso = '0x' .. maletorsos[1]
                    legs = '0x' .. malelegs[1]
                    head = '0x' .. maleheads[1]
                    texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
                elseif tonumber(data.skincolor) == 2 then
                    torso = '0x' .. maletorsos[10]
                    legs = '0x' .. malelegs[10]
                    head = '0x' .. maleheads[10]
                    texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc03_c0_000_ab")
                elseif tonumber(data.skincolor) == 3 then
                    torso = '0x' .. maletorsos[3]
                    legs = '0x' .. malelegs[3]
                    head = '0x' .. maleheads[3]
                    texture_types["male"].albedo = GetHashKey("head_mr1_sc02_rough_c0_002_ab")
                elseif tonumber(data.skincolor) == 4 then
                    torso = '0x' .. maletorsos[11]
                    legs = '0x' .. malelegs[11]
                    head = '0x' .. maleheads[11]
                    texture_types["male"].albedo = GetHashKey("head_mr1_sc04_rough_c0_002_ab")
                elseif tonumber(data.skincolor) == 5 then
                    torso = '0x' .. maletorsos[8]
                    legs = '0x' .. malelegs[8]
                    head = '0x' .. maleheads[8]
                    texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc01_c0_000_ab")
                elseif tonumber(data.skincolor) == 6 then
                    torso = '0x' .. maletorsos[30]
                    legs = '0x' .. malelegs[30]
                    head = '0x' .. maleheads[30]
                    texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc05_c0_000_ab")
                else end

                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(torso), false, true, true)
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(legs), false, true, true)
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(head), false, true, true)


            else

                local torso2 = '0x' .. femaletorsos[1]
                local legs2 = '0x' .. femalelegs[1]
                local head2 = '0x' .. femalelegs[1]
                if tonumber(data.skincolor) == 1 then
                    torso2 = '0x' .. femaletorsos[1]
                    legs2 = '0x' .. femalelegs[1]
                    head2 = '0x' .. femaleheads[1]
                    texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
                elseif tonumber(data.skincolor) == 2 then
                    torso2 = '0x' .. femaletorsos[10]
                    legs2 = '0x' .. femalelegs[10]
                    head2 = '0x' .. femaleheads[10]
                    texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
                elseif tonumber(data.skincolor) == 3 then
                    torso2 = '0x' .. femaletorsos[3]
                    legs2 = '0x' .. femalelegs[3]
                    head2 = '0x' .. femaleheads[3]
                    texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
                elseif tonumber(data.skincolor) == 4 then
                    torso2 = '0x' .. femaletorsos[11]
                    legs2 = '0x' .. femalelegs[11]
                    head2 = '0x' .. femaleheads[11]
                    texture_types["female"].albedo = GetHashKey("head_fr1_sc04_rough_c0_002_ab")
                elseif tonumber(data.skincolor) == 5 then
                    torso2 = '0x' .. femaletorsos[8]
                    legs2 = '0x' .. femalelegs[8]
                    head2 = '0x' .. femaleheads[8]
                    texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc01_c0_000_ab")
                elseif tonumber(data.skincolor) == 6 then
                    torso2 = '0x' .. femaletorsos[30]
                    legs2 = '0x' .. femalelegs[30]
                    head2 = '0x' .. femaleheads[30]
                    texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc05_c0_000_ab")
                else end
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(torso2), false, true, true)
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(legs2), false, true, true)
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(head2), false, true, true)

            end

            local twarz = '0x' .. maleheads[tonumber(data.face)]
            local twarz2 = '0x' .. femaleheads[tonumber(data.face)]
            if tonumber(data.sex) == 1 then

                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(twarz), false, true, true)

            else
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(twarz2), false, true, true)
            end


            if tonumber(data.hair) > 1 then
                if tonumber(data.sex) == 1 then
                    local wlosy = '0x' .. malehairs[tonumber(data.hair)]
                    Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(wlosy), false, true, true)

                else
                    local wlosy2 = '0x' .. femalehairs[tonumber(data.hair)]
                    Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(wlosy2), false, true, true)
                end
            end



            if tonumber(data.sex) == 1 then
                if tonumber(data.beard) > 1 then
                    local broda = '0x' .. mustache[tonumber(data.beard)]
                    Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,  tonumber(broda), false, true, true)

                end
            end


            if tonumber(data.eyecolor) == 5 then
                data.eyecolor = 2
            end



            if tonumber(data.sex) == 1 then
                local oczy = '0x' .. maleeyes[tonumber(data.eyecolor)]
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(oczy), false, true, true)
            else
                local oczy2 = '0x' .. femaleeyes[tonumber(data.eyecolor)]
                Citizen.InvokeNative(0xD3A7B003ED343FD9 , _target,   tonumber(oczy2), false, true, true)
            end


            local BODY_TYPES = {
                32611963,
                -20262001,
                -369348190,
                -1241887289,
                61606861,
            }
            if tonumber(data.sex) == 1 then
                Citizen.InvokeNative(0x1902C4CFCC5BE57C, _target, BODY_TYPES[tonumber(data.bodysize)]);
            else
                Citizen.InvokeNative(0x1902C4CFCC5BE57C, _target, BODY_TYPES[tonumber(data.bodysize)]);
            end


            local feature
            local features = {
                0x84D6,0x3303,0x2FF9,0x4AD1 ,0xC04F,0xB6CE,0x2844,0xED30,0x6A0B,0xABCF,0x358D,
                0x8D0A,0xEBAE ,0x1DF6,0x3C0F,0xC3B2,0xE323,0x8B2B ,0x1B6B ,0xEE44 ,0xD266 ,0xA54E ,0x6E7F ,0x3471,0x03F5,
                0x34B1,0xF156,0x561E ,0xF065,0xAA69,0x7AC3,0x1A00,0x91C1,0xC375,0xBB4D,0xB0B0,0x5D16,
            }

            local name = {
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
                "nose_width",
                "nose_size",
                "nose_height",
                "nose_angle",
                "nose_curvature",
                "nostrils_distance",
                "mouth_width",
                "mouth_depth",
                "mouth_x_pos",
                "mouth_y_pos",
                "upper_lip_height",
                "upper_lip_width",
                "upper_lip_depth",
                "lower_lip_height",
                "lower_lip_width",
                "lower_lip_depth",
            }

            for k,v in pairs(name) do
                feature = features[k]
                local value = data[v]/100
                Citizen.InvokeNative(0x5653AB26C82938CF, _target, feature, value)
            end
			
			Citizen.InvokeNative(0x704C908E9C405136, _target)
            Citizen.InvokeNative(0xAAB86462966168CE, _target, 1)
            Citizen.InvokeNative(0xCC8CA3E88256E58F, _target, 0, 1, 1, 1, 0) -- Actually remove the component
			
            if 	tonumber(data.eyebrows_t)  ~= nil then
                local visibility = 0
                toggleOverlayChange("eyebrows",1,tonumber(data.eyebrows_t),0,0,0,1.0,0,tonumber(data.eyebrows_id),tonumber(data.eyebrows_c1),tonumber(data.eyebrows_c2),tonumber(data.eyebrows_c3),tonumber(0), tonumber(data.eyebrows_op/100) , _target)
                visibility = 0
                if tonumber(data.scars_t) >0 then
                    visibility = 1
                end
                toggleOverlayChange("scars",visibility,tonumber(data.scars_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.scars_op/100), _target)
                visibility = 0
                if tonumber(data.ageing_t) >0 then
                    visibility = 1
                end
                toggleOverlayChange("ageing",visibility,tonumber(data.ageing_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.ageing_op/100), _target)

                visibility = 0
                if tonumber(data.freckles_t) >0 then
                    visibility = 1
                end
                toggleOverlayChange("freckles",visibility,tonumber(data.freckles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.freckles_op/100), _target)

                visibility = 0
                if tonumber(data.moles_t) >0 then
                    visibility = 1
                end
                toggleOverlayChange("moles",visibility,tonumber(data.moles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.moles_op/100), _target)

                visibility = 0
                if tonumber(data.spots_t) >0 then
                    visibility = 1
                end
                toggleOverlayChange("spots",visibility,tonumber(data.spots_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.spots_op/100), _target)


            end

            Citizen.InvokeNative(0x704C908E9C405136, _target)
            Citizen.InvokeNative(0xAAB86462966168CE, _target, 1)
            Citizen.InvokeNative(0xCC8CA3E88256E58F, _target, 0, 1, 1, 1, 0) -- Actually remove the component
            Wait(500)
            test = Citizen.InvokeNative(0xA0BC8FAED8CFEB3C, _target)

        end
        if _t == nil then
            Wait(500)
            TriggerServerEvent("redemrp_clothing:loadClothes", 1, function(cb)
                end)
        else
            Wait(500)
            TriggerEvent("redemrp_clothing:load", data, _clothes, _target)
        end
    end)
end)

RegisterNUICallback('updateBody', function(data, cb)
    TriggerEvent("redemrp_skin:updateBody" , data)
end)

RegisterNetEvent('redemrp_skin:updateBody')
AddEventHandler('redemrp_skin:updateBody', function(data)
    if plec ~= tonumber(data.sex) and  data.sex ~= nil then
        plec = tonumber(data.sex)
        camera(2.8,-0.15)
        local model = "mp_male"
        local player = PlayerId()
        if plec == 1 then
            model = "mp_male"
            sex = 1
        elseif plec == 2 then
            model = "mp_female"
            sex = 2
        end
        local model2 = GetHashKey(model)
        while not HasModelLoaded( model2 ) do
            Wait(500)
            modelrequest( model2 )
        end
        Citizen.InvokeNative(0xED40380076A31506, PlayerId(), model2)
        Citizen.InvokeNative(0x283978A15512B2FE,PlayerPedId(),true)
        if sex == 2 then
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x10F5497A,false,true,true) -- PANTS
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),0x14511493,false,true,true) -- COAT
        end
    end


    if skin ~= data.skincolor then
        skin = data.skincolor
        camera(2.8,-0.15)
        local torso = '0x' .. maletorsos[1]
        local legs = '0x' .. malelegs[1]
        local head = '0x' .. maleheads[1]
		texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
        if tonumber(data.sex) == 1 then
            print("test skory")
            if tonumber(data.skincolor) == 1 then
                torso = '0x' .. maletorsos[1]
                legs = '0x' .. malelegs[1]
                head = '0x' .. maleheads[1]
                texture_types["male"].albedo = GetHashKey("mp_head_mr1_sc08_c0_000_ab")
            elseif tonumber(data.skincolor) == 2 then
                torso = '0x' .. maletorsos[10]
                legs = '0x' .. malelegs[10]
                head = '0x' .. maleheads[10]
                texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc03_c0_000_ab")
            elseif tonumber(data.skincolor) == 3 then
                torso = '0x' .. maletorsos[3]
                legs = '0x' .. malelegs[3]
                head = '0x' .. maleheads[3]
                texture_types["male"].albedo = GetHashKey("head_mr1_sc02_rough_c0_002_ab")
            elseif tonumber(data.skincolor) == 4 then
                torso = '0x' .. maletorsos[11]
                legs = '0x' .. malelegs[11]
                head = '0x' .. maleheads[11]
                texture_types["male"].albedo = GetHashKey("head_mr1_sc04_rough_c0_002_ab")
            elseif tonumber(data.skincolor) == 5 then
                torso = '0x' .. maletorsos[8]
                legs = '0x' .. malelegs[8]
                head = '0x' .. maleheads[8]
                texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc01_c0_000_ab")
            elseif tonumber(data.skincolor) == 6 then
                torso = '0x' .. maletorsos[30]
                legs = '0x' .. malelegs[30]
                head = '0x' .. maleheads[30]
                texture_types["male"].albedo = GetHashKey("MP_head_mr1_sc05_c0_000_ab")
            else end

            Citizen.InvokeNative(0xD3A7B003ED343FD9 , PlayerPedId(),   tonumber(torso), false, true, true)
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , PlayerPedId(),   tonumber(legs), false, true, true)
            Citizen.InvokeNative(0xD3A7B003ED343FD9 , PlayerPedId(),   tonumber(head), false, true, true)


        else

            local torso2 = '0x' .. femaletorsos[1]
            local legs2 = '0x' .. femalelegs[1]
            local head2 = '0x' .. femalelegs[1]
			texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
            if tonumber(data.skincolor) == 1 then
                torso2 = '0x' .. femaletorsos[1]
                legs2 = '0x' .. femalelegs[1]
                head2 = '0x' .. femaleheads[1]
                texture_types["female"].albedo = GetHashKey("mp_head_fr1_sc08_c0_000_ab")
            elseif tonumber(data.skincolor) == 2 then
                torso2 = '0x' .. femaletorsos[10]
                legs2 = '0x' .. femalelegs[10]
                head2 = '0x' .. femaleheads[10]
                texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
            elseif tonumber(data.skincolor) == 3 then
                torso2 = '0x' .. femaletorsos[3]
                legs2 = '0x' .. femalelegs[3]
                head2 = '0x' .. femaleheads[3]
                texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc03_c0_000_ab")
            elseif tonumber(data.skincolor) == 4 then
                torso2 = '0x' .. femaletorsos[11]
                legs2 = '0x' .. femalelegs[11]
                head2 = '0x' .. femaleheads[11]
                texture_types["female"].albedo = GetHashKey("head_fr1_sc02_rough_c0_002_ab")
            elseif tonumber(data.skincolor) == 5 then
                torso2 = '0x' .. femaletorsos[8]
                legs2 = '0x' .. femalelegs[8]
                head2 = '0x' .. femaleheads[8]
                texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc01_c0_000_ab")
            elseif tonumber(data.skincolor) == 6 then
                torso2 = '0x' .. femaletorsos[30]
                legs2 = '0x' .. femalelegs[30]
                head2 = '0x' .. femaleheads[30]
                texture_types["female"].albedo = GetHashKey("MP_head_fr1_sc05_c0_000_ab")
            else end

            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(torso2),false,true,true)
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(legs2),false,true,true)
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(head2),false,true,true)
        end
    end
    if eye ~= data.eyecolor then
        eye = data.eyecolor
        camera(0.9,0.6)
        if sex == 1 then
            local oczy = '0x' .. maleeyes[tonumber(eye)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy),false,true,true)
        else
            local oczy2 = '0x' .. femaleeyes[tonumber(eye)]
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(oczy2),false,true,true)
        end
    end

    if face ~= data.face then
        face = data.face
        camera(0.9,0.6)
        local twarz = '0x' .. maleheads[tonumber(face)]
        local twarz2 = '0x' .. femaleheads[tonumber(face)]
        if sex == 1 then
            --print (face)
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz),false,true,true)
        else
            --print (face)
            Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(twarz2),false,true,true)
        end
    end
    if size ~= data.bodysize then
        size = data.bodysize
        print(size)
        camera(2.8,-0.15)
        local BODY_TYPES = {
            32611963,
            -20262001,
            -369348190,
            -1241887289,
            61606861,
        }

        Citizen.InvokeNative(0x1902C4CFCC5BE57C, PlayerPedId(), BODY_TYPES[tonumber(data.bodysize)]);

    end

    if hair ~= data.hair then
        hair = data.hair
        camera(0.9,0.6)
        if tonumber(hair) > 1 then
            if sex == 1 then
                local wlosy = '0x' .. malehairs[tonumber(hair)]
                Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy),false,true,true)
            else
                local wlosy2 = '0x' .. femalehairs[tonumber(hair)]
                Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(wlosy2),false,true,true)
            end
        else
            Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0x864B03AE, 0) -- Set target category, here the hash is for hats
            Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), 0, 1, 1, 1, 0)
        end
    end
    if beard ~= data.beard then
        beard = data.beard
        camera(0.9,0.6)
        if tonumber(beard) > 1 then
            if sex == 1 then
                local broda = '0x' .. mustache[tonumber(beard)]
                Citizen.InvokeNative(0xD3A7B003ED343FD9, PlayerPedId(),tonumber(broda),false,true,true)
            end
        else
            Citizen.InvokeNative(0xD710A5007C2AC539, PlayerPedId(), 0xF8016BCA, 0) -- Set target category, here the hash is for hats
            Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), 0, 1, 1, 1, 0)
        end
    end


    local feature
    local features = {
        0x84D6,0x3303,0x2FF9,0x4AD1 ,0xC04F,0xB6CE,0x2844,0xED30,0x6A0B,0xABCF,0x358D,
        0x8D0A,0xEBAE ,0x1DF6,0x3C0F,0xC3B2,0xE323,0x8B2B ,0x1B6B ,0xEE44 ,0xD266 ,0xA54E ,0x6E7F ,0x3471,0x03F5,
        0x34B1,0xF156,0x561E ,0xF065,0xAA69,0x7AC3,0x1A00,0x91C1,0xC375,0xBB4D,0xB0B0,0x5D16,
    }

    local name = {
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
        "nose_width",
        "nose_size",
        "nose_height",
        "nose_angle",
        "nose_curvature",
        "nostrils_distance",
        "mouth_width",
        "mouth_depth",
        "mouth_x_pos",
        "mouth_y_pos",
        "upper_lip_height",
        "upper_lip_width",
        "upper_lip_depth",
        "lower_lip_height",
        "lower_lip_width",
        "lower_lip_depth",
    }

    for k,v in pairs(name) do
        feature = features[k]
        local value = data[v]/100
        Citizen.InvokeNative(0x5653AB26C82938CF, PlayerPedId(), feature, value)
    end

    Citizen.InvokeNative(0x704C908E9C405136, PlayerPedId())
    Citizen.InvokeNative(0xAAB86462966168CE, PlayerPedId(), 1)
    Citizen.InvokeNative(0xCC8CA3E88256E58F, PlayerPedId(), 0, 1, 1, 1, 0)


    local visibility = 0
    if tonumber(data.eyebrows_t) > 0 then
        visibility = 1
    end
    toggleOverlayChange("eyebrows",visibility,tonumber(data.eyebrows_t),0,0,0,1.0,0,tonumber(data.eyebrows_id),0,0,0,tonumber(0), tonumber(data.eyebrows_op/100) , PlayerPedId())
    visibility = 0
    if tonumber(data.scars_t) >0 then
        visibility = 1
    end
    toggleOverlayChange("scars",visibility,tonumber(data.scars_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.scars_op/100), PlayerPedId())
    visibility = 0
    if tonumber(data.ageing_t) >0 then
        visibility = 1
    end
    toggleOverlayChange("ageing",visibility,tonumber(data.ageing_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.ageing_op/100), PlayerPedId())
    visibility = 0
    if tonumber(data.freckles_t) >0 then
        visibility = 1
    end
    toggleOverlayChange("freckles",visibility,tonumber(data.freckles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.freckles_op/100), PlayerPedId())

    visibility = 0
    if tonumber(data.moles_t) >0 then
        visibility = 1
    end
    toggleOverlayChange("moles",visibility,tonumber(data.moles_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.moles_op/100), PlayerPedId())

    visibility = 0
    if tonumber(data.spots_t) >0 then
        visibility = 1
    end
    toggleOverlayChange("spots",visibility,tonumber(data.spots_t),0,0,1,1.0,0,tonumber(0),0,0,0,tonumber(0), tonumber(data.spots_op/100), PlayerPedId())


end)



local headingss = 274.00
RegisterNUICallback('heading', function(data)
    local playerPed = PlayerPedId()
    headingss = headingss + data.value
    SetEntityHeading(playerPed, headingss)
end)

function destory()
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    DisplayHud(true)
    DisplayRadar(true)
    DestroyAllCams(true)
end

function camera(zoom, offset)
    DestroyAllCams(true)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local heading = 0.0
    local zoomOffset = zoom
    local camOffset = offset
    local angle = heading * math.pi / 180.0
    local theta = {
        x = math.cos(angle),
        y = math.sin(angle)
    }
    print(theta.x)
    local pos = {
        x = coords.x + (zoomOffset * theta.x),
        y = coords.y + (zoomOffset * theta.y)
    }
    print(pos.x)
    local angleToLook = heading - 140.0
    if angleToLook > 360 then
        angleToLook = angleToLook - 360
    elseif angleToLook < 0 then
        angleToLook = angleToLook + 360
    end
    print(angleToLook)
    angleToLook = angleToLook * math.pi / 180.0
    local thetaToLook = {
        x = math.cos(angleToLook),
        y = math.sin(angleToLook)
    }
    print(thetaToLook.x)
    local posToLook = {
        x = coords.x + (zoomOffset * thetaToLook.x),
        y = coords.y + (zoomOffset * thetaToLook.y)
    }
    print(posToLook.x)
    local add = 2.0
    if zoom == 0.9 then
        add = 0.5
    else
        add = 3.0
    end
    SetEntityHeading(playerPed, 250.00)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, coords.z + camOffset, 300.00,0.00,0.00, 40.00, false, 0)
    PointCamAtCoord(cam, posToLook.x, posToLook.y+add, coords.z + camOffset)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    DisplayHud(false)
    DisplayRadar(false)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if is_overlay_change_active then  
            local ped = overlay_ped
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
            Citizen.Wait(100)
            Citizen.InvokeNative(0x0B46E25761519058,ped,`heads`,textureId)  -- apply texture to current component in category "heads"
            Citizen.InvokeNative(0x92DAABA2C1C10B0E,textureId)      -- update texture
            Citizen.InvokeNative(0xCC8CA3E88256E58F,ped, 0, 1, 1, 1, false);  -- refresh ped components
            is_overlay_change_active = false
        end
    end
end)


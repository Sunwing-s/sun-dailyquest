local QBCore = exports['qb-core']:GetCoreObject()
local done = false
local step1 = false
local step2 = false
local step3 = false
local spawnLocations = 
{
    [1] = {x = 1282.0815, y = 4618.1147, z = 29.9538, h = 100.1},
    [2] = {x = -153.7, y = 4509.78, z = 14.81, h = 60.1},
    [3] = {x = 563.0507, y = 4201.1787, z = 7.9577, h = 80.1},
    [4] = {x = -1541.5424, y = 3669.3003, z = 4.6053, h = 10.1},
    [5] = {x = -1207.1727, y = 5322.7959, z = 22.9434, h = 37.5}
}

local quests =
{
    [1] = {name = "Boachgate Avlämnande", msg = "Nu så ska du göra en tjänst till mig, åk till Boachgate exakt postkod 300 och lämna detta paket till mig. Husets detaljer står på paketet, kom tillbaka hit efter, tack!", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando så tror jag han vill prata klart med dig.", msg3 = "Tack för hjälpen att leverera det paketet!", item = "dailybox1", x = 1433.79, y = 3302.78, z = 9.02, ttext = "Lämna Paketet"},
    [2] = {name = "Berchem Hjälpande", msg = "Jag behöver verkligen din hjälp, min farbror har tappat staven och skulle behöva en ny, kan du snälla ge denna till han? Jag betalar!", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och berräta om hur glad jag blev!", msg3 = "Tack så mycket för hjälpen!", item = "dailybox2", x = -1422.7155, y = 4837.2886, z = 25.4422, ttext = "Lämna Staven"}, 
    [3] = {name = "Flygplats Räddningen", msg = "Jag har verkligen misslyckats, jag skulle lämna av en av mina kompisars väskor idag vid flygplatsen men glömde helt bort, kan du göra det?", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och säg att du räddade hans skuld!", msg3 = "Tack, du räddade mig verkligen!", item = "dailybox3", x = 2434.3086, y = 4532.1084, z = 6.0814, ttext = "Lämna Väskan"},
    [4] = {name = "Sallads Sprinten", msg = "Min polare bad mig ta med sallad ner till little italy till hans nya pizzeria, men jag har inte tid. Kan du?", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och säg att du räddade hans skuld!", msg3 = "Tack, du räddade mig verkligen!", item = "dailybox4", x = -89.6355, y = 3847.5354, z = 13.0511, ttext = "Lämna Salladen"}, 
    [5] = {name = "Krångligt Problem", msg = "Min polare sitter fast på taket i lägenhetshuset mellan Vauxite St och Exeter Ave. Kan du ta denna saxen och klippa loss honom?", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och säg att du räddade mig!", msg3 = "Tack, du räddade mig verkligen!", item = "dailybox5", x = -237.0664, y = 5381.9189, z = 44.8673, ttext = "Använd Saxen"}, 
}

function getRandom(variable)
    return variable[math.random(1, #variable)]
end

local coords = getRandom(spawnLocations)
local quests = getRandom(quests)

blip = AddBlipForCoord(coords.x, coords.y, coords.z) -- Blip ADD_BLIP_FOR_COORD(float x, float y, float z);
SetBlipScale(blip, 0.6) -- void SET_BLIP_SCALE(Blip blip, float scale);
SetBlipSprite(blip, 126) -- void SET_BLIP_SPRITE(Blip blip, int spriteId);
SetBlipColour(blip, 32) -- void SET_BLIP_COLOUR(Blip blip, int color);
SetBlipAlpha(blip, 255) -- void SET_BLIP_ALPHA(Blip blip, int alpha [0-255]);
AddTextEntry("PIER", "Fernandos Äventyr")
BeginTextCommandSetBlipName("PIER") -- void BEGIN_TEXT_COMMAND_SET_BLIP_NAME(char* textLabel);
EndTextCommandSetBlipName(blip) -- void END_TEXT_COMMAND_SET_BLIP_NAME(Blip blip);

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
		if not DoesEntityExist(dealer) then
		    RequestModel("s_m_y_dealer_01")
		    while not HasModelLoaded("s_m_y_dealer_01") do
		        Wait(10)
		    end
		    dealer = CreatePed(26, "s_m_y_dealer_01", coords.x, coords.y, coords.z, 80.9422, false, false)
		    SetEntityHeading(dealer, coords.h)
		    SetBlockingOfNonTemporaryEvents(dealer, true)
		    TaskStartScenarioInPlace(dealer, "WORLD_HUMAN_AA_SMOKE", 0, false)
            exports['qb-target']:AddTargetModel('s_m_y_dealer_01', {
                options = {
                    {
                        type = "client",
                        event = "sun:dailymenu",
                        icon = "fas fa-money-check",
                        label = "Prata med Fernando",
                        job = "all",
                    },
                },
                distance = 3.0 
            })
		end
	end
end)


RegisterNetEvent("sun:dailymenu", function()
    if step1 then
        exports['qb-menu']:openMenu({
            {
                header = 'Fernando',
                icon = 'fas fa-fingerprint',
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = 'Dagens Äventyr: ' .. quests.name .. '!',
                txt = 'Det låter kul!',
                icon = 'fas fa-archive',
                params = {
                    event = 'sun:dailyquests',
                    args = {
		        message = 'Dagliga Quests'
                    }
                }
            },  
            {
                header = 'Avsluta Quest: ' .. quests.name .. '!',
                txt = 'Tack för att du gjorde det!',
                icon = 'fas fa-archive',
                params = {
                    event = 'sun:dailyquests2',
                    args = {
		        message = 'Dagliga Quests'
                    }
                }
            },
        })
    else
        exports['qb-menu']:openMenu({
            {
                header = 'Fernando',
                icon = 'fas fa-fingerprint',
                isMenuHeader = true, -- Set to true to make a nonclickable title
            },
            {
                header = 'Dagens Äventyr: ' .. quests.name .. '!',
                txt = 'Det låter kul!',
                icon = 'fas fa-archive',
                params = {
                    event = 'sun:dailyquests',
                    args = {
		        message = 'Dagliga Quests'
                    }
                }
            },  
        })
    end
end)

RegisterNetEvent("sun:dailyquests", function()
    if done then
        QBCore.Functions.Notify("Du har redan pratat med mig idag", "error")
    else  
        QBCore.Functions.Notify(quests.msg, "success")
        --TriggerServerEvent("sun:questsitem", quests.item)
        TriggerServerEvent('QBCore:Server:AddItem', quests.item, 1)
        done = true
        if not DoesEntityExist(quest) then
		    RequestModel("a_m_m_trampbeac_01")
		    while not HasModelLoaded("a_m_m_trampbeac_01") do
		        Wait(10)
		    end
		    quest = CreatePed(26, "a_m_m_trampbeac_01", quests.x, quests.y, quests.z, 80.9422, false, false)
		    SetEntityHeading(quest, 87.8)
		    SetBlockingOfNonTemporaryEvents(quest, true)
		    TaskStartScenarioInPlace(quest, "WORLD_HUMAN_AA_SMOKE", 0, false)
            exports['qb-target']:AddTargetModel('a_m_m_trampbeac_01', {
                options = {
                    {
                        type = "client",
                        event = "sun:dailyquests1",
                        icon = "fas fa-money-check",
                        label = "Uppdrag: "..quests.ttext.."!",
                        job = "all",
                    },
                },
                distance = 3.0 
            })
		end
    end
end)

RegisterNetEvent("sun:dailyquests1", function()
    if step2 then
        QBCore.Functions.Notify("Jag vet inte om du kan hjälpa mig", "success")
    else
        step1 = true
        --TriggerServerEvent("sun:questsremoveitem", quests.item)
        TriggerServerEvent('QBCore:Server:RemoveItem', quests.item, 1)
        QBCore.Functions.Notify(quests.msg2, "success")
        --QBCore.Functions.Notify("Här får du en slant!", "success")
    end
end)

RegisterNetEvent("sun:dailyquests2", function()
    if step3 == false then
        local reward = math.random(500, 2500)
        done = true
        step1 = false
        step2 = true
        step3 = true
        TriggerServerEvent("sun:daily:givemoney", reward)
        QBCore.Functions.Notify(quests.msg3, "success")
        QBCore.Functions.Notify("Du fick: ".. reward .. " i kontant!", "success")
    else
        QBCore.Functions.Notify("Du har redan avslutat denna questm, vänta ett tag tills nästa", "success")
end)
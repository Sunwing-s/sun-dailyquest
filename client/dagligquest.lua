local QBCore = exports['qb-core']:GetCoreObject()
local done = false
local step1 = false
local step2 = false
local spawnLocations = 
{
    [1] = {x = -342.4532, y = 212.2995, z = 86.5769, h = 343.6060},
    [2] = {x = -768.9590, y = -355.9228, z = 37.3333, h = 342.7794},
    [3] = {x = -319.4562, y = -610.2422, z = 33.5582, h = 237.9600},
}

local quests =
{
    [1] = {name = "Mirror Park Avlämnande", msg = "Nu så ska du göra en tjänst till mig, åk till utsidan av mirror park och lämna detta paket till mig. Husets detaljer står på paketet, kom tillbaka hit efter, tack!", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando så tror jag han vill prata klart med dig.", msg3 = "Tack för hjälpen att leverera det paketet!", item = "dailybox1", x = 1264.6433, y = -703.0041, z = 64.9091, ttext = "Lämna Paketet"},
    [2] = {name = "Hjälp på Piren", msg = "Jag behöver verkligen din hjälp, min farbror har tappat staven och skulle behöva en ny, kan du snälla ge denna till han? Jag betalar!", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och berräta om hur glad jag blev!", msg3 = "Tack så mycket för hjälpen!", item = "dailybox2", x = -1696.0883, y = -1120.6464, z = 13.1523, ttext = "Lämna Staven"}, 
    [3] = {name = "Flygplats Räddningen", msg = "Jag har verkligen misslyckats, jag skulle lämna av en av mina kompisars väskor idag vid flygplatsen men glömde helt bort, kan du göra det?", msg2 = "Tack så mycket! Gå nu tillbaka till Fernando och säg att du räddade hans skuld!", msg3 = "Tack, du räddade mig verkligen!", item = "dailybox3", x = -1037.0527,  y = -2750.2988, z = 21.3593, ttext = "Lämna Väskan"},
}

function getRandom(variable)
    return variable[math.random(1, #variable)]
end

local coords = getRandom(spawnLocations)
local quests = getRandom(quests)
print(coords.x, coords.y, coords.z)
print("Sun-Dailyquest // S16 Development")

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
        if done then
            QBCore.Functions.Notify("Du har redan hjälpt mig", "error")
        else
            exports['qb-menu']:openMenu({
                {
                    header = 'Fernando',
                    icon = 'fas fa-fingerprint',
                    isMenuHeader = true, -- Set to true to make a nonclickable title
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
        end
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
    if step2 then
        QBCore.Functions.Notify("Du har redan pratat med mig idag", "error")
    else  
        QBCore.Functions.Notify(quests.msg, "success")
        --TriggerServerEvent("sun:questsitem", quests.item)
        TriggerServerEvent('sun:daily:giveitem', quests.item)
        --done = true
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
        QBCore.Functions.Notify("Jag vet inte om du kan hjälpa mig", "error")
    else
        step1 = true
        step2 = true
        --TriggerServerEvent("sun:questsremoveitem", quests.item)
        TriggerServerEvent('sun:daily:removeitem', quests.item)
        QBCore.Functions.Notify(quests.msg2, "success")
        --QBCore.Functions.Notify("Här får du en slant!", "success")
    end
end)

RegisterNetEvent("sun:dailyquests2", function()
    if done == false then
        local reward = math.random(500, 2500)
        done = true
        step2 = true
        TriggerServerEvent("sun:daily:givemoney", reward)
        QBCore.Functions.Notify(quests.msg3, "success")
        QBCore.Functions.Notify("Du fick: ".. reward .. " i kontant!", "success")
    else
        QBCore.Functions.Notify("Du har redan avslutat denna quest, vänta ett tag tills nästa", "success")
    end
end)
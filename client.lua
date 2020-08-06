ESX                             = nil
local radar = false
local GpsVeri = {}
local selam = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		TriggerEvent('u4gps:bakbakam')
	end
end)






RegisterNetEvent('u4gps:gpskullanAQ')
AddEventHandler('u4gps:gpskullanAQ', function()

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gpssifre',
				{
					title = "GPS Şifrenizi Belirleyin (Sayı Olabilir)"
				},
			function(data, menu)
				if tonumber(data.value) ~= nil then
						gpssifre = data.value
						
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gpsisim',
							{
								title = "GPS için isminizi girin"
							},
						function(data2, menu2)
							if data2.value ~= nil then
									
											
											isim =  data2.value
											sifre = gpssifre
											oyuncuID =  GetPlayerServerId(PlayerId())
											sikiksokuk = PlayerId()
											
											for k,v in pairs(GpsVeri) do 
												 if v.oyuncuID == oyuncuID then
													table.remove(GpsVeri,k)
												 end
											end
										
												
											table.insert(GpsVeri, {
															isim =  isim,
															sifre = sifre,
															oyuncuID =  oyuncuID,
															sikiksokuk = sikiksokuk
														})
									
											TriggerServerEvent('u4gps:kayitlarial', isim,sifre,oyuncuID,sikiksokuk)
											radar = true
											menu.close()
											menu2.close()
							else 
								exports['mythic_notify']:DoHudText('error', 'Gps isminiz boş olamaz')
							end

						end, function(data2, menu2)
							menu.close()
							menu2.close()
						end)
					
				else 
					exports['mythic_notify']:DoHudText('error', 'GPS şifreniz boş yada yazı olamaz')
				end

			end, function(data, menu)
				menu.close()
			end)
end)


RegisterNetEvent('u4gps:bakbakam')
AddEventHandler('u4gps:bakbakam', function()
			if selam ~= nil then
				for k,v in pairs(selam) do 
					if DoesBlipExist(v) then
						 RemoveBlip(v)
						 table.remove(selam)
					end
				end
			end		
	ESX.TriggerServerCallback("u4:gpsverial", function(veriler)
		if veriler then		
			if veriler ~= nil and GpsVeri ~= nil then
				for k,v in pairs(veriler) do 
					if v.sifre ~= nil and GpsVeri ~= nil then
						 if v.sifre == GpsVeri[1]["sifre"] then
							if  v.oyuncuID ~= GpsVeri[1]["oyuncuID"] then
								createBlip(v.sikiksokuk,v.isim,v.job)
							end
						 end	
					end 
				end 
				
			end
		else 
		 radar = false 
		end 
	end)
end)


function createBlip(id,isim,job)
	local ped = GetPlayerPed(id)
	local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then -- Add blip and create head display on player
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 1)
		ShowHeadingIndicatorOnBlip(blip, true) -- Player Blip indicator
		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped))) -- update rotation
		---SetBlipName(blip, isim)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(isim) -- set blip's "name"
		EndTextCommandSetBlipName(blip)
		SetBlipScale(blip, 1.0) -- set scale
		
		if job == 'police' then
			SetBlipColour(blip,3)
		elseif job == 'ambulance' then
		    SetBlipColour(blip,1)
		elseif job == 'sheriff' then
			SetBlipColour(blip,2)
		else 
			SetBlipColour(blip,0)
		end
		
		SetBlipAsShortRange(blip, true)
		table.insert(selam, blip) -- add blip to array so we can remove it later
	end
end


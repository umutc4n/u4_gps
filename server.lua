local ESX = nil
local veriler = {}
TriggerEvent('esx:getSharedObject', function(obj) 
	ESX = obj 
end)



ESX.RegisterUsableItem('gps', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('u4gps:gpskullanAQ', source)
end)

RegisterServerEvent('u4gps:kayitlarial')
AddEventHandler('u4gps:kayitlarial', function(isim,sifre,oyuncuID,sikiksokuk)
	local _source = source
	local sex = nil
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		if xPlayer.job.name == 'admin' or xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' or xPlayer.job.name == 'sheriff' then
			sex = xPlayer.job.name
		else 
			sex = false 
		end
	end 

	if  veriler ~= nil then
				for k,v in pairs(veriler) do 
					 if v.oyuncuID == oyuncuID then
						table.remove(veriler,k)
					 end
				end
	end 
	

	if tonumber(sifre) <= 10 then
		 if sex then
			table.insert(veriler, {
							isim =  isim,
							sifre = sifre,
							oyuncuID =  oyuncuID,
							sikiksokuk = sikiksokuk,
							job = sex
						})
		 else 
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Canım Hacker Değilsen Çok zor bu şifreyi erişmen'} )
		 end
	else 
		table.insert(veriler, {
						isim =  isim,
						sifre = sifre,
						oyuncuID =  oyuncuID,
						sikiksokuk = sikiksokuk
				})
	end
		

end)



AddEventHandler('playerDropped', function()
	-- Save the source in case we lose it (which happens a lot)
	local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		
		if  veriler ~= nil then
			for k,v in pairs(veriler) do 
				 if v.oyuncuID == xPlayer.source then
					table.remove(veriler,k)
				 end
			end
		end 
	end
		
end)




ESX.RegisterServerCallback("u4:gpsverial", function(source, cb)
local _source = source

	-- Did the player ever join?
	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)
		local gpscontrol = xPlayer.getInventoryItem("gps").count
		if gpscontrol <= 0 then
			cb(false)
			if  veriler ~= nil then
				for k,v in pairs(veriler) do 
					 if v.oyuncuID == xPlayer.source then
						table.remove(veriler,k)
					 end
				end
			end 
		else 
			cb(veriler)
		end 
		
	end
		
end)


AddEventHandler('esx:onRemoveInventoryItem', function(source, item, count)
  local _source = source
 
  if item.name == 'gps' and item.count < 1 then
    -- Did the player ever join?
    if _source ~= nil then
        local xPlayer = ESX.GetPlayerFromId(_source)

        if  veriler ~= nil then
            for k,v in pairs(veriler) do 
                 if v.oyuncuID == xPlayer.source then
                    table.remove(veriler,k)
                 end
            end
        end 
    end
 end 

end)


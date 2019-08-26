local settings = require 'settings'

wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
 print("\n\tSTA - CONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID.."\n\tChannel: "..T.channel)
 end)

 wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
 print("\n\tSTA - DISCONNECTED".."\n\tSSID: "..T.SSID.."\n\tBSSID: "..
 T.BSSID)
 for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("\tDisconnect reason: "..val.." ("..key..")")
      break
    end
  end
 end)

 wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
 print("\n\tSTA - GOT IP".."\n\tStation IP: "..T.IP.."\n\tSubnet mask: "..
 T.netmask.."\n\tGateway IP: "..T.gateway)
 end)


local wifi_setup = {}
wifi.setmode(wifi.STATION)
wifi.sta.clearconfig() 

function wifi_setup.setup_wifi()
  
  station_cfg={}
  station_cfg.ssid=settings.wifi_name
  station_cfg.pwd=settings.wifi_password
  station_cfg.save = false
  
  response = wifi.sta.config(station_cfg)
  if not response then
   print("Failed to connect")
  end
end

return wifi_setup

local settings = require 'settings'
local wifi_setup = require "wifi_setup"
local get_temperature = require 'temperature'
local mqtt_setup = require 'mqtt_setup'
local tmr = require 'tmr'

temperature = get_temperature()
wifi_setup.setup_wifi()
timeout = 10
t = tmr.create()
t:alarm(1000, tmr.ALARM_SEMI, function() 
    if ((wifi.sta.getip()==nil) and (timeout>0)) then 
        print("Waiting for IP address!") 
        timeout = timeout - 1
        t:start()
    else if ((wifi.sta.getip()==nil) and (timeout<=0)) then 
        print("Timeout when waiting for IP") 
    else
        print("New IP address is "..wifi.sta.getip())
        mqtt_setup.setup()
        if temperature ~= nil then
            mqtt_setup.publish("temperature", temperature)
            end
        end
    end 
end)


--
--m = mqtt.Client("clientid", 120)
--m:lwt("/lwt", "offline", 0, 0)
--m:on("connect", function(client) print ("connected") end)
--          m:on("offline", function(client) print ("offline") end)
--
--          -- on publish message receive event
--          m:on("message", function(client, topic, data)
--            print(topic .. ":" )
--            if data ~= nil then
--              print(data)
--            end
--          end)
--
--          -- for TLS: m:connect("192.168.11.118", secure-port, 1)
--          m:connect("192.168.1.104", 1883, 0, function(client)
--            print("connected")
--            -- Calling subscribe/publish only makes sense once the connection
--            -- was successfully established. You can do that either here in the
--            -- 'connect' callback or you need to otherwise make sure the
--            -- connection was established (e.g. tracking connection status or in
--            -- m:on("connect", function)).
--
--            -- subscribe topic with qos = 0
--            client:subscribe("water", 0, function(client) print("subscribe success") end)
--            -- publish a message with data = hello, QoS = 0, retain = 0
--            client:publish("water", "hello", 0, 0, function(client) print("sent") end)
--          end,
--          function(client, reason)
--            print("failed reason: " .. reason)
--          end)
--
--          m:close();

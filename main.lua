local settings = require 'settings'
local wifi_setup = require "wifi_setup"
local get_temperature = require 'temperature'
local mqtt_setup = require 'mqtt_setup'
local get_humidity = require 'humidity'
local set_settings = require 'set_settings'
local water = require 'water'

local function main()
-- no need for the while function, as deep sleep does restart 
    temperature = get_temperature()
    humidity = get_humidity()
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
            rtctime.dsleep(10000000)
            else
                t:unregister()
                -- We got connection, we can proceed 
                sntp.sync() -- sync time
                print(sntp.getoffset())
                print("New IP address is "..wifi.sta.getip())

                mqtt_setup.setup()
                if temperature ~= nil then
                    mqtt_setup.publish("temperature", temperature)
                end
                if humidity ~= nil then
                    if humidity < settings.humidity_treshold then
                      water()
                    end
                    mqtt_setup.publish("humidity", humidity)
                end
                t:alarm(10000, tmr.ALARM_SINGLE, function() 
                --wait a moment for anything that needed finishing to finish
                    print("Going to sleep...")
                    minutes = 30
                    seconds_in_minutes = 60
                    microseconds_in_seconds = 1000000
                    rtctime.dsleep(minutes*seconds_in_minutes*microseconds_in_seconds)

                end)
            end
        end 
    end)
end

return main

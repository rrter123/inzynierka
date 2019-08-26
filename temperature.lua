local ds18b20 = require "ds18b20"
pin = 4 -- gpio0 = 3, gpio2 = 4

local ow_pin = 3
ds18b20.setup(ow_pin)

-- read all sensors and print all measurement results
function get_temperature()
    temperature = nil
    ds18b20.read(
        function(ind,rom,res,temp,tdec,par)
            temperature = temp
        end,{});
    t = tmr.create()
    timeout = 10
    t:alarm(1000, tmr.ALARM_SEMI, function() 
        if (temperature == nil) and (timeout > 0) then
          print("Waiting for temperature")
          timeout = timeout-1
          t:start()
        else
          t:unregister()
          return temperature
        end
    end)
end

return get_temperature

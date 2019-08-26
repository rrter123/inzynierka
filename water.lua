pin = 2
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)

local function water()
    print("Watering...")
    gpio.write(pin, gpio.HIGH)
    x = tmr.create():alarm(5000, tmr.ALARM_SINGLE, function()  gpio.write(pin, gpio.LOW); print("A") end)
end

return water

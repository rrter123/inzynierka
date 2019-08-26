-- in you init.lua:
if adc.force_init_mode(adc.INIT_ADC)
then
  node.restart()
  return -- don't bother continuing, the restart is scheduled
end


local function check_humidity()
    value = adc.read(0)
    -- On its own (surrounded by air) gives a reading of 1024
    -- Fully submerged in water gives a reading of about 450
    current_100 = 400
    return 1-(value-current_100)/(1024-current_100)
end

return check_humidity

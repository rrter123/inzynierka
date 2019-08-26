local main = require 'main'

t = tmr.create()
t:alarm(3000, tmr.ALARM_SINGLE, function() 
    -- wait three seconds before running main
    main()
end)


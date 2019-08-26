local settings = require 'settings'
local tmr = require 'tmr'
local qos = 1
local connected = false
client = nil
errors = {[-5] = "There is no broker listening at the specified IP Address and Port", 
[-4] = "The response from the broker was not a CONNACK as required by the protocol",
[-3]= "DNS Lookup failed",
[-2]="Timeout waiting for a CONNACK from the broker",
[-1]="Timeout trying to send the Connect message",
[1]="The broker is not a 3.1.1 MQTT broker.",
[2]="The specified ClientID was rejected by the broker. ",
[3]="The server is unavailable.",
[4]="The broker refused the specified username or password.",
[5]="The username is not authorized."}

local mqtt_setup = {}

m = mqtt.Client(settings.mqtt_id, 120)
m:on("offline", function(client)
connected = false end)

-- on publish message receive event
m:on("message", function(client, topic, data)
print(topic .. ":"..data ) -- Not very useful, as deepsleep makes this not work
end)


function mqtt_setup.setup()


m:connect(settings.mqtt_ip, settings.mqtt_port, 0, function(local_client)
    client = local_client
    connected = true
end,
function(client, reason)
    print("Failed:" .. errors[reason])
end)
end
-- Setup done

function mqtt_setup.publish(topic, message)
   local t = tmr.create()
   timeout = 10
    t:alarm(1000, tmr.ALARM_SEMI, function() 
    
      if connected then
        client:publish(topic, message, qos, 0, function(client) 
            print("Message sent: "..topic.."-"..message) 
           end)
        t:unregister()
       else if timeout<=0 then
       print("Timeout waiting for MQTT connection")
       t:unregister()
       else
           print("Waiting for MQTT")
           timeout = timeout - 1
           t:start()
        end
      
      end
    end)
end
return mqtt_setup

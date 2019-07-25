local settings = require 'settings'

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

m = mqtt.Client("clientid", settings.mqtt_id)
--m:on("connect", function(client) 
--print("CONNECTED")
--connected = true end)
m:on("offline", function(client)
print("UNCONNECT")
connected = false end)

function mqtt_setup.setup()


-- on publish message receive event
m:on("message", function(client, topic, data)
print(topic .. ":" )
if data ~= nil then
  print(data)
end
end)

m:connect(settings.mqtt_ip, settings.mqtt_port, 0, function(local_client)
--client:subscribe("water", qos, function(client) print("subscribe water success") end)
local_client:subscribe({["water"]=qos,["temperature"]=qos}, function(local_client) print("subscribe success") end)
--client:subscribe("settings", qos, function(client) print("subscribe settings success") end)
client = local_client
connected = true
end,
function(client, reason)
print("FAIL")
print("failed reason: " .. errors[reason])
end)
end
-- Setup done

function mqtt_setup.publish(topic, message)
   print(client, connected)
   t = tmr.create()
   timeout = 10
    t:alarm(1000, tmr.ALARM_SEMI, function() 
      if connected then
        client:publish(topic, message, qos, 0, function(client) print("sent") end)

       else if timeout<=0 then
       print("Timeout waiting for MQTT connection")
         else
           timeout = timeout - 1
           t:start()
        end
      
      end
    end)
   --m:connect(settings.mqtt_ip, settingsmqtt_port, 0, function(client)
  --client:publish(topic, message, qos, 0, function(client) print("sent") end)
--end,
--function(client, reason)
--  print("failed reason: " .. errors[reason])
--end)
--m:close();
end
return mqtt_setup

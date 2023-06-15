local m = require("module1")

local f = require("module2")


if f.apFlag == false then
  print("AP turn")
  wifi.setmode(wifi.SOFTAP)  -- set Wi-Fi mode to access point
  wifi.ap.config(m.ap_cfg)  -- configure access point with SSID and password
  f.apFlag = true
end


if f.gpioFlag == false then
  print("gpio activate")
  gpio.mode(4,gpio.OUTPUT)
  f.gpioFlag = true
end


if sv == nil then
   print("server_start") 
   sv = net.createServer(net.TCP, 30)
-- server listens on 80, if data received, print data to console and send "hello world" back to caller
-- 30s time out for a inactive client
end


if f.cfgRcvFlag == true then
  print("flag cfgRcv set to True, sv will be close:")
  sv:close()
  sv = nil
  f.svLithenFlag = false
  f.cfgRcvFlag = false
  dofile("wifi.lua") end
      
      
if sv and f.svLithenFlag == false then
  f.svLithenFlag = true
  sv:listen(80, function(conn)
    print("**********************")
    print(f.textInfo)
    conn:send("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" .. m.html)
    print("html sending, client connected")
    local time = tmr.now()
    print("time in microseconds", time)
    conn:on("receive", m.receiver)
--    while f.callbackFlag == false do
--      local n = 0
--      n = n + 1
--    end
    --conn:close()
    --print("close")
    --conn:on("sent", function(client) client:close() end)
    print("i am in initload", tmr.now())
    --conn:close()
  end)
end


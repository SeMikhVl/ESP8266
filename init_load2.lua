local m = require("module1")

print("AP turn")
wifi.setmode(wifi.SOFTAP)  -- set Wi-Fi mode to access point
wifi.ap.config(m.ap_cfg)  -- configure access point with SSID and password
-- server listens on 80, if data received, print data to console and send "hello world" back to caller
-- 30s time out for a inactive client
print("gpio activate")
gpio.mode(4,gpio.OUTPUT)
if sv == nil then
   print("server_start") 
   sv = net.createServer(net.TCP, 30)
end


if sv then
  sv:listen(80, function(conn)
    print("**********************")
    conn:send("HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" .. m.html)
    print("html sending, client connected")
    conn:on("receive", m.receiver)
    --conn:close()
    --print("close")
    --conn:on("sent", function(client) client:close() end)
    --net.socket:close()
    print("flag before sv close:", m.flag)
    if m.flag == true then 
      sv:close()
      dofile("wifi.lua") end
  end)
end


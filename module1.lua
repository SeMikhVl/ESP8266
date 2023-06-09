
local M ={}

local f = require("module2")

M.ap_cfg = {ssid="MyESP8266", pwd="mypassword"}

M.pin = ""


M.html = [[
      <!DOCTYPE html>
      <html>
        <head>
          <title> HELLO!!!!!!!!! </title>
        </head>
        <body>
          <h1> HEEELLLOOOO!!!!</h1>
          <p>DIODE SWITCH <a href=\"?pin=ON\"><button>ON</button>&nbsp;<a href =\"?pin=OFF\"><button>OFF</button></a></p>
          <h1>WiFi Configuration</h1>
          <form method="get" action="">
            <label for="ssid">SSID:</label>
            <input type="text" name="ssid" id="ssid" required><br><br>
            <label for="password">Password:</label>
            <input type="text" name="password" id="password" required><br><br>
            <input type="submit" value="Connect">
          </form>
        </body>
      </html>
    ]]


function M.receiver(sck, data)
  local ssid, password = "", ""
  local station_cfg= {ssid= "", pwd = ""}
  M.pin = string.match(data, "pin=([%w_]+)")
  print("data given, callback fun running", tmr.now())
  if M.pin == "ON" then gpio.write(4, gpio.LOW) end
  if M.pin == "OFF" then gpio.write(4, gpio.HIGH) end
  ssid, password = string.match(data, "ssid=([^&]+)&password=([^ ]+)")
  
  if ssid and password then
    f.cfgRcvFlag = true
    print("SSID:", ssid, type(ssid))
    print("Password:", password, type(password))
    station_cfg.ssid = ssid
    station_cfg.pwd = password
    M.station_cfg = station_cfg
    if M.station_cfg.pwd == "kolobok99" then 
      print("PASSWORD IS THE SAME", M.station_cfg.pwd)
      print(type(M.station_cfg.pwd))
    else print("PASSWORD IS NOT THE SAME", M.station_cfg.pwd) 
      print(type(M.station_cfg.pwd))
    end
    --data = nil
    
  end
  print("socket wil be close, cfgRcvFlag set to", f.cfgRcvFlag)
  sck:close()
--  f.callbackFlag = true
  end



return M
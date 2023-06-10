local f = require("module2")
local m = require("module1")

f.cfgRcvFlag = false

wifi.setmode(wifi.STATIONAP)

--local staConfig = 

wifi.sta.config(m.station_cfg)

local maxAttempts = 3  -- Maximum number of connection attempts

-- Connect to the Wi-Fi network
local connectAttempts = 0  -- Counter for connection attempts

local function connectToWifi()
  connectAttempts = connectAttempts + 1
  print("Connection attempt #" .. connectAttempts)
  wifi.sta.connect()
end

local function handleConnectionSuccess()
  -- Station connected and got an IP address
  print("Connected to Wi-Fi. IP address: " .. wifi.sta.getip())
  -- Additional code or operations here
  
  -- Disable event monitoring
  wifi.sta.eventMonStop()
end

local function handleConnectionFailure()
  -- Station failed to connect to Wi-Fi
  print("Failed to connect to Wi-Fi")
  
  if connectAttempts < maxAttempts then
    -- Retry connection after a delay
    local retryDelay = 5000  -- 5 seconds
    print("Retrying connection in " .. retryDelay .. " ms")
    tmr.create():alarm(retryDelay, tmr.ALARM_SINGLE, connectToWifi)
  else
    -- Maximum connection attempts reached, disable event monitoring
    print("Maximum connection attempts reached. Disabling event monitoring.")
    wifi.eventmon.unregister(wifi.eventmon.STA_DISCONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
  end
end

-- Register event callbacks for connection status
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, handleConnectionSuccess)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, handleConnectionFailure)

-- Start initial connection attempt
connectToWifi()



print("i am in the end and cfgRcvFlag set to false, and pwd", m.station_cfg.pwd, type(m.station_cfg.pwd))
--dofile("init_load2.lua")
local f = require("module2")
local m = require("module1")

f.cfgRcvFlag = false

wifi.setmode(wifi.STATIONAP)

--local staConfig = 

wifi.sta.config(m.station_cfg)

local maxAttempts = 3  -- Maximum number of connection attempts

-- Connect to the Wi-Fi network
local connectAttempts = 0  -- Counter for connection attempts

--local statusSta = wifi.sta.status()

local wifiFlag = true


local co = coroutine.create(function()

  while wifiFlag == true do
  connectAttempts = connectAttempts + 1
  print("Connection attempt #" .. connectAttempts)
  wifi.sta.connect()
  coroutine.yield()
end
  print("start_init_load")
  dofile("init_load2.lua")
end)


local function resumeCoroutine()
  coroutine.resume(co)
end

local function stopEventReg()
    wifi.eventmon.unregister(wifi.eventmon.STA_DISCONNECTED)
    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
  end
  
  
local function handleConnectionSuccess()
  -- Station connected and got an IP address
  f.ipSTA = wifi.sta.getip()
  print("Connected to Wi-Fi. IP address: " .. f.ipSTA)
  -- Additional code or operations here
  
  -- Disable event monitoring
  stopEventReg()
  print(wifi.sta.status())
  wifiFlag = false
  f.textInfo = "connection success" .. f.ipSTA
  resumeCoroutine()
  end

local function handleConnectionFailure()
  -- Station failed to connect to Wi-Fi
  print("Failed to connect to Wi-Fi")
  print("status sta", wifi.sta.status())
  
  if connectAttempts < maxAttempts then
    -- Retry connection after a delay
    local retryDelay = 5000  -- 5 seconds
    print("Retrying connection in " .. retryDelay .. " ms")
    tmr.create():alarm(retryDelay, tmr.ALARM_SINGLE, resumeCoroutine)
  else
    -- Maximum connection attempts reached, disable event monitoring
    print("Maximum connection attempts reached. Disabling event monitoring.")
    stopEventReg()
    f.textInfo = "failed connecting"
    print(f.textInfo)
    wifiFlag = false
    
    resumeCoroutine()
--    coroutine.yield(co) error call yield across metamethod/c-call boundary
  end
end

-- Register event callbacks for connection status
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, handleConnectionSuccess)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, handleConnectionFailure)

-- Start initial connection attempt
--connectToWifi()





resumeCoroutine()

print("i am in the end and cfgRcvFlag set to false, and pwd", m.station_cfg.pwd, type(m.station_cfg.pwd))
--dofile("init_load2.lua")
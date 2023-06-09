local m = require("module1")

print("i am here and flag", m.flag)
m.flag = false
dofile("init_load2.lua")
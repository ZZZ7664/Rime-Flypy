themeColorArray = {{"iOS.trime", "default"}, {"iOS.trime", "iOSSL"}, {"iOS_light.trime", "default"}, {"iOS_light.trime", "iOSBL"}}
--2

require "import"
import "java.io.*"
import "android.content.*"

import "com.osfans.trime.*"

local args = (...)

local rimeDir = service.getLuaExtDir()
local luaName = "随机切换主题.lua"

local file = io.open(rimeDir.."/script/"..luaName, "r")
local oneLine = file:read()
local twoLine = file:read()
local text = file:read("*all")
local idx = twoLine:sub(3, #twoLine)
if idx == "" then
  idx = -1
else
  idx = tonumber(idx)
end
file:close()

local randomIdx = -1
while true do
  randomIdx = math.random(#themeColorArray)
  if randomIdx ~= idx then
    break
  end
end

Config.get().setTheme(themeColorArray[randomIdx][1])
Config.get().setColor(themeColorArray[randomIdx][2])
Trime.getService().initKeyboard()

--刷新
local file = io.open(rimeDir.."/script/"..luaName, "w")
file:write(oneLine.."\n--"..randomIdx.."\n"..text)
file:close()

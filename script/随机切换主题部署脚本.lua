--随机切换主题和配色的部署脚本
--author：ahao

--本脚本说明：（部署脚本）
--该脚本不是直接的随机切换主题脚本，而是一个部署脚本
--1. 将该脚本放到rime/script目录下
--2. 请自行在主题中添加下方两个预设：
--RandomThemeSwitchDeploy: {label: '随切部署', send: function, command: '随机切换主题部署脚本.lua', option: ""}
--Theme_Switch: {label: '随切主题', send: function, command: '随机切换主题.lua', option: ""}
--第一个预设用于部署，第二个预设用于切换
--3. 将预设添加到主题按键中使用
--建议：预设RandomThemeSwitchDeploy放置到菜单按键中，Theme_Switch用于添加为用于切换的功能键

require "import"
import "java.io.*"
import "android.content.*"

import "com.osfans.trime.*"

local themeArray = {"iOS", "iOS_light"} --在此处填写用于切换的主题列表

local themeColorArray = {}

local rimeDir = service.getLuaExtDir()
local luaName = "随机切换主题.lua"

for i = 1, #themeArray do
  Config.get().setTheme(themeArray[i]..".trime")
  local t = Config.get().getTheme()
  local colorArray = Config.get().getColorKeys()
  for j = 0, #colorArray - 1 do
    themeColorArray[#themeColorArray + 1] = {t, colorArray[j]}
  end
end

local themeColorArrayText = "themeColorArray = {"
for i = 1, #themeColorArray do
  themeColorArrayText = themeColorArrayText.."{\""..themeColorArray[i][1].."\", \""..themeColorArray[i][2].."\"}, "
end
themeColorArrayText = themeColorArrayText:sub(1, -3).."}"

--写入工作脚本的内容
local text = [[
--2

require "import"
import "java.io.*"
import "android.content.*"

import "com.osfans.trime.*"

local args = (...)

local rimeDir = service.getLuaExtDir()
local luaName = "]]..luaName..[["

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
]]

local file = io.open(rimeDir.."/script/"..luaName, "w")
file:write(themeColorArrayText.."\n"..text)
file:close()

print("随机切换主题脚本部署成功")
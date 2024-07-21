--循环切换主题
require "import"
import "java.io.File"
import "com.osfans.trime.*"

local args = (...) -- 参数

-- 预设手动切换方式
local manualModeList = {{"循环切换主题", "循环"}, {"随机切换主题", "随机"}}
-- 预设自动切换方式
local autoModeList = {{"跟随时间切换主题", "智能"}, {"跟随系统切换主题", "系统"}}

local rimeDir = service.getLuaExtDir()
local manualMode = "手动切换主题" --手动切换的统一处理脚本
local luaName = "更改切换方式.lua" --本脚本名称
local themeLuaName = "iOS.lua.yaml" --主题preset_keys文件
local label = "" -- 用于记录状态label

local file = io.open(rimeDir.."/script/"..luaName, "r")
local oneLine = file:read()
oneLine = oneLine:sub(3, #oneLine)
local text = file:read("*all")

-- 如果args为空，则取下一个模式
if args == '' or args == "	" then
    for i = 1, #manualModeList do
        if oneLine == manualModeList[i][1] then
            if i ~= #manualModeList then
                args = manualModeList[i + 1][1]
            else
                args = autoModeList[1][1]
            end
        end
    end
    for i = 1, #autoModeList do
        if oneLine == autoModeList[i][1] then
            if i ~= #autoModeList then
                args = autoModeList[i + 1][1]
            else
                args = manualModeList[1][1]
            end
        end
    end
end

-- 关闭自动切换脚本（修改脚本名）
local function closeAutoLua(mode)
    os.rename(rimeDir.."/script_auto/"..mode..".lua", rimeDir.."/script_auto/"..mode..".lua.off")
end

-- 启用自动切换脚本
local function openAutoLua(mode)
    os.rename(rimeDir.."/script_auto/"..mode..".lua.off", rimeDir.."/script_auto/"..mode..".lua")
end

-- 关闭手动切换脚本（关闭所有手动）
local function closeManualua()
    local file = io.open(rimeDir.."/script/"..manualMode..".lua", "w")
    file:write("")
    file:close()
end

-- 启用手动切换脚本
local function openManualLua(mode)
    -- 读取目标脚本
    local file = io.open(rimeDir.."/script/"..mode..".lua", "r")
    local text = file:read("*all")
    file:close()

    -- 写入手切脚本
    file = io.open(rimeDir.."/script/"..manualMode..".lua", "w")
    file:write(text)
    file:close()
end

-- 处理自动切换模式
for i = 1, #autoModeList do
    if args == autoModeList[i][1] then
        openAutoLua(args) -- 启用自动切换脚本
        closeManualua() -- 关闭所以手动切换脚本
        label = autoModeList[i][2]
    else
        closeAutoLua(autoModeList[i][1])
    end
end

-- 处理手动切换模式
for i = 1, #manualModeList do
    if args == manualModeList[i][1] then
        openManualLua(args)
        label = manualModeList[i][2]
    end
end

local luaYamlTextArray = {}
local temp = ""
local f = true

-- 刷新记录
for line in io.lines(rimeDir.."/"..themeLuaName) do
  if string.find(line, "#更改切换方式preset_keys") ~= nil then
    temp = temp..line.."\n"
    luaYamlTextArray[#luaYamlTextArray + 1] = temp
    f = false
  elseif string.find(line, "#方案切换preset_keys") ~= nil then
    temp = line.."\n"
    f = true
  elseif f then
    temp = temp..line.."\n"
  end
end
luaYamlTextArray[#luaYamlTextArray + 1] = temp

file = io.open(rimeDir.."/"..themeLuaName, "w")
file:write(luaYamlTextArray[1].."  ThemeSwitch: {label: '"..label.."', send: function, command: '"..luaName.."', option: \"	\"}\n"..luaYamlTextArray[2])
file:close()

file = io.open(rimeDir.."/script/"..luaName, "w")
file:write("--"..args.."\n"..text)
file:close()

Config.get().setTheme(Config.get().getTheme())
Trime.getService().initKeyboard()
print("主题切换方式已更改为："..args)

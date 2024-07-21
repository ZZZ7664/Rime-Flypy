--flypy

--使用方法：
--1. 在第一行注释"--"的后面写入你当前方案的名称（不带".schema.yaml"）
--2. 在主题方案perset_keys中加键：
--  ResetAutoScript: {label: '重置脚本', send: function, command: '重置自动化脚本.lua', option: ""}

--注意：
--请不要修改当前脚本的名称，如有修改，需要在脚本对应的位置也进行修改

require "import"
import "java.io.File"
import "com.osfans.trime.*"

local luaName = "自动化脚本重置.lua"

local rimeDir = service.getLuaExtDir()


local file = io.open(rimeDir.."/script/"..luaName, "r")
local oneLine = file:read()
local text = file:read("*all")
file:close()


local ordName = string.sub(oneLine, 3, string.len(oneLine))
local newName = Rime.getSchemaId()

os.rename(rimeDir.."/"..ordName..".lua", rimeDir.."/"..newName..".lua")

file = io.open(rimeDir.."/script/"..luaName, "w")
file:write("--"..newName.."\n"..text)
file:close()

print("脚本已重置︎")
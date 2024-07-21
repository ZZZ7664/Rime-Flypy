require "import"
import "java.io.File"
import "com.osfans.trime.*"

--有参数时切换到参数的:方案
--无参数时重置方案键盘
--自动生成预设与按键

local args = (...) -- 参数

function main()

  local schemaList = Rime.getSchemaIds() --方案id列表
  local schemaNameList = Rime.getSchemaNames() --方案名称列表

  if args ~= "a" then
    Rime.selectSchema(tonumber(args))
    return
  end

  local rimeDir = service.getLuaExtDir()
  local trimeName = "iOS" --主题名称

  local luaYamlTextArray = {} --.lua.yaml原文本数组
  local yamlTextArray = {} --.yaml原文本数组
  local temp = ""
  local f = true

  --读取.lua.yaml
  for line in io.lines(rimeDir.."/"..trimeName..".lua.yaml") do
    temp = temp..line.."\n"
    if string.find(line, "#方案切换preset_keys") ~= nil then
      luaYamlTextArray[#luaYamlTextArray + 1] = temp
      break
    end
  end
  
  temp = ""
  
  --读取.yaml
  for line in io.lines(rimeDir.."/"..trimeName..".trime.yaml") do
    if string.find(line, "##方案切换脚本开始标识") ~= nil then
      temp = temp..line.."\n"
      yamlTextArray[#yamlTextArray + 1] = temp
      f = false
    elseif string.find(line, "##方案切换脚本结束标识") ~= nil then
      temp = line.."\n"
      f = true
    elseif f then
      temp = temp..line.."\n"
    end
  end
  yamlTextArray[#yamlTextArray + 1] = temp

  local presetKeysText = ""
  local presetKeyboardsText = ""
  local keysIdxList = {2, 3, 4, 5, 9, 10, 11, 12}

  for i = 0, #keysIdxList -1 do
    if i < #schemaList then
      presetKeysText = presetKeysText.."  SchemeSwitch"..i..": {label: '"..schemaNameList[i].."', send: function, command: '方案切换.lua', option: "..i.."}\n"
      presetKeysText = presetKeysText.."  SchemeSwitchReset"..i..": {label: '"..schemaNameList[i].."', text: '{SchemeSwitch"..i.."}{ResetAutoScript}'}\n"
      presetKeyboardsText = presetKeyboardsText.."      'keys/@"..keysIdxList[i+1].."/click': SchemeSwitchReset"..i.." \n      'keys/@"..keysIdxList[i+1].."/hint': '"..schemaNameList[i].."'\n      'keys/@"..keysIdxList[i+1].."/swipe_right': J_menu_22\n      'keys/@"..keysIdxList[i+1].."/swipe_left': J_menu1\n      'keys/@"..keysIdxList[i+1].."/key_text_size': 14\n"
    else
      presetKeyboardsText = presetKeyboardsText.."      'keys/@"..keysIdxList[i+1].."/click': ''\n      'keys/@"..keysIdxList[i+1].."/hint': ''\n      'keys/@"..keysIdxList[i+1].."/swipe_right': J_menu_22\n      'keys/@"..keysIdxList[i+1].."/swipe_left': J_menu1\n"
    end
  end

  --写入主题的.lua.yaml
  local file = io.open(rimeDir.."/"..trimeName..".lua.yaml", "w")
  file:write(luaYamlTextArray[1]..presetKeysText)
  file:close()
  --写入主题yaml
  file = io.open(rimeDir.."/"..trimeName..".trime.yaml", "w")
  file:write(yamlTextArray[1]..presetKeyboardsText..yamlTextArray[2])
  file:close()
  
  print("方案加载完成")
end

main()

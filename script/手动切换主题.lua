--按顺序循环切换主题和配色
--author：ahao&狸猫
--由狸猫大佬优化

--使用方法：
--1. 将该脚本放到rime/script目录下
--2. 在19行后面填写用于切换的主题列表（参考现有的格式）
--3. 在多个主题perset_keys中添加预设预设
-- Theme_Switch: {label: '切换主题', send: function, command: '循环切换主题.lua', option: ""}
--4. 将预设添加到主题按键中使用

require 'import'
import "java.util.concurrent.locks.LockSupport"

if not _G.mThread0 then
  _G.mThread0=thread(function()
    require "import"
    import "java.io.*"
    import "android.content.*"
    import 'java.util.*'
    import "com.osfans.trime.*"
    import "java.util.concurrent.locks.LockSupport"

    local themeArray = {"iOS", "iOS_light"} --在此处填写用于切换的主题列表 
    local lock=false
    while (true) do
      if lock then
        LockSupport.park()
      end
      lock=true
      local config=Config.get()
      local colorArray = config.getColorKeys()
      local cidx = Arrays.binarySearch(colorArray, config.getColorScheme())
      local tidx = table.find(themeArray,config.getTheme():sub(1,-7)) or -1
      local message = "切换到%s“%s”"

      if cidx ~= #colorArray - 1 then
        config.setColor(colorArray[cidx + 1])
        message = message:format('配色',tostring(colorArray[cidx + 1]))
       else
        if tidx == #themeArray then
          tidx = 0
        end
        config.setTheme(themeArray[tidx + 1]..".trime")
        message = message:format("主题",themeArray[tidx + 1])
      end

      call('init')

      print(message)
    end
  end)

  local ts=Trime.getService()
  function _G.init()
    ts.initKeyboard()
  end

  return
end

LockSupport.unpark(_G.mThread0)
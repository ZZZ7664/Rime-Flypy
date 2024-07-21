
local 版本号="5.0"

local 帮助内容=[[
</big><font color=red><b>帮助说明</b></font></big>

中文输入法脚本

▂▂▂▂▂▂▂▂
自定义短语版 5.0
2023.08.11
————
--更新作者: 作者不知道该写什么——字面意思 2556814566
--总节：与剪切板5.09统一风格 平时有空摸的太杂了记不清
--不过有一说一 前面那几位 你们又是制表符(Tab)又是空格混用 空格还又细分为 两格和四格 那格式缩进看的我头皮发麻
▂▂▂▂▂▂▂▂
自定义短语板 4.0
原作者： 星乂尘 1416165041@qq.com
2020.09.04
————
--无障碍版专用脚本
--脚本名称: 自定义短语板
--说明：中文输入法无障碍版原生短语板优化版,基于 星乂尘_自定义短语板3.1 修改
--增加搜索,优先首选,选中内容
--版本号: 3.5
▂▂▂▂▂▂▂▂
日期: 2020年12月08日🗓️
农历: 鼠🐁庚子年十月廿四
时间: 18:26:19🕕
星期: 周二
--制作者: 风之漫舞
--首发qq群: Rime 同文斋(458845988)
--邮箱: bj19490007@163.com(不一定及时看到)

--本次更新: 2021.10.09
--By＠合欢∣hehuan.ys168.com
--增加生成二维码，增加语音播报，增加一键加词自动编码，增加推送到云端，增加从云端获取(点击短语板标题获取)，增加分词
--优化搜索
--版本号: 4.0

--脚本配置说明
<b>用法一</b>
①放到脚本启动器->脚本库目录 下任意位置及子文件夹中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,
单击上屏文字

--------------------
<b>用法二</b>
第①步 将 脚本文件解压放置 Android/rime/script 文件夹内,
默认脚本路径为Android/rime/script/自定义短语板/自定义短语板.lua

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys,加入以下内容

preset_keys:
  lua_script_cvv: {label: 短语板, functional: false, send: function, command: "自定义短语板/自定义短语板.lua", option: "default"}
向该主题方案任意键盘按键中加入上述按键既可

]]




require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.RectF"
import "android.media.MediaPlayer"
import "android.graphics.drawable.StateListDrawable"
import "java.io.File"
import "android.text.Html"
import "android.os.*"
import "com.osfans.trime.*" --载入包
import "android.graphics.Typeface"
import "android.content.Context" 
import "android.speech.tts.*"
import "yaml"
import "java.math.BigInteger"

--隐藏状态栏()
local 输入法目录=tostring(service.getLuaExtDir("")).."/"
local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)
local 脚本相对目录=string.sub(脚本相对路径,1,-#纯脚本名-1)
local 主题组=Config.get()
local 当前主题0=主题组.getTheme()
local 主题文件=输入法目录.."build/"..当前主题0..".yaml"
local yaml组 = yaml.load(io.readall(主题文件))

local 参数=(...)

local 输入法目录=tostring(service.getLuaExtDir("")).."/"
local 脚本目录=tostring(service.getLuaExtDir("script")).."/"
local 脚本路径=debug.getinfo(1,"S").source:sub(2)--获取Lua脚本的完整路径
local 纯脚本名=File(脚本路径).getName()
local 目录=string.sub(脚本路径,1,#脚本路径-#纯脚本名)
local 脚本相对路径=string.sub(脚本路径,#脚本目录+1)
local 脚本相对目录=string.sub(脚本相对路径,1,-#纯脚本名-1)

local 键盘名=""
local 选中内容 = service.getCurrentInputConnection().getSelectedText(0)--取编辑框选中内容,部分app内无效
local 上次上屏 = Rime.getCommitText() --己上屏文字

local 标题=纯脚本名:sub(1,-5)
    标题=标题..版本号
    标题=""

if File(输入法目录 .. "script/包/键盘操作/功能键.lua").exists() then
  import "script.包.键盘操作.功能键"
end

if File(输入法目录 .. "script/包/键盘操作/自动状态栏.lua").exists() then
  import "script.包.键盘操作.自动状态栏"
end



if 选中内容 =="" or 选中内容 ==nil then
  选中内容 = 上次上屏
end

if 参数=="" or 参数==选中内容 or 参数==nil or 参数:find("剪切板")~=nil or 参数:find("搜索")~=nil or 参数:find("分词")~=nil or 参数:find("帮助")~=nil then
    键盘名="K_default" 
else
    键盘名="K_"..参数
end

local 文件=tostring(service.getLuaDir("")).."/phrase.json"

local vibeFont=Typeface.DEFAULT
local 字体文件 = tostring(service.getLuaDir("")).."/fonts/蓝宝石专用字体.ttf"
if File(字体文件).exists()==true then
  vibeFont=Typeface.createFromFile(字体文件)
end--if File(字体文件)

--短语板过滤，find("")里写正则
----[[
local 短语板数组=service.getPhrase()
for i=0,#短语板数组-1 do
    if 短语板数组[i]:find("龥")~=nil then
        print("自动过滤掉："..短语板数组[i])
        短语板数组.remove(i)
    end
end
--]]

local function 导入模块(模块,内容)
   dofile_信息表=nil
   dofile_信息表={}
   dofile_信息表.上级脚本=脚本路径
   dofile_信息表.上级脚本所在目录=目录
   dofile_信息表.上级脚本相对路径=脚本相对路径
   dofile_信息表.纯脚本名=纯脚本名:sub(1,-5)
   dofile_信息表.内容=内容
   dofile(目录..模块)--导入模块
end


-- 搜索功能------------开始------------
-- 优先级
-- 参数 >> 状态栏 >> 选中文本 >> 上次上屏
-- 这里不考虑启动参数
local 预搜索内容 = ""
local function getSearchStr()
    if Rime.RimeGetInput() ~= "" then
        预搜索内容 = Rime.getComposingText() -- 当前候选
    else
        预搜索内容 = service.getCurrentInputConnection().getSelectedText(0) -- 取编辑框选中内容,部分app内无效
    end
    if 预搜索内容 == "" or 预搜索内容 == nil then
        预搜索内容 = Rime.getCommitText() -- 已上屏文字
    end
end
-- 解除下面注释则启动立刻进行搜索
getSearchStr()
-- 搜索功能------------结束------------

local function Back(color,light,radius) 
  if radius == nil then
    radius = 20
  end
  local bka=LuaDrawable(function(c,p,d)
  local b=d.bounds
  b=RectF(b.left,b.top,b.right,b.bottom)
  p.setColor(light) -- 高亮颜色
  p.setAntiAlias(true) -- 开启抗锯齿
  c.drawRoundRect(b,radius,radius,p) --圆角20
  end)
  local bkb=LuaDrawable(function(c,p,d)
  local b=d.bounds
  b=RectF(b.left,b.top,b.right,b.bottom)
  p.setColor(color) -- 默认颜色
  p.setAntiAlias(true) -- 开启抗锯齿
  c.drawRoundRect(b,radius,radius,p)
  end)


local stb,state=StateListDrawable(),android.R.attr.state_pressed
  stb.addState({-state},bkb)
  stb.addState({state},bka)
  return stb
end

local function Icon(k,s) --获取k功能图标，没有则返回s
  k=Key.presetKeys[k]
  return k and k.label or s
end

local function Bu_R(id) --生成功能键
  local ta={TextView,
    gravity=17,
    Background=Back(0x49d3d7da, 0x49ffffff),
    layout_height=-1,
    layout_width=-1,
    layout_weight=1,
    layout_margin="1dp",
    layout_marginTop="2dp",
    layout_marginBottom="2dp",
    textColor=0xFFFFFFFF,
    textSize="18dp"}

  if id==1 then
    ta.text=Icon("BackSpace","⌫")
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("BackSpace")
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
   elseif id==2 then
    ta.text="空格"
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("space")
    end
    ta.OnLongClickListener={onLongClick=function() 
        service.commitText("\t")
        return true
    end}
   elseif id==3 then
    ta.text=Icon("Return","⏎")
    ta.textSize="18dp"
    ta.onClick=function()
      service.sendEvent("Return")
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
   elseif id==4 then
    ta.text=Icon("返回","返回")
    ta.onClick=function()
          service.sendEvent("Keyboard_default")
      恢复状态栏()
    end
    ta.OnLongClickListener={onLongClick=function()
      service.sendEvent("Keyboard_default")
      恢复状态栏()
      return true
    end}
--    service.sendEvent(键盘名)
--    ta.text=Icon(键盘名,"返回")
--    end
--    ta.OnLongClickListener={onLongClick=function()
--        service.sendEvent("Keyboard_default")
--        return true
--    end}
    elseif id==5 then
    ta.text=Icon("清除","清除")
    ta.onClick=function()
      io.open(文件,"w"):write("[\n]"):close()
      local 输入法实例=Trime.getService()
      输入法实例.loadPhrase()
      print("数据已清除")
      service.sendEvent("Keyboard_default")
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
    elseif id==6 then
    ta.text="帮助"
    ta.onClick=function()
      导入模块("帮助模块.text",帮助内容)
    end
    ta.OnLongClickListener={onLongClick=function() return true end}
    elseif id==7 then
    ta.text=Icon("全选","全选")
    ta.textSize="18dp"
    ta.onClick=function()
        功能_全选()
    end
    elseif id==8 then
    ta.text=Icon("复制","复制")
    ta.textSize="18dp"
    ta.onClick=function()
        功能_复制()
    end
    elseif id==9 then
    ta.text=Icon("剪切","剪切")
    ta.textSize="18dp"
    ta.onClick=function()
        功能_剪切()
    end
    elseif id==10 then
    ta.id="ss"
    ta.text = Icon("搜索", "搜索")
    ta.textSize="18dp"
    ta.onClick=function()
      if utf8.sub(参数,1,6)=="【【搜索】】" then 
        Key.presetKeys.lua_script_l={label= "脚本", send="function", command=脚本相对路径, option="搜索0"}
      elseif 预搜索内容 then
        Key.presetKeys.lua_script_l={label= "脚本", send="function", command=脚本相对路径, option="【【搜索】】"..预搜索内容}
      else
        Key.presetKeys.lua_script_l={label= "脚本", send="function", command=脚本相对路径, option="搜索0"}
      end
      service.sendEvent("lua_script_l")
    end
    elseif id==11 then
    ta.text=Icon("添加","添加")
    ta.textSize="18dp"
    ta.id="test_demo"
    end
  return ta
end


local 默认高度 = service.getLastKeyboardHeight()
if 默认高度 < 300 then 
    默认高度 = 300 
end

local ids,layout={},{
  FrameLayout,
  --键盘高度
  layout_height=默认高度,
  layout_width=-1,
  --背景颜色
  BackgroundColor=0xffd7dddd,
  {TextView,
    id="title",
    layout_height="20dp",
    layout_width=-1,
    text="•帮助说明",
    textColor = "#FFFFFFFF",
    gravity="center",
    paddingLeft="2dp",
    paddingRight="2dp",
    --BackgroundColor=0x49d3d7da,
  },
  {
    LinearLayout,
    orientation = 0, -- 水平布局
    layout_height=-1,
    {ListView, --列表控件
      id="list",
      layout_marginTop="20dp", --和标题高度相等
      --DividerHeight=0,  --无间隔线
      layout_width=-1,
      layout_weight=1
    },

    -- {LinearLayout,
    --     layout_marginTop="20dp", --和标题高度相等
    --     orientation=1,
    --     layout_weight=1,
    --     layout_width="130dp",
    --     layout_height=-1,
    --     layout_gravity=5|84,
    --     -- Bu_R(11),
    --     -- Bu_R(7),
    --     -- Bu_R(8),
    --     -- Bu_R(9),
    --     -- Bu_R(2),
    --     },

    {LinearLayout,
      layout_marginTop="20dp", --和标题高度相等
      orientation=1,
      layout_weight=1,
      layout_width="130dp",
      layout_height=-1,
      layout_gravity=5|84,
      Bu_R(4),
      -- Bu_R(6),
      Bu_R(11),
      Bu_R(10),
      Bu_R(3),
      Bu_R(1),
    },
  },
}

layout=loadlayout(layout,ids)

function rippleDrawable(color)
  import"android.content.res.ColorStateList"
  return activity.Resources.getDrawable(activity.obtainStyledAttributes({android.R.attr.selectableItemBackground--[[Borderless]]}).getResourceId(0,0)).setColor(ColorStateList(int[0].class{int{}},int{color or 0x20000000}))
end
function gradientDrawable(orientation,colors)
  import"android.graphics.drawable.GradientDrawable"
  return GradientDrawable(GradientDrawable.Orientation[orientation],colors)
end
local data,item={},{LinearLayout,
  layout_width=-1,
  id="TV_z",
  padding="4dp",
  gravity=3|17,
  {TextView,
    id="TV_a",
    textColor=0xFF6282D2,
    textSize="17dp"},
  {TextView,
    id="TV_b",
    gravity=3|17,
    paddingLeft="4dp",
    --最大显示行数
    MaxLines=3,
    --最小高度
    MinHeight="30dp",
    Typeface=vibeFont,
    textColor=0xFFFFFFFF,
    textSize="15dp"}}

local adp=LuaAdapter(service,data,item)
ids.list.Adapter=adp

local function fresh(t)
  table.clear(data)
  for i=0,#t-1 do
    local v=t[i]
    local a,b,c=v:match("^%s*([^\n]+)(\n*[^\n]*)(\n*[^\n]*)")
    a = table.concat{utf8.sub(a or "", 1, 99), utf8.sub(b or "", 1, 99), utf8.sub(c or "", 1, 99)}
    local 内容=v
    -- & 后面跟了个u200B 零宽空格字符 以防止html识别其为特殊字符 如&nbsp; 空格
    内容 = string.gsub(a, "&", "&​")
    内容=string.gsub(内容,"\n","<br>")
    -- 内容="</big><font color=red><b>"..tostring(i+1)..".</b></font></big>"..内容
    table.insert(data,{TV_a = Html.fromHtml("</big><font><b>" .. tostring(i+1) .. ". </b></font></big>"), TV_b=Html.fromHtml(内容),TV_z={background=Back(0x00,0x79DBDBDB)}})
  end
  if #t == 0 then
    table.insert(data, {TV_a = Html.fromHtml("</big><font><b>" .. tostring(1) .. ". </b></font></big>"), TV_b = Html.fromHtml("短语板中无内容！")})
  end
  adp.notifyDataSetChanged()
  标题=标题.."(全部"..#t.."条)"
end

local function fresh2(t)
  ids.ss.setText("全部")
  table.clear(data)
  for i=1,#t do
    local v=t[i]
    local a,b,c=v:match("^%s*([^\n]+)(\n*[^\n]*)(\n*[^\n]*)")
    a=table.concat{utf8.sub(a,1,99),utf8.sub(b,1,99),utf8.sub(c,1,99)}
    local 内容=v
    -- & 后面跟了个u200B 零宽空格字符 以防止html识别其为特殊字符 如&nbsp; 空格
    内容 = string.gsub(a, "&", "&​")
    内容=string.gsub(内容,"\n","<br>")
    内容 = string.gsub(a, 预搜索内容, "<font color=#00ff00>" .. 预搜索内容 .. "</font>")
    -- 内容="</big><font color=red><b>"..tostring(i)..".</b></font></big>"..内容
    table.insert(data,{TV_a = Html.fromHtml("</big><font><b>" .. tostring(i+1) .. ". </b></font></big>"), TV_b=Html.fromHtml(内容),TV_z={background=Back(0x00,0x79DBDBDB)}})
  end
  if #t == 0 then
    table.insert(data, {TV_a = Html.fromHtml("</big><font><b>" .. tostring(1) .. ". </b></font></big>"), TV_b = Html.fromHtml("未搜索到【" .. "<font color=#00ff00>" .. 预搜索内容 .. "</font>" .. "】相关内容")})
  end

  adp.notifyDataSetChanged()
  标题=标题.."(\""..预搜索内容.."\" 相关共"..#t.."条)"
end

local Phrase=service.getPhrase()
local 搜索内容组={}
if utf8.sub(参数,1,6)=="【【搜索】】" then
  local 内容组={}
  for i=0,#Phrase-1 do
    内容组[i+1]=Phrase[i]
  end
  local 搜索内容=utf8.sub(参数,7)
  --print("匹配 "..搜索内容.." 中...")
  local n=1
  for i=1,#内容组 do
    local m=utf8.find(内容组[i],搜索内容)
    if m~=nil then
      搜索内容组[n]=内容组[i]
      n=n+1
    end
  end
  fresh2(搜索内容组)
else
  fresh(Phrase)
end


ids.list.onItemClick=function(l,v,p)
  local s=Phrase[p]
  if utf8.sub(参数,1,6)=="【【搜索】】" then
    s=搜索内容组[p+1]
  end--if
  service.commitText(s)
end--ids.list.onItemClick

ids.list.onItemLongClick=function(l,v,p)
  local str=Phrase[p]
  if utf8.sub(参数,1,6)=="【【搜索】】" then
    str=搜索内容组[p+1]
  end
  pop=PopupMenu(service,v)
  menu=pop.Menu
  menu.add("📑复制词条").onMenuItemClick=function(ae)
    service.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
  end
  menu.add("⚠删除词条").onMenuItemClick=function(ae)
    if utf8.sub(参数,1,6)=="【【搜索】】" then
      local n=1
      local 搜索内容组0={}
      for i=1,#搜索内容组 do
        if 搜索内容组[i]~=str then
          搜索内容组0[n]=搜索内容组[i]
          n=n+1
        end
      end
      搜索内容组=搜索内容组0
      fresh2(搜索内容组)

      for i=0,#Phrase do
        if Phrase[i]==str then
          Phrase.remove(i)
        end
      end
    else
      Phrase.remove(p)
      fresh(Phrase)
    end

    local Phrase_nr="[\n"
    for i=0,#Phrase-1 do
      Phrase0=Phrase[i]:gsub("\\","\\\\")
      Phrase0=Phrase0:gsub("/","\\/")
      Phrase0=Phrase0:gsub("\"","\\\"")
      Phrase0=Phrase0:gsub("\n","\\n")
      Phrase0=Phrase0:gsub("\t","\\t")
      Phrase_nr=Phrase_nr.."    \""..Phrase0.."\",\n"
    end
    Phrase_nr=Phrase_nr:sub(1,-3).."\n]"
    io.open(文件,"w"):write(Phrase_nr):close()
  end
  menu.add("✂分割词条").onMenuItemClick=function(ae)
    导入模块("分词工具.text",str)
  end
  -- menu.add("📤上传云端").onMenuItemClick=function(ae)
  --     导入模块("推送短语板到云端.text",str)
  -- end
  menu.add("📋一键加词").onMenuItemClick=function(ae)
    导入模块("一键加词自动编码(定长).text",str)
  end
  -- menu.add("🗣语音播报").onMenuItemClick=function(ae)
  --     service.speak(str)--文本转声音
  -- end
  -- menu.add("📇生成二维码").onMenuItemClick=function(ae)
  --     导入模块("二维码制作.text",str)
  -- end
  pop.show()
  return true
end

-- 列表滚动事件
ids.list.setOnScrollChangeListener{
  onScrollChange = function(view, scrollX, scrollY, oldScrollX, oldScrollY)
    -- 获取可视范围内第一个item的位置
    local firstVisibleItem = view.getFirstVisiblePosition()
    -- 获取可视范围内最后一个item的位置
    local lastVisibleItem = view.getLastVisiblePosition()

    -- 遍历可视的item
    for i = firstVisibleItem, lastVisibleItem do
      -- 遍厉位置减去可视范围内第一个item计算当前item在ListView中的索引位置
      local itemView = ids.list.getChildAt(i - firstVisibleItem)

      -- 获取itemView在屏幕上的顶部位置
      local item_top = itemView.getTop()
      -- 获取itemView在屏幕上的底部位置
      local item_bottom = itemView.getBottom()
      -- 获取itemView在屏幕上的高度
      local item_height = itemView.getHeight()
      -- 获取当前view在屏幕上的高度
      local height = view.getHeight()

      -- 计算itemView在屏幕上的比例
      -- 公式 (item底部位置 - 垂直滑动距离)底部至顶部的滚动距离;(item 底部位置 - item顶部位置)可视范围高度 相除即：当前可视范围内最后一个item底部相对于整个可视范围的高度比例。
      local alpha = (item_bottom - scrollY) / (item_bottom - item_top)
      -- 计算当前可视的itemView在屏幕内的高度
      -- 公式 当前视图高度和item底部位置中最小的值(防止启用横向功能键功能失效) 减去 item的顶部位置
      local visibleItemHeight = math.min(height, item_bottom) - item_top

      -- 如果得出的比例小于0则执行代码 即：当前可视的item超出了屏幕上方
      if alpha < 0 then
        -- 透明度比例设置为 item高度+item顶部位置 除以item的高度 即：可视范围内第一个item在整个item高度上的位置比例
        alpha = (item_height + item_top) / item_height
        -- 如果 item底部位置大于item高度则执行代码 即：当前可视的item超出了屏幕下方
      elseif item_bottom > item_height then -- 另类方式 alpha > 1 then
        -- 透明度比例设置为 当前可视的item高度除以整个item高度的比例
        alpha = (visibleItemHeight / item_height)
      end
      -- 设置当前item索引位置的透明度
      itemView.setAlpha(alpha)

      -- 另类底部item淡入淡出实现方式
      -- 如果当前循环的item为可视范围内最后一个item则执行代码
      -- if i == lastVisibleItem then
      --     alpha = (visibleItemHeight / item_height)
      --     itemView.setAlpha(alpha)
      -- end
    end
  end
}

ids.title.setText(标题)

ids.title.onClick=function()
  导入模块("从云端获取短语板.text","")
end

ids.test_demo.onClick=function
service.sendEvent("_add_phrase")
fresh(Phrase) -- 需在函数后定义否则找不到这个函数 所以为其专门设置id
end
service.setKeyboard(layout)

pcall(function()
  --pcall里防报错
  隐藏状态栏(layout)
end)


local bgmv_path=目录.."bg.mp4" -- 视频路径
local bgpic_path = 目录.."bg_frame.jpg" -- 图片背景路径

-- 图片背景
if File(bgpic_path).isFile()==true then
  local pic=loadlayout{ImageView,
    --添加背景色，避免看不清按键
    --BackgroundColor=0x55ffffff,
    --线性渐变，"TL_BR"为topleft bottomright
    backgroundDrawable=gradientDrawable("TL_BR",{0x99FBE0B5,0x99E5EED9,0x99F3F5F8}),--背景色
    src=bgpic_path,
    --adjustViewBounds="true",--保持长宽比
    scaleType="fitXY",--横向纵向缩放
    layout_width=-1,
    layout_height=-1}
  layout.addView(pic,0) --把图片布局放到layout的第一个，也就是显示在最底层
end
-- 视频背景
if File(bgmv_path).isFile()==true then
  pcall(function()
    local play=MediaPlayer()
    play.setDataSource(bgmv_path)
    --循环播放
    play.setLooping(true)
    play.prepare()
    --音量设为0
    play.setVolume(0,0)
    local video=loadlayout{SurfaceView,
      --添加背景色，避免看不清按键
      --BackgroundColor=0x00ffffff,
      --线性渐变，"TL_BR"为topleft bottomright
      -- backgroundDrawable=gradientDrawable("TL_BR",{0x00FBE0B5,0x00E5EED9,0x00F3F5F8}),--背景色
      --backgroundDrawable=gradientDrawable("TL_BR",{0x99FBE0B5,0x99E5EED9,0x99F3F5F8}),--背景色
      layout_width=-1,
      layout_height=-1
    }
    layout.post{run=function() 
      layout.addView(video,1) --把视频布局放到layout的第一个，也就是显示在最底层
    end}
    video.getHolder().addCallback({
      surfaceCreated=function(holder)
      end,
      surfaceChanged = function(holder, format, width, height) -- surfaceView 布局发生变化时
        play.setDisplay(holder)
        play.start()
        -- 以下延迟根据 剪切板行数、视频、配置等 作参考 性能越好能耗越少 需要的延迟越短
        -- 提前延迟减少 while 的能耗 视频过大可用(指你while到会崩的时候) 不崩还用反而降低速度 也别设太高降低速度只要不崩就行
        -- os.execute("sleep 1")-- 这些延延会直接暂停代码    剪切板的一些功能 会在睡眠(延迟)结束后再运行
        -- 循环至视频播放1毫秒时 防止视频加载闪黑屏和每个人环境不一不通用问题
        while play.getCurrentPosition() <= 1 do
          os.execute("sleep 0.1") --每循环1次暂停0.1秒 减少能耗和防止过多循环崩溃
        end
      end,
      surfaceDestroyed = function()
        -- 释放资源 将这三行代码注释 就能在不退出剪切板的情况下，关闭键盘(即切换应用)再打开时重新加载为视频
        play.stop() --防止退出脚本时 闪黑屏
        play.release()
        video.setZOrderOnTop(true) --把surfaceView的控件布局层级设置为最高，防止上面那个情况下，背景为黑而不是你的键盘背景。
      end})
  end)
end

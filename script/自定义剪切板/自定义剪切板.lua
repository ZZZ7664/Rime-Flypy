--[[

自定义剪切板5.0.9
▂▂▂▂▂▂▂▂
当前版本: 5.0.9
更新日期：2023-08-11
更新作者: 作者不知道该写什么——字面意思 2556814566
更新内容：
        ・新增
          1.剪切板内容滚动淡入淡出，使滚动更加平滑。
          2.批量删除功能
          3.菜单按钮增加渐变且默认圆角更方 建议使用相近色渐变
        ・改动
          1.弃用Spinner控件改写为ListView来高仿Spinner并为其添加动画效果 (BUG只要你的手速够快，在收起动画期间执行展开动画就会导致布局异常。这个BUG日常根本不会触发，又要手速又要连点，除非你想给自己找事，所以懒得修了开摆)
          2.精简布局去除了臃肿横向功能键
          3.将短语板、分词模块示剪切板部分布局功能等统一风格
          4.优化高宽判定，适配多数DPI(部分dpi可能不尽人意，还是建议自己根据设备调整布局高宽)
          5.背景改回默认图片，视频花里胡哨还一堆问题。例举：字体颜色与视频撞色，加遮罩又跟开了护眼似的。
          6.默认禁用[清理]的过长删除
        ・BUG
          1.修复Back()功能键函数生成的圆角的锯齿使其边角更为平滑
          2.修复html特殊字符在列表中生效的BUG如&nbsp会显示为空格而不是字符&nbsp
          3.修复二维码模块不能保存文件，添加刷新MediaStore使其能立即出现于图库内
▂▂▂▂▂▂▂▂
当前版本: V5.0.8
更新日期: 2023-03-28
更新作者: 作者不知道该写什么——字面意思 2556814566
更新内容:
        1.新增功能 百度翻译(长按可选择语言类型) 上屏链接 增加了清理正则。
        2.优化、补全了长按菜单。
        3.增加涟漪动画
        4.增加清空词条防误触(手动吐血表情)
        5.增加多列排版功能开启注释，详搜GridView。
        6.修复一些bug,注释了些重点！如音频焦点、退出闪黑屏等。
        7.(闲话)最主要还是因为bug和重点注释忘标了才更新的原本是打算不更了(实在没什么好更的了),但一想到这恶心人的bug就觉得是发出来对别人不负责……。
        8.常见问题 答疑

          ✪: ꯭小꯭白꯭必꯭看꯭！如果要更换视频背景 且没精力搞第一帧 详搜 main.addView(video, 1)
          ・:现已默认取消，功能是提前入布局不等待视频加裁所以需要第一帧作为背景。

          Q:为什么视频是在进剪切板后卡一下下才播放视频？进入后快速滑动列表滚动又为什么会也卡一下下？
          A:不是卡一下那是视频加载时间只不过提前进入剪切板而已 详情 请搜main.post{run=function() main.addView(video, 1) end}
            ・第二个问题是因为while play.getCurrentPosition() <= 1 do还在延迟到黑屏结束 这期间会阻断其他代码 而你提前进入了剪切板所以会卡

          Q:在剪切板内收起键盘再打开怎么让其 继续播放或停止播放
          A:详搜 -- 释放资源 或者搜 play.stop()

          Q:为何视频背景无声音？
          A:play.setVolume(0,0) -- 视频声音 左声道 右声道 将0改为1即生效

          Q:关于视频背景内存占用回收问题 ✪注以下所说是中文的回收问题，不释放视频背景确实会有内存占用问题，不过不同机型有可能会自动回收所以之前我没测出来。
          A: 其实 这根本不是视频背景问题吧！试半天了 用不用视频背景 一直开关剪切板都会造成垃圾回收失败的问题 不论视频大小平均值都未变化巨大
            ・经过测试，中文本身对lua回收就有问题仅仅只有一行代码的脚本也会造成内存堆积无法释放(PS有时会回收，有时会在堆几次后再回收，有时会……占用1G)
            ・还有更实锤的 不装库 你运行一下别的装了库的脚本 再运行不装库的脚本 照样能跑 但强制停止运行后 再跑就报错了
            ✪建议不定时部署来释放内存或者用其他方法，如系统自带的定时关闭应用程序等等。

          bug:播放视频背景时如果后台的其他应用的音乐声有种调了均衡器了似的声音变的怪怪的 这是编码、解码、音频焦点的问题
           ・解决方法 修改视频为其他兼容硬解不出问题的编码方式 至于你怎么知道这种编码和你系统音码器有没有问题？
           ✪这简单小白无脑用大厂视频剪辑软件选择视频直接导出(不用修改)一下就行了 喜欢折腾的 ffmpeg -i 看编码自己转成对应的
           ・问题原因详见 音频焦点 官方文档 https://developer.android.com/guide/topics/media-apps/audio-focus?hl=zh-cn
           ・(原本写了详细原因结果写太长了影响观感 大致就是 播放视频默认硬件解码兼容不行解码器被音频焦点替换导致音频质量差异......略) 



自定义剪切板5.0.7
▂▂▂▂▂▂▂▂
当前版本: V5.0.7
更新日期: 2023-03-24
更新作者: 作者不知道该写什么——字面意思 2556814566
更新内容:
        1. 重写长按布局
          1.1 可滚动双列菜单 以兼容原功能过多PopMenu单列过于臃肿的问题
          1.2 省略了我不需要的功能 如有需求请自行复制添加 (注意ScrollView容器在子控件超出ScroollView后才能  ꯭通꯭过꯭滑꯭动꯭可꯭触꯭摸꯭的꯭子꯭控꯭件꯭  来滚动ScrollView)
        2. 对点击长按 剪切板的内容 添加高亮颜色提示
        3. 修复了加载慢时 视频闪黑屏的问题 使用视频背景前务必看完视频背景功能的注释
        4. 在脚本内关闭键盘退出脚本回到键盘
           4.1 会销毁视频控件的功能(如退出脚本)前请加 re_lo = false 防止运行功能后退出脚本(如果你在返退出脚本前不加那么就会直接崩溃)
        5. 调整布局简化了无用功能(个人喜好)
        6. 格式化了插件不高亮的代码(插件按写法生成的高亮)



自定义剪切板5.0.6
▂▂▂▂▂▂▂▂
当前版本: V5.0.6
更新日期: 2022-09-10
更新作者: 小浩 3489472862
更新内容: 
         1. 添加剪切板手动清理功能
         2. 修复广播会重复添加的bug
         3. 使用的自动状态栏为1.5版本
         4. 优化依赖脚本判断
         5. 优化标题上剪切板数量的显示
         6. 修改返回主键盘的方法


自定义剪切板5.0.5
▂▂▂▂▂▂▂▂
当前版本: V5.0.5
更新日期: 2022-08-17
更新作者: 小浩 3489472862
更新内容: 
         1. 修复单独复制一个\n,脚本会崩溃的bug
         2. 添加进入剪切板后自动隐藏状态栏的功能
            （需要对应lua包支持，请将自动状态栏.lua放入对应位置）
         3. 删除词条和查看词条中的删除功能会实时写入json文件
         4. 查看词条中的置顶功能会更新系统的剪切板，直接粘贴会变成置顶后内容
         5. 清空词条的时候也会自动恢复状态栏
         6. 剪切板有变化，就会实时刷新
         7. 优化搜索功能的显示
            7.1 关键词会显示在界面中
            7.2 关键词会高亮


自定义剪切板5.0.3
▂▂▂▂▂▂▂▂
当前版本: V5.0.3
更新日期: 2022-06-14
更新作者: 小浩 3489472862
更新内容: 
          1. 修复分词工具无法使用的bug


自定义剪切板5.0.2
▂▂▂▂▂▂▂▂
当前版本: V5.0.2
更新日期: 2022-05-27
更新作者: 小浩 3489472862
更新内容: 
          1. 修复剪切板内容或者搜索结果数量过小时，右边按钮会变小的bug
          2. 重写优化搜索相关功能的代码
          3. 修复剪切板内容框的序号不是由界面控制的bug
          4. 搜索的时候显示的序号修改为其真实序号(会有空位)
          5. 当剪切板内容为空或者搜索结果为空时会有相关提示
          6. 搜索按钮的文字会动态变化
          7. 更新记录不在放在帮助说明内部而采用注释的形式存在
          8. 修复当搜索内容过长时，标题显示不全的问题
          9. 复制和剪切后自动刷新剪切板
          10. 在搜索界面也可以将词条进行置顶删除等操作
          11. 修复🔝置顶词条后还顺便粘贴出原来内容的bug
          

自定义剪切板5.0.1
▂▂▂▂▂▂▂▂
更新时间: 2022年05月13日
更新作者: 小浩 3489472862
更新内容: 
          1. 标题还是添加了版本号，文件名中不添加版本号，
             在更新剪切板时无需再次修改主题
          2. 修复撤销和重做长按也会执行的bug
          3. 更新了布局

自定义剪切板5.0
▂▂▂▂▂▂▂▂
更新时间: 2022年05月12日
更新作者: 小浩 3489472862
更新内容: 
          1. 添加🔝置顶词条
          2. 长按删除键可以连续删除
          3. 长按空格连续输出空格
          4. 默认键盘的键盘名由"K_default"修改为"Keyboard_default"，以修复无法返回主键盘的bug
          5. 注释了单击上屏内容后直接置顶的功能，如果想要取消可搜索
                  --置顶已上屏内容
                -- Clip.remove(p)
                -- Clip.add(0,s)
                -- fresh(Clip)
          6. 将清除功能移到🚮清空词条防止误点击
          7. 将原清除功能改为TAB(并没用显示在按键上)
          8. 修复复制大量内容（网页源码）的时候剪切板打开异常卡顿的bug
          9. 修改剪切板内容文字颜色，修改背景颜色
          10. 剪切板内容序号后面添加了一个空格
          11. 修改整体布局，添加了一些按键（全选，复制，剪切，撤销（长按行首），重做（长按行尾），方向键（支持长按连续））
          12. 添加背景图片功能（同目录下"bg.jpg"的图片），视频背景改为"bg.mp4",
              如果同时存在视频背景和图片背景，优先使用视频背景
          13. 修改键盘名的判定条件，防止返回按钮输出文字而无法返回键盘
          --14. 版本号在文件名中添加了，不再标题中添加版本号，防止重复
          15. 修改了删除词条和分割词条前面的emoji表情
          16. 删除📑复制词条功能，表示不理解有什么用
          17. 添加👀查看词条功能（原来3点几版本的长按预览功能）
          18. 当没有放置视频背景以及图片背景时
              会读取当前主题配色的keyboard_back_color作为剪切板背景
              支持纯色以及图片
              **注意: 
              1. 该功能需要在当前使用的配色里面设置keyboard_back_color
              2. 记得需要重新部署一下
          19. 背景优先级：bg.mp4 > bg.jpg > 主题配色背景色


本次更新: 2021.10.09
By＠合欢∣hehuan.ys168.com
增加生成二维码，增加语音播报，增加一键加词自动编码，增加推送到云端，增加从云端获取(点击剪切板标题获取)，增加分词
优化搜索
版本号: 4.0

无障碍版专用脚本
脚本名称: 自定义剪切板
说明：中文输入法无障碍版原生剪切板优化版,基于 星乂尘_自定义剪切板3.1 修改
增加搜索,优先首选,选中内容
版本号: 3.5
▂▂▂▂▂▂▂▂
日期: 2020年12月08日🗓️
农历: 鼠🐁庚子年十月廿四
时间: 18:26:19🕕
星期: 周二
制作者: 风之漫舞
首发qq群: Rime 同文斋(458845988)
邮箱: bj19490007@163.com(不一定及时看到)


中文输入法脚本
自定义剪切板
原作者： 星乂尘 1416165041@qq.com
2020.09.04



</big><font color=red><b>帮助说明</b></font></big>
--脚本配置说明
<b>用法一</b>
①放到脚本启动器->脚本库目录 下任意位置及子文件夹中,脚本启动器自动显示该脚本
②主题方案挂载脚本启动器
③显示一个键盘界面,
单击上屏文字

--------------------
<b>用法二</b>
第①步 将 脚本文件解压放置 Android/rime/script 文件夹内,
默认脚本路径为Android/rime/script/自定义剪切板/自定义剪切板.lua

第②步 向主题方案中加入按键
以 XXX.trime.yaml主题方案为例
找到以下节点preset_keys,加入以下内容

preset_keys:
  lua_script_cvv: {label: 剪切板, functional: false, send: function, command: "自定义剪切板/自定义剪切板.lua", option: "default"}
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
import "android.content.res.ColorStateList"
import "android.graphics.Color"
import "android.graphics.drawable.GradientDrawable"
import "android.graphics.drawable.RippleDrawable"
import "android.view.animation.*"


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

local 版本号="5.0.6"
local 标题=("")--纯脚本名:sub(1,-5) .. 版本号
local clipMaxNum = Function.getPref(this).getString("clipboard_size", "120")

re_lo = true -- 防止点击返回时视频背景自动返回2次直接崩溃

if File(输入法目录 .. "script/包/键盘操作/功能键.lua").exists() then
  import "script.包.键盘操作.功能键"
end

if File(输入法目录 .. "script/包/键盘操作/自动状态栏.lua").exists() then
  import "script.包.键盘操作.自动状态栏"
end


--用于清空词条
local 文件=tostring(service.getLuaDir("")).."/clipboard.json"

local Clip=service.getClipBoard()

local func_fresh = nil
local func_ss = nil

-- 辅助函数------------开始------------

--长按连续按键
local ButLongclick = (function(key)
  local height = 0
  return {
    onTouch = function(v, e)
      local a = e.getAction()
      if a == 0 then -- 按下
        service.sendEvent(key)
        height = v.getHeight()
      elseif a == 1 then -- 抬指
        ti.stop()
      elseif a == 2 then -- 滑动
        if tick[1] then
          local y = e.getY()
          if e.getX() < 1 or y < 1 or y > height then
            ti.stop()
          end
        end
      end
    end,
    onLongClick = function()
      ti = Ticker()
      ti.Period = 80
      ti.onTick = function()
        service.sendEvent(key)
      end
      ti.start()
      return true
    end
  }
end)


--转为整数
local function toint(n)
  local s = tostring(n)
  local i, j = s:find('%.')
  if i then
    return tonumber(s:sub(1, i-1))
  else
    return n
  end
end

--导入模块
function 导入模块(模块,内容)
   dofile_信息表=nil
   dofile_信息表={}
   dofile_信息表.上级脚本=脚本路径
   dofile_信息表.上级脚本所在目录=目录
   dofile_信息表.上级脚本相对路径=脚本相对路径
   dofile_信息表.纯脚本名= 纯脚本名:sub(1,-5)
   dofile_信息表.内容=内容
   dofile(目录..模块)--导入模块
end

function rippleDrawable(color)
  import"android.content.res.ColorStateList"
  return activity.Resources.getDrawable(activity.obtainStyledAttributes({android.R.attr.selectableItemBackground--[[Borderless]]}).getResourceId(0,0)).setColor(ColorStateList(int[0].class{int{}},int{color or 0x20000000}))
end

--线性渐变
function gradientDrawable(orientation,colors)
  import"android.graphics.drawable.GradientDrawable"
  return GradientDrawable(GradientDrawable.Orientation[orientation],colors)
end

--注册剪切板添加广播
import "android.content.BroadcastReceiver"
import "android.content.IntentFilter"
import "com.androlua.LuaBroadcastReceiver"
function 剪切板添加广播()
  br=LuaBroadcastReceiver(LuaBroadcastReceiver.OnReceiveListener{
    onReceive=function(context, intent)
      if intent.getAction()=="com.nirenr.talkman.ACTION_ADD_CLIPBOARD" then
        if intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~="" or intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~=nil then
          func_fresh()
        end --intent.getStringExtra
      end --intent.getAction
    end --function(conte
  })
  --动态注册广播接收者
  filter=IntentFilter()
  filter.addAction("com.nirenr.talkman.ACTION_ADD_CLIPBOARD")
  filter.setPriority(Integer.MAX_VALUE)
  --开启广播接收
  service.registerReceiver(br,filter)
  全_br = true
end
  
--清理剪切板
local function clipClean()
  -- print("clip clean...")
  local 清理正则组={
--  "^http%S*$", -- 清理纯链接
    "第%d+段%s速度.*击键", -- 清理练习成绩
    "第%d+段%-余%d+字", -- 清理发文
--    "^$[a-z].*[0-9].*$$", -- 清理某贴吧厕所
--    "^2233 h%S*$", -- 清理某2233站
--    "[a-z:/]*[a-z].kuaishou.*", -- 清理某手
  }
  local zs = 0
  --倒序循环
  for i=#Clip-1, 0, -1 do
    --过长删除
    -- if #Clip[i] > 1000 then
    --   zs = zs + 1
    --   Clip.remove(i)
    -- end

    -- 正则清理
    for j=1, #清理正则组 do
      if string.find(Clip[i], 清理正则组[j]) ~= nil then
        zs = zs + 1
        Clip.remove(i)
      end
    end
  end
  print("共清理" .. zs .. "条数据")
  func_fresh()
end


-- 辅助函数------------结束------------

-- 字体设置------------开始------------

local vibeFont=Typeface.DEFAULT
local 字体文件 = tostring(service.getLuaDir("")).."/fonts/牛码飞机手机5代超集宋体.ttf"
if File(字体文件).exists()==true then
  vibeFont=Typeface.createFromFile(字体文件)
end--if File(字体文件)

-- 字体设置------------结束------------


-- 自动背景颜色和背景图片------------开始------------

local 背景颜色 = nil
--图片路径
local bgpic_path=目录.."bg.jpg"
local 当前配色ID=Config.get().getColorScheme()
local 当前配色背景 = yaml组["preset_color_schemes"][当前配色ID]["keyboard_back_color"]
local 当前配色背景颜色 = toint(当前配色背景)

if 当前配色背景颜色 ~= nil then
    背景颜色 = "0x" .. BigInteger(tostring(当前配色背景颜色), 10).toString(16)
elseif 当前配色背景 ~= nil and not File(bgpic_path).isFile() then
    bgpic_path = 输入法目录 .. "backgrounds/" .. 当前配色背景 -- 是背景图片
end

-- 自动背景颜色和背景图片------------结束------------


-- 搜索功能------------开始------------
-- 优先级
-- 参数 >> 状态栏 >> 选中文本 >> 上次上屏
-- 这里不考虑启动参数
local 预搜索内容 = ""
local isSearch = false
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
-- getSearchStr()
if 预搜索内容 ~= "" and 预搜索内容 ~= nil then
    isSearch = true
end
-- 搜索功能------------结束------------



local num = 0 --当前选择的序号
local str = "" --当前选择的内容
local arrNo={} --内容序号数组，里面保存Clip的位置序号
local function getNumStr(p)
  num = arrNo[p+1]
  str = Clip[num]
end


-- 生成功能键背景
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

-- 涟漪动画功能键
local function create_ripp(noColor,prColor,radius,grColor)
    local rippleColor = prColor or 0xFF0000FF  -- 默认 按下 状态颜色
    local defaultColor = noColor or 0xFFFFFFFF -- 默认 未按下 状态颜色
    if radius == nil then
        radius = 30
    end
    if grColor == nil then
        grColor = defaultColor
    end
    -- 定义四种状态颜色
    local states = {
        {android.R.attr.state_pressed},   -- 按下
        {android.R.attr.state_focused},   -- 焦点
        {android.R.attr.state_activated}, -- 高亮
        {} --默认
    }
    local stateColorList = {
        rippleColor, -- 涟漪颜色 状态对应states
        rippleColor,
        rippleColor,
        defaultColor -- 默认颜色
    }

    -- 创建ColorStateList对象
    local colorStateList = ColorStateList(states, stateColorList)

    -- 创建RippleDrawable对象
    local mask = GradientDrawable()
    mask.setColor(0xFFFFFFFF)
    mask.setStroke(2, rippleColor)
    mask.setCornerRadius(radius) -- 动画圆角 设置圆角半径为极大值，使其变成圆形

    local contentDrawable = GradientDrawable()
    local colors = {grColor, defaultColor} -- 渐变色
    contentDrawable.setColors(colors) -- 设置渐变色
    -- contentDrawable.setGradientType(GradientDrawable.LINEAR_GRADIENT) -- 设置渐变类型为线性渐变
    -- contentDrawable.setOrientation(GradientDrawable.Orientation.LEFT_RIGHT) -- 设置渐变方向为从左至右
    contentDrawable.setCornerRadius(radius) -- 默认状态圆角 设置圆角半径为极大值，使其变成圆形

    local rippleDrawable = RippleDrawable(colorStateList, contentDrawable, mask)
    return rippleDrawable
end


--获取k功能图标，没有则返回s
local function Icon(k,s) 
  k=Key.presetKeys[k]
  return k and k.label or s
end

-- 生成功能键

local function Bu_R(id)
  local ta = {
    TextView,
    gravity = 17,
    background = Back(0x49d3d7da, 0x49ffffff),
    layout_height = -1,
    layout_width = -1,
    layout_weight = 1,
    layout_margin = "1dp",
    layout_marginTop = "2dp",
    layout_marginBottom = "2dp",
    textColor = 0xFFFFFFFF,
    -- textColor = 0xff232323,
    textSize = "18dp"
  }

  if id == 1 then
    ta.text = Icon("BackSpace", "⌫")
    ta.textSize = "18dp" -- 字体大小设置为22dp
    ta.onTouchListener = ButLongclick("BackSpace")
    ta.onLongClickListener = ButLongclick("BackSpace")
  elseif id == 2 then
    ta.text = "空格"
    ta.textSize = "18dp"
    ta.onTouchListener = ButLongclick("space")
    ta.onLongClickListener = ButLongclick("space")
  elseif id == 3 then
    ta.text = Icon("Return", "⏎")
    ta.textSize = "18dp"
    ta.onClick = function()
      service.sendEvent("Return")
    end
    ta.onLongClickListener = { onLongClick = function() return true end }
  elseif id == 4 then
    ta.text = Icon("返回", "返回")
    ta.onClick = function()
      re_lo = false -- 防止点击返回时视频背景自动返回2次直接崩溃
      service.setKeyboard(".default")
      pcall(function()
        -- pcall里防报错
        恢复状态栏()
      end)
    end
    ta.onLongClickListener = {
      onLongClick = function()
        service.setKeyboard(".default")
        pcall(function()
          -- pcall里防报错
          恢复状态栏()
        end)
        return true
      end
    }
  elseif id == 5 then
    ta.text = Icon("Tab", "Tab")
    ta.textSize = "18dp"
    ta.onClick = function()
      service.sendEvent("Tab")
    end
    ta.onLongClickListener = { onLongClick = function() return true end }
  elseif id == 6 then
    ta.text = "帮助"
    ta.onClick = function()
      导入模块("帮助模块.text", 帮助内容)
    end
    ta.onLongClickListener = { onLongClick = function() return true end }
  elseif id == 7 then
    ta.text = Icon("全选", "全选")
    ta.textSize = "18dp"
    ta.onClick = function()
      if 功能_全选 ~= nil then
        功能_全选()
      else
        print('【全选】功能需要"功能键.lua"的支持！请确保"script/包/键盘操作/功能键.lua]文件存在"')
      end
    end
  elseif id == 8 then
    ta.text = Icon("复制", "复制")
    ta.textSize = "18dp"
    ta.onClick = function()
      if 功能_复制 ~= nil then
        功能_复制()
      else
        print('【复制】功能需要"功能键.lua"的支持！请确保"script/包/键盘操作/功能键.lua]文件存在"')
      end
      -- 必须要有延时
      -- task(80,function func_fresh() end)
    end
  elseif id == 9 then
    ta.text = Icon("剪切", "剪切")
    ta.textSize = "18dp"
    ta.onClick = function()
      if 功能_剪切 ~= nil then
        功能_剪切()
      else
        print('【剪切】功能需要"功能键.lua"的支持！请确保"script/包/键盘操作/功能键.lua]文件存在"')
      end
      -- 必须要有延时
      -- task(80,function func_fresh() end)
    end
  elseif id == 10 then
    ta.id = "ss" -- ss: 搜索
    if isSearch then
      ta.text = Icon("全部", "全部")
    else
      ta.text = Icon("搜索", "搜索")
    end
    ta.textSize = "18dp"
    ta.onClick = function()
      if isSearch then
        isSearch = false
        func_ss("搜索")
      else
        isSearch = true
        func_ss("全部")
      end
      getSearchStr()
      func_fresh()
    end
  elseif id == 11 then
    ta.text = Icon("短语", "短语")
    ta.textSize = "18dp"
    ta.onClick = function()
      if 功能_脚本 ~= nil then
        功能_脚本(脚本相对目录.."自定义短语板.lua", "剪切板")
      else
        print('【脚本】功能需要"功能键.lua"的支持！请确保"script/包/键盘操作/功能键.lua]文件存在"')
      end
    end
  elseif id == 12 then
    ta.text = Icon("撤销", "撤销")
    ta.textSize = "18dp"
    ta.onClick = function()
      service.sendEvent("undo")
    end
    ta.onLongClickListener = {
      onLongClick = function()
        -- 长按行首
        service.sendEvent("Home")
        return true
      end
    }
  elseif id == 13 then
    ta.text = Icon("重做", "重做")
    ta.textSize = "18dp"
    ta.onClick = function()
      service.sendEvent("redo")
    end
    ta.onLongClickListener = {
      onLongClick = function()
        -- 长按行尾
        service.sendEvent("End")
        return true
      end
    }
  elseif id == 14 then
    ta.text = "←"
    ta.textSize = "18dp"
    ta.onTouchListener = ButLongclick("Left")
    ta.onLongClickListener = ButLongclick("Left")
  elseif id == 15 then
    ta.text = "↓"
    ta.textSize = "18dp"
    ta.onTouchListener = ButLongclick("Down")
    ta.onLongClickListener = ButLongclick("Down")
  elseif id == 16 then
    ta.text = "↑"
    ta.textSize = "18dp"
    ta.onTouchListener = ButLongclick("Up")
    ta.onLongClickListener = ButLongclick("Up")
  elseif id == 17 then
    ta.text = "→"
    ta.textSize = "18dp"
    ta.onTouchListener = ButLongclick("Right")
    ta.onLongClickListener = ButLongclick("Right")
  elseif id == 18 then
    ta.text = "清理"
    ta.textSize = "18dp"
    ta.onClick = function()
      clipClean()
    end
    ta.onLongClickListener = { onLongClick = function() return true end }
  end
  return ta
end


local 默认高度 = service.getLastKeyboardHeight()
if 默认高度 < 300 then 
    默认高度 = 300 
end


-- 主界面布局
local ids, layout = {}, {
  FrameLayout,
  -- 键盘高度
  layout_height = 默认高度,
  layout_width = -1,
  -- 背景颜色
  BackgroundColor = 背景颜色,
  {
    TextView,
    id = "title",
    layout_height = "20dp",
    layout_width = -1,
    text = "•帮助说明",
    textColor = "#FFFFFFFF",
    gravity = "center",
    paddingLeft = "2dp",
    paddingRight = "2dp",
    singleLine = "true",
    -- BackgroundColor = 0x49d3d7da,
  },
  {
    LinearLayout,
    orientation = 0, -- 水平布局
    layout_height = -1,
    {
      LinearLayout,
      orientation = 1, -- 垂直布局
      layout_weight = 1,
      layout_height = -1,
      {
        LinearLayout,
        layout_marginTop = "20dp", -- 和标题高度相等
        orientation = 0, -- 水平布局
        layout_width = -1,
        layout_height = "0dp",
        -- layout_height = "39dp",
        -- 若要使用其下按键请设置height的高度
        -- Bu_R(4),
        -- Bu_R(7),
        -- Bu_R(9),
        -- Bu_R(8),
        -- Bu_R(12),
        -- Bu_R(14),
        -- Bu_R(15),
        -- Bu_R(16),
        -- Bu_R(17),
      },
      {
        ListView, -- 改为GridView可设置多列排版 记得改TV_b的MinHeight推荐60dp
        id = "list",
        -- NumColumns=2, -- 列数 控件改为GridView时生效
        -- layout_marginTop="59dp", -- 和标题高度相等
        -- DividerHeight=0,  -- 无分割线
        layout_width = -1,
        layout_weight = 1,
      },
    },
    {
      LinearLayout,
      -- layout_marginTop="59dp", -- 和标题高度相等
      layout_marginTop = "20dp", -- 和标题高度相等
      orientation = 1,
      layout_weight = 1,
      layout_width = "130dp",
      layout_height = -1,
      layout_gravity = 5 | 84,
      -- Bu_R(11),
      Bu_R(4),
      Bu_R(18),
      Bu_R(10),
      Bu_R(3),
      Bu_R(1),
    },
  },
}

main=loadlayout(layout,ids)

--剪切板内容框
local data,item={},{LinearLayout,
  layout_width=-1,
  id = "TV_z",
  padding="4dp",
  gravity=3|17,
  {TextView,
    id="TV_a",
    textColor=0xFF6282D2,
    textSize="17dp"
  },
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
    textSize="15dp"
  }
}


local adp=LuaAdapter(service,data,item)
ids.list.Adapter=adp

local function fresh()
  -- print("fresh")
  table.clear(data)
  table.clear(arrNo)

  local 正则式 = ""
  if isSearch then
    for i = 0, #Clip - 1 do
      local m = utf8.find(Clip[i], 预搜索内容)
      if m ~= nil then
        table.insert(arrNo, i)
      end
    end
    ids.title.setText(标题 .. "(搜索到" .. #arrNo .. "条) \"" .. 预搜索内容 .. "\" 相关内容")
    正则式 = "(\n*[^\n]*)([^\n]*" .. 预搜索内容 .. "[^\n]*)(\n*[^\n]*)"
  else
    for i = 0, #Clip - 1 do
      arrNo[i + 1] = i
    end
    ids.title.setText(标题 .. "(" .. #arrNo .. "/" .. clipMaxNum .. ")")
    正则式 = "(\n*[^\n]*)(\n*[^\n]*)(\n*[^\n]*)"
  end

  for i = 1, #arrNo do
    local v = Clip[arrNo[i]]
    local a, b, c = v:match(正则式)
    a = table.concat{utf8.sub(a or "", 1, 99), utf8.sub(b or "", 1, 99), utf8.sub(c or "", 1, 99)}
    a = string.gsub(a, "\n", "<br>")
    -- & 后面跟了个u200B 零宽空格字符 以防止html识别其为特殊字符 如&nbsp; 空格
    a = string.gsub(a, "&", "&​")
    if isSearch then
      a = string.gsub(a, 预搜索内容, "<font color=#00ff00>" .. 预搜索内容 .. "</font>")
    end
    table.insert(data, {TV_a = Html.fromHtml("</big><font><b>" .. tostring(arrNo[i] + 1) .. ". </b></font></big>"), TV_b = Html.fromHtml(a), TV_z={background=Back(0x00,0x79DBDBDB,0)}})
  end

  if #arrNo == 0 then
    if isSearch then
      table.insert(data, {TV_a = Html.fromHtml("</big><font><b>" .. tostring(1) .. ". </b></font></big>"), TV_b = Html.fromHtml("未搜索到【" .. "<font color=#00ff00>" .. 预搜索内容 .. "</font>" .. "】相关内容")})
    else
      table.insert(data, {TV_a = Html.fromHtml("</big><font><b>" .. tostring(1) .. ". </b></font></big>"), TV_b = Html.fromHtml("剪切板中无内容！")})
    end
  end

  adp.notifyDataSetChanged()
  func_ss = ids.ss.setText -- 刷新以后id会重置
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

-- 批量删除索引列表
local batch_index = {}
-- 元素当前状态列表
local attributeStates = {}
-- 批量删除开关变量
local batch_removal = nil


-- 列表点击事件
ids.list.onItemClick = function(l, v, p)
  if batch_removal then
    local index = p + 1
    if attributeStates[index] == nil or attributeStates[index] == "original" then
      -- 当前属性为原始状态，修改为新状态
      data[index].TV_z.background = Back(0x79DBDBDB, 0x79DBDBDB,0) -- 将TV_z的背景颜色更改
      attributeStates[index] = "modified"
      table.insert(batch_index, p)
    else
      -- 当前属性为新状态，恢复为原始状态
      data[index].TV_z.background = Back(0x00,0x79DBDBDB,0) -- 恢复TV_z的原始背景颜色
      attributeStates[index] = "original"
      -- 检查元素是否已存在于表中
      local table_index = nil
      for i, value in ipairs(batch_index) do
        if value == p then
          table_index = i
          break
        end
      end
      -- 如果元素已存在，则从表中删除
      if table_index then
        table.remove(batch_index, table_index)
      end
    end
    adp.notifyDataSetChanged()
  else
    getNumStr(p)
    service.commitText(str)
  end
end




-- 长按菜单功能键
local function Bu_L(id)
  local but = {
  Button,
  textSize="12",
  layout_width="match_parent",
  layout_height="wrap_content",
  textColor=0xFFFFFFFF,
  -- 传入的分别是 默认颜色 高亮颜色 圆角 渐变颜色 不需要渐变可设置为nil
  Background=create_ripp(0xFF526FFF,0xFFF3603C,10,0xFF8099FF),
  layout_marginTop="5dp",
  layout_marginBottom="5dp",
  layout_marginLeft="5dp",
  layout_marginRight="5dp",
  }
-- 请将onClick功能写进长按菜单函数内 不然无上下文main.removeView(menu)无法移除布局
  if id == 1 then
    but.text = "置顶"
    but.id = "but_1"
  elseif id == 2 then
    but.text = "查看"
    but.id = "but_2"
  elseif id == 3 then
    but.text = "删除"
    but.id = "but_3"
  elseif id == 4 then
    but.text = "分词"
    but.id = "but_4"
  elseif id == 5 then
    but.text = "添加短语"
    but.id = "but_5"
  elseif id == 6 then 
    but.text = "二维码"
    but.id = "but_6"
  elseif id == 7 then
    but.text = "百度翻译\n[长按设置]"
    but.id = "but_7"
  elseif id == 8 then
    but.text = "一键加词\n[需配置]"
    but.id = "but_8"
  elseif id == 9 then
    but.text = "清空词条\n[请长按]"
    but.id = "but_9"
  elseif id == 10 then
    but.text = "语音播报"
    but.id = "but_10"
  elseif id == 11 then
    but.text = "上屏链接[中英]\n长按[英]"
    but.id = "but_11"
  elseif id == 12 then
    but.text = "批量删除\n[长按删除]"
    but.id = "but_12"
  elseif id == 13 then
    but.text = "空"
    but.id = "but_13"
  end
  return but
end



local 源语言=("auto")
local 目标语言=("auto")

function ara_sel(str)
    local table = {["自动检测"]="auto", ["中文"]="zh", ["英文"]="en", ["日文"]="jp", ["韩文"]="kor", ["泰文"]="th", ["俄文"]="ru", ["德文"]="fra", ["法文"]="de",["中文繁体"]="cht"}
    return table[str]
end


local fo_num = 0 -- 源语言默认选择
local ed_num = 2 -- 目标语言默认选择


-- Spinner下拉框内容 现已弃用
-- 注: Spinner不支持修改下拉框高度即dropDownHeight 所有选项将一次性展开 可能顶出剪切板外
function setAdap(idd)
local items = {"自动检测","中文","英文","日文","韩文","泰文","俄文","德文","法文","中文繁体"}
local txtview = {
  TextView,
  layout_width="match_parent",
  layout_height="wrap_content",
  textColor="#FF0A59F7",
  padding="5dp", -- 下拉框选项边距
  gravity="center",
  textSize="10sp",
  }
  local adap = LuaArrayAdapter(this,txtview)
  for i,n in pairs(items) do -- 将items循环添加至适配器
    adap.add(n)
  end
  idd.setAdapter(adap)
end

b_ed_text = nil -- 源语言标题
b_fo_text = nil -- 目标语言标题
data_ed_index = nil -- 源语言item索引
data_fo_index = nil -- 目标语言item索引

-- 新长按菜单布局
ids.list.onItemLongClick=function(l,v,p)
  local container = {
    FrameLayout,
    id = "mask",
    layout_width="match_parent",
    layout_height="match_parent",
    BackgroundColor="#49000000",
    {
      ScrollView,
      layout_width="wrap_content",
      layout_height="200dp",
      layout_gravity="center",
      Background=Back(0xFFFFFFFF,0xFFFFFFFF),
      {
        LinearLayout,-- 水平线性布局排列2个子垂直线性布局
        orientation="horizontal",
        layout_width="match_parent",
        layout_height="wrap_content",
        {
          LinearLayout,
          orientation="vertical",
          layout_width="0dp",
          layout_height="wrap_content",
          layout_weight="1", -- 占据一半宽度
          Bu_L(1),
          Bu_L(3),
          Bu_L(5),
          Bu_L(7),
          Bu_L(9),
          Bu_L(11),
          -- Bu_L(13),
        },
        {
          LinearLayout,
          orientation="vertical",
          layout_width="0dp",
          layout_height="wrap_content",
          layout_weight="1", -- 占据一半宽度
          Bu_L(2),
          Bu_L(4),
          Bu_L(6),
          Bu_L(12),
          Bu_L(8),
          Bu_L(10),
        },
      },
    },
  }
  local menu = loadlayout(container)

  getNumStr(p)

  mask.onClick = function()
    main.removeView(menu) -- 移除 菜单布局
  end

  but_1.onClick = function()
    Clip.remove(num)
    Clip.add(0,str)
    service.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
    fresh() -- 监听了剪切板事件，自动会刷
    main.removeView(menu)
  end

  but_2.onClick = function()
    local lay={TextView,
      padding="16dp",
      MaxLines=20,
      textIsSelectable=true,
      text=str,
      textColor=0xff232323,
      textSize="15dp"}
    LuaDialog(service)
    .setTitle(string.format("%s.  预览/操作（%s）",num+1,utf8.len(str)))
    .setView(loadlayout(lay))
    .setButton("置顶",function()
      if p>0 then
        Clip.remove(num)
        Clip.add(0,str)
        service.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
        --fresh() 监听了剪切板事件，自动会刷新
      end
    end)
    .setButton2("删除",function()
      Clip.remove(num)
      fresh()
      JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
    end)
    .setButton3("取消",function()
      dialog.dismiss()
    end)
    .show()
    main.removeView(menu)
  end

  but_3.onClick = function()
    Clip.remove(num)
    fresh()
    JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
    main.removeView(menu)
  end

  but_4.onClick = function()
    re_lo = false --防止 视频销毁后退出脚本
    导入模块("分词工具.text",str)
  end

  but_5.onClick = function()
    print(str.."添加成功")
    local Phrase=service.getPhrase()
    Phrase.add(0,str)
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
    io.open(输入法目录.."phrase.json","w"):write(Phrase_nr):close()
    main.removeView(menu)
  end

  but_6.onClick = function()
    re_lo = false  --防止 视频销毁后退出脚本
    导入模块("二维码制作.text",str)
  end

  but_7.onClick = function()
    local url_tra="https://api.gmit.vip/Api/Translate?format=json&text="..str.."&from="..源语言.."&to="..目标语言
    Http.get(url_tra,function(a,b)
     if a==200 then
       json=import"cjson"
       local 翻译内容=json.decode(b)["data"]["result"]
       service.commitText(翻译内容)
     end
    end)
  end

  but_7.onLongClick = function()
    if b_fo_text == nil then
      b_fo_text = "自动检测"
    end
    if b_ed_text == nil then
      b_ed_text = "中文"
    end
    local tra_set = {
      FrameLayout,
      id = "tra_mask",
      layout_width="match_parent",
      layout_height="match_parent",
      BackgroundColor="#49000000",
      {CardView,
        layout_width="fill",
        layout_height="40dp",
        layout_margin="2dp",
        radius="2dp",
        {
          LinearLayout,
          layout_width="fill",
          layout_height="40dp",
          orientation="horizontal",
          {
            Button,
            layout_width="0dp",
            layout_height="fill",
            id="b_tra_fo",
            text=b_fo_text,
            background=create_ripp(),
            layout_weight=1,
            layout_marginTop="5dp",
            layout_marginBottom="5dp",
            layout_marginLeft="5dp",
            layout_marginRight="5dp",
          },
          {
            Button,
            layout_width="0dp",
            layout_height="fill",
            id="b_tra_ed",
            text=b_ed_text,
            background=create_ripp(),
            layout_weight=1,
            layout_marginTop="5dp",
            layout_marginBottom="5dp",
            layout_marginLeft="5dp",
            layout_marginRight="5dp",
          },

          -- { -- 旧版语言选择方式 若要使用请注释上方Button控件并取消有关Spinner的注释
          --   Spinner,
          --   id="tra_fo",
          --   layout_width="0dp",
          --   layout_height="fill",
          --   background=create_ripp(), -- 重写背景隐藏倒三角
          --   layout_weight=1,
          --   layout_marginTop="5dp",
          --   layout_marginBottom="5dp",
          --   layout_marginLeft="5dp",
          --   layout_marginRight="5dp",
          -- },
          -- {
          --   Spinner,
          --   id="tra_ed",
          --   layout_width="0dp",
          --   layout_height="fill",
          --   background=create_ripp(), -- 重写背景隐藏倒三角
          --   layout_weight=1,
          --   layout_marginTop="5dp",
          --   layout_marginBottom="5dp",
          --   layout_marginLeft="5dp",
          --   layout_marginRight="5dp",
          -- },
        },
      },
    }
    local tra_set_view = loadlayout(tra_set)

    -- setAdap(tra_fo)
    -- setAdap(tra_ed)
    -- tra_fo.setSelection(fo_num) --设置的适配器默认选项
    -- tra_ed.setSelection(ed_num)

    -- tra_fo.onItemSelected=function(l,v,p,i)
    --   源语言 = ara_sel(v.Text) -- 获取选项文本 v指选择的选项 ara_sel函数是通过文本判断返回值
    --   fo_num = p -- 获取选项位置 记录选项 p选择的位置 i索引
    -- end

    -- tra_ed.onItemSelected=function(l,v,p,i)
    --   目标语言 = ara_sel(v.Text)
    --   ed_num = p
    -- end

    tra_mask.onClick = function()
      main.removeView(tra_set_view)
    end
    -- lua局部变量仅限于块中 else的分支属于另一块无法获取变量 所以写在函数外
    local lang_fo = {
      FrameLayout,
      id = "mask_fo",
      layout_width = "match_parent",
      layout_height = "match_parent",
      BackgroundColor = "#00000000",
      {
        LinearLayout,
        layout_marginTop = "45dp",
        layout_marginLeft = "66px",
        {
          ListView,
          id = "list_fo",
          layout_width = "415px", -- 修改后请将其父控件的layout_marginLeft一起修改
          layout_height = 默认高度/1.4,
          background = Back(0xFFFFFFFF,0xFFFFFFFF,35),
          DividerHeight=0,
        },
      },
    }
    local demo_set_view = loadlayout(lang_fo)
    local data_fo = {}
    local item_fo = {
      LinearLayout,
      layout_width = "match_parent",
      id = "custom_layout_fo",
      gravity = "center",
      orientation = "vertical",
      {
        TextView,
        id = "custom_text_fo",
        textColor = 0xFF6282D2,
        textSize = "17dp",
        padding = "4dp",
      },
      {
        View,
        id = "divider", -- 高仿分割线 ListView不支持修改分割线颜色
        layout_width = "310px", -- 包括item内容宽度
        -- layout_height = "0dp", -- 为0dp不启用
        layout_height = "1px",
      },
    }

    local adpat = LuaAdapter(service, data_fo, item_fo)
    list_fo.Adapter = adpat

    local items_demo = {"自动检测", "中文", "英文", "日文", "韩文", "泰文", "俄文", "德文", "法文", "中文繁体"}

    for i = 1, #items_demo do
      local itemData = {
        custom_layout_fo = { background = Back(0x00,0x79DBDBDB,35) },
        custom_text_fo = {Text = items_demo[i]},
        divider = { backgroundColor = 0xFFB3B3B3 },
      }
      table.insert(data_fo, itemData)
    end

    if data_fo_index == nil then
      data_fo_index = 1
    end
    -- 默认长亮与默认选项挂勾
    data_fo[data_fo_index].custom_layout_fo.background = Back(0xFFCBE6FC,0xFFCBE6FC,35)
    -- 去除最后一条多余的分割线
    data_fo[#data_fo].divider.backgroundColor = 0x00
    adpat.notifyDataSetChanged()

    -- 添加展开动画
    function addExpandAnimation(view)
      -- 测量布局高度 防止第一次执行时获取不到高度
      view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
      -- 获取高度
      local height = view.getMeasuredHeight()
      -- 参数 1. 起始X坐标 2. 结束X坐标 3. 起始Y坐标 4. 结束Y坐标
      local animation = TranslateAnimation(0, 0, -height, 0)
      animation.duration = 100 -- 动画时长
      view.startAnimation(animation)
    end

    -- 添加收起动画
    function addCollapseAnimation(view)
      view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED)
      local height = view.getMeasuredHeight()
      local animation = TranslateAnimation(0, 0, 0, -height)
      animation.duration = 100 -- 动画时长
      view.startAnimation(animation)
    end

    local isViewVisible = false
    b_tra_fo.onClick = function()
      mask_fo.onClick = function()
        addCollapseAnimation(demo_set_view)
        tra_set_view.removeView(demo_set_view)
        isViewVisible = false
      end

      if isViewVisible then
        addCollapseAnimation(demo_set_view)
        tra_set_view.removeView(demo_set_view)
      else
        addExpandAnimation(demo_set_view)
        tra_set_view.addView(demo_set_view)
      end
      isViewVisible = not isViewVisible
      return true
    end
    -- lua局部变量仅限于块中 else的分支属于另一块无法获取变量 所以写在函数外
    local lang_ed = {
      FrameLayout,
      id = "mask_ed",
      layout_width = "match_parent",
      layout_height = "match_parent",
      BackgroundColor = "#00000000",
      {
        LinearLayout,
        layout_marginTop = "45dp",
        layout_marginLeft = "600px",
        {
          ListView,
          id = "list_ed",
          layout_width = "415px", -- 修改后请将其父控件的layout_marginLeft一起修改
          layout_height = 默认高度/1.4,
          background = Back(0xFFFFFFFF,0xFFFFFFFF,35),
          DividerHeight=0,
        },
      },
    }
    local demo_set_view_2 = loadlayout(lang_ed)
    local data_ed = {}
    local item_ed = {
      LinearLayout,
      layout_width = "match_parent",
      id = "custom_layout_ed",
      gravity = "center",
      orientation = "vertical",
      {
        TextView,
        id = "custom_text_ed",
        textColor = 0xFF6282D2,
        textSize = "17dp",
        padding = "4dp",
      },
      {
        View,
        id = "divider", -- 高仿分割线 ListView不支持修改分割线颜色
        layout_width = "310px", -- 包括item内容宽度
        -- layout_height = "0dp", -- 为0dp不启用
        layout_height = "1px",
      },
    }

    local adpate = LuaAdapter(service, data_ed, item_ed)
    list_ed.Adapter = adpate

    for i = 1, #items_demo do
      local itemData = {
        custom_layout_ed = { background = Back(0x00,0x79DBDBDB,35) },
        custom_text_ed = {Text = items_demo[i]},
        divider = { backgroundColor = 0xFFB3B3B3 },
      }
      table.insert(data_ed, itemData)
    end

    if data_ed_index == nil then
      data_ed_index = 2
    end
    -- 默认长亮与默认选项挂勾
    data_ed[data_ed_index].custom_layout_ed.background = Back(0xFFCBE6FC,0xFFCBE6FC,35)
    -- 去除最后一条多余的分割线
    data_ed[#data_ed].divider.backgroundColor = 0x00
    adpate.notifyDataSetChanged()

    local isViewVisible_2 = false
    b_tra_ed.onClick = function()
      mask_ed.onClick = function()
        addCollapseAnimation(demo_set_view_2)
        tra_set_view.removeView(demo_set_view_2)
        isViewVisible_2 = false
      end

      if isViewVisible_2 then
        addCollapseAnimation(demo_set_view_2)
        tra_set_view.removeView(demo_set_view_2)
      else
        addExpandAnimation(demo_set_view_2)
        tra_set_view.addView(demo_set_view_2)
      end
      isViewVisible_2 = not isViewVisible_2
      return true
    end

    -- 源語言列表点击事件
    list_fo.onItemClick = function(l, v, p)
      -- 获取选择的内容的文本
      local selectedItem = data_fo[p+1].custom_text_fo.Text
      源语言 = ara_sel(selectedItem)
      b_tra_fo.setText(selectedItem) -- 将选择的内容设置为按钮文本
      b_fo_text = selectedItem -- 记录文本防止退出选项后文本重置
      -- 取消上次选择的长亮
      if data_fo_index ~= nil then
        data_fo[data_fo_index].custom_layout_fo.background = Back(0x00,0x00,35)
      end
      data_fo_index = p+1
      -- 长亮选择
      data_fo[data_fo_index].custom_layout_fo.background = Back(0xFFCBE6FC,0xFFCBE6FC,35)
      adpat.notifyDataSetChanged()
      addCollapseAnimation(demo_set_view) -- 收起动画
      tra_set_view.removeView(demo_set_view) -- 移除布局
      isViewVisible = false
    end

    -- 目标语言点击事件
    list_ed.onItemClick = function(l, v, p)
      -- 获取选择的内容的文本
      local selectedItem = data_ed[p+1].custom_text_ed.Text
      目标语言 = ara_sel(selectedItem)
      b_tra_ed.setText(selectedItem) -- 将选择的内容设置为按钮文本
      b_ed_text = selectedItem -- 记录文本防止退出选项后文本重置
      -- 取消上次选择的长亮
      if data_ed_index ~= nil then
        data_ed[data_ed_index].custom_layout_ed.background = Back(0x00,0x00,35)
      end
      data_ed_index = p+1
      -- 长亮选择
      data_ed[data_ed_index].custom_layout_ed.background = Back(0xFFCBE6FC,0xFFCBE6FC,35)
      adpate.notifyDataSetChanged()
      addCollapseAnimation(demo_set_view_2) -- 收起动画
      tra_set_view.removeView(demo_set_view_2) -- 移除布局
      isViewVisible_2 = false
    end

    main.addView(tra_set_view)
    return true
  end

  but_8.onClick = function()
    导入模块("一键加词自动编码(定长).text",str)
    main.removeView(menu)
  end
  
  but_9.onLongClick = function()
    local whether={TextView,
      padding="16dp",
      MaxLines=20,
      textIsSelectable=true,
      text="执行功能后剪切板所有内容将被清空！请三思！",
      textColor=0xff232323,
      textSize="15dp"}
    LuaDialog(service)
    .setTitle(string.format("你确定要清空剪切板吗？"))
    .setView(loadlayout(whether))
    .setButton("确定",function()
      pcall(function()
      --pcall里防报错
        恢复状态栏()
      end)
      io.open(文件,"w"):write("[\n]"):close()
      local 输入法实例=Trime.getService()
      输入法实例.loadClipboard()
      print("数据已清除")
      re_lo = false
      service.setKeyboard(".default")
    end)
    .setButton2("取消",function()
      dialog.dismiss()
    end)
    .show()
  end
  
  but_10.onClick = function()
    service.speak(str)--文本转声音
    main.removeView(menu)
  end

  but_11.onClick = function()
    str = string.gsub(str, "[^%a%d%p:/.-]", "")
    str = string.match(str, "[https?://]?[%a%d%p:/.-]*")
    service.commitText(str)
    main.removeView(menu)
  end

  but_11.onLongClick = function()
    str = string.match(str, "[https?://]?[%a%d%p:/.-]*")
    service.commitText(str)
    main.removeView(menu)
  end


  but_12.onClick=function()
    if batch_removal then
      batch_removal = false
      batch_index = {} -- 清空所选待删除的内容索引
      attributeStates = {} -- 清空所有选项状态
      fresh() -- 刷新列表重置高亮状态
      print("您已禁用批量删除")
    else
      batch_removal = true
      print("您已启用批量删除\n长按此按钮即可删除内容\n再次点击即可禁用批量删除")
    end
  end

  but_12.onLongClick = function()
    if #batch_index == 0 then
      print("您没有选择任何内容\n请先点按启用批量删除\n再点按列表中的内容即可选择")
    else
      table.sort(batch_index) -- 从小到大正序排序
      -- -- 先倒序排序再正序遍厉 至于为什么写种两方式因为我在测有没有BUG
      --   table.sort(batch_index, function(a, b) return a > b end) -- 倒序排序
      --   for i = 1, #batch_index do -- 正序遍厉
      for i = #batch_index, 1, -1 do -- 倒序遍厉
        Clip.remove(batch_index[i])
      end
      fresh()
      JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
      batch_index = {} -- 清空所选待删除的内容索引
      attributeStates = {} -- 清空所有选项状态
      batch_removal = false
    end
    return true
  end

  -- but_13.onClick = function()
  --   print("test")
  -- end 

  main.addView(menu) -- 将布局添加至最高层

  return true
end

--[[
-- 原长按菜单------------开始------------

ids.list.onItemLongClick=function(l,v,p)
  getNumStr(p)
  pop=PopupMenu(service,v)
  menu=pop.Menu
  menu.add("置顶").onMenuItemClick=function(ae)
    Clip.remove(num)
    Clip.add(0,str)
    service.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
    fresh() -- 监听了剪切板事件，自动会刷新
  end
  menu.add("查看").onMenuItemClick=function(ae)
    local lay={TextView,
    padding="16dp",
    MaxLines=20,
    textIsSelectable=true,
    text=str,
    textColor=0xff232323,
    textSize="15dp"}
    LuaDialog(service)
    .setTitle(string.format("%s.  预览/操作（%s）",num+1,utf8.len(str)))
    .setView(loadlayout(lay))
    .setButton("置顶",function()
      if p>0 then
        Clip.remove(num)
        Clip.add(0,str)
        service.getSystemService(Context.CLIPBOARD_SERVICE).setText(str)
        --fresh() 监听了剪切板事件，自动会刷新
      end
    end)
    .setButton2("删除",function()
      Clip.remove(num)
      fresh()
      JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
    end)
    .setButton3("取消",function()
      dialog.dismiss()
    end)
    .show()
  end
  menu.add("分割").onMenuItemClick=function(ae)
    导入模块("分词工具.text",str)
  end
  menu.add("删除").onMenuItemClick=function(ae)
    Clip.remove(num)
    fresh()
    JsonUtil.save(File(文件), Clip) --刷新剪切板json文件
  end
  menu.add("🚮清空词条").onMenuItemClick=function(ae)
    pcall(function()
    --pcall里防报错
      恢复状态栏()
    end)
    io.open(文件,"w"):write("[\n]"):close()
    local 输入法实例=Trime.getService()
    输入法实例.loadClipboard()
    print("数据已清除")
    service.setKeyboard(".default")
  end
  menu.add("📤上传云端").onMenuItemClick=function(ae)
    导入模块("推送剪切板到云端.text",str)
  end
  menu.add("📝添加短语").onMenuItemClick=function(ae)
    print(str.."添加成功")
    local Phrase=service.getPhrase()
    Phrase.add(0,str)
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
    io.open(输入法目录.."phrase.json","w"):write(Phrase_nr):close()
  end
  menu.add("📋一键加词").onMenuItemClick=function(ae)
    导入模块("一键加词自动编码(定长).text",str)
  end
  menu.add("🗣语音播报").onMenuItemClick=function(ae)
    service.speak(str)--文本转声音
  end
  menu.add("📇生成二维码").onMenuItemClick=function(ae)
    导入模块("二维码制作.text",str)
  end
  pop.show()
  return true
end

-- 原长按菜单------------结束------------
]]


-- ids.title.onClick=function()
  -- 导入模块("从云端获取剪切板.text","")
-- end

fresh()
func_fresh = fresh
if 全_br == nil then
  剪切板添加广播()
end
service.setKeyboard(main)

pcall(function()
  --pcall里防报错
  隐藏状态栏(main)
end)


-- 默认视频和默认背景图------------开始------------


local bgmv_path = 目录.."bg.mp4" -- 视频背景路径
local bg_pn = 目录.."bg_frame.jpg" -- 图片背景路径

-- 图片背景
if File(bg_pn).isFile() == true then
  -- 将布局添加至layout最底层(0)
  main.addView(loadlayout
    {
      ImageView,
      src = bg_pn,
      --adjustViewBounds="true",--保持长宽比
      scaleType = "fitXY", -- 横向纵向缩放
      layout_width = -1,
      layout_height = -1
  },0)
end
-- 视频背景
if File(bgmv_path).isFile() == true then
  pcall(function()
    local play = MediaPlayer()
    play.setDataSource(bgmv_path)
    play.setLooping(true)
    play.prepareAsync()
    play.setVolume(0,0) -- 视频声音 左声道 右声道 将0改为1即生效
    local video = loadlayout {
      SurfaceView,
      -- 添加背景色，避免看不清按键
      -- BackgroundColor=0x55ffffff,
      -- 线性渐变，"TL_BR"为topleft bottomright
      -- backgroundDrawable=gradientDrawable("TL_BR",{0x99FBE0B5,0x99E5EED9,0x99F3F5F8}),--背景色
      layout_width = -1,
      layout_height = -1
    }
    -- 不等待延迟(视频加载)直接提前进入布局视频加载好后自动添加视频背景 (显示为图片背景 如果无图片则不加载视频显示为默认主题背景) 背景是视频第一帧的话有奇效
    main.post{run=function() 
      main.addView(video, 1) -- 把视频布局放到layout的第二层 第一层留给图片
    end} -- 把这行和前2行 注释即可取消提前进入布局
    -- 实际这2行代码没用(指放在这里),addView已经把控件添加在合适的布局层级上了。
    -- video.setZOrderOnTop(true) -- 把surfaceView的布局层设为最高层
    -- video.setZOrderMediaOverlay(true) -- 不覆盖其他控件   video.setZOrderOnTop(false)也行 顾名思义false就是关
    video.getHolder().addCallback({
      surfaceCreated = function(holder) --surfaceView创建开始后

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
      surfaceDestroyed = function() -- surfaceView销毁前
        -- 释放资源 将这三行代码注释 就能在不退出剪切板的情况下，关闭键盘(即切换应用)再打开时重新加载为视频 记得把底下回到主键盘和状态栏也注释
        play.stop() --防止退出脚本时 闪黑屏
        play.release()
        video.setZOrderOnTop(true) --把surfaceView的控件布局层级设置为最高，防止上面那个情况下，背景为黑而不是你的键盘背景。

        -- -- 2. 播放视频时切换应用(即不退出剪剪板时关闭键盘) 返回主键盘并恢复状态栏 少部分软件一些功能有概率会直接再次调用键盘导致 返回2次崩溃 所以不推荐使用了
        -- if re_lo then -- 防止点击返回时视频背景自动返回2次直接崩溃
        --     service.setKeyboard(".default")
        --     pcall(function()
        --       --pcall里防报错
        --       恢复状态栏()
        --     end)
        -- end -- 返回主键盘并恢复状态栏结束
      end
    })
  end)
end

-- 默认视频和默认背景图------------结束------------

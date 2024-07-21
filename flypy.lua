--[[
--无障碍版专用方案脚本

--配置说明
第①步 放置在rime目录下，改成和方案同名的lua如luna_pinyin.lua 
第②步 关掉键盘，键盘刷新后就可以看到效果

--return {实时运行=实时运行,刷新键盘=刷新键盘,上屏后处理=上屏后处理,当前候选处理=当前候选处理,帮助=帮助说明}

]]

--导入包
require "import"
import "java.io.File"


if 全局变量_方案变量组==nil 全局变量_方案变量组={} end

local function 递归查找文件(catalog,name)
  local t=os.clock()
  local 文件组={}
  import "java.io.File" 
  import "java.lang.String"
  function FindFile(catalog,name)
    local name=tostring(name)
    local ls=catalog.listFiles() or File{}
    for 次数=0,#ls-1 do
      --local 目录=tostring(ls[次数])
      local f=ls[次数]
      if f.isDirectory() then--如果是文件夹则继续匹配
        FindFile(f,name)
      else--如果是文件则
        local nm=f.Name
        if string.find(nm,name) then
          文件组[#文件组+1]=tostring(f)
        end
      end
      luajava.clear(f)
    end
  end
  FindFile(catalog,name)
  return 文件组
end --递归查找文件

local 脚本组=递归查找文件(File(service.getLuaExtDir("script_auto")),".lua$")
table.sort(脚本组)

--部署后运行
local function 部署后运行()
	local 脚本组1=递归查找文件(File(service.getLuaExtDir("script_auto")),".lua$")
  table.sort(脚本组1)
  for n=1,#脚本组1 do
		local 当前脚本方法=dofile(脚本组1[n])
		if type(当前脚本方法)=="table" and 当前脚本方法.部署后运行~=nil then 当前脚本方法.部署后运行() end
	end
end
if _G.部署状态==nil 部署后运行() end
_G.部署状态="已部署"


--刷新键盘时的处理
local function 刷新键盘()
   for n=1,#脚本组  do
     local 当前脚本方法=dofile(脚本组[n])
     if type(当前脚本方法)=="table" and 当前脚本方法.刷新键盘~=nil then 当前脚本方法.刷新键盘() end
   end
end
task(10,function() 刷新键盘() end)--间隔时间


--使用定时器实时运行
local function 实时运行()
	for n=1,#脚本组  do
		local 当前脚本方法=dofile(脚本组[n])
		if type(当前脚本方法)=="table" and 当前脚本方法.实时运行~=nil then 当前脚本方法.实时运行() end
	end
end
--[[
if 全局变量_方案变量组.定时器_ti==nil then
	print("启动实时脚本定时器")
	全局变量_方案变量组.定时器= "开启"
	全局变量_方案变量组.定时器_ti=Ticker() --Ticker定时器
	全局变量_方案变量组.定时器_ti.Period=300  --间隔
	全局变量_方案变量组.定时器_ti.onTick=function()
		实时运行()
	end
	全局变量_方案变量组.定时器_ti.start() --启动Ticker定时器
end

]]

--接收广播_复制内容(复制后执行)
----[[
local function 复制后运行(复制内容)
	local 脚本组1=递归查找文件(File(service.getLuaExtDir("script_auto")),".lua$")
  table.sort(脚本组1)
  for n=1,#脚本组1 do
		local 当前脚本方法=dofile(脚本组1[n])
		if type(当前脚本方法)=="table" and 当前脚本方法.复制后运行~=nil then 当前脚本方法.复制后运行(复制内容) end
	end
end


if 全局变量_接受广播_复制内容==nil then
	--print("接收广播_复制内容")
	全局变量_接受广播_复制内容= "com.nirenr.talkman.ACTION_ADD_CLIPBOARD"
	import "android.content.Intent"
	import "android.content.Context"
	import "android.content.BroadcastReceiver"
	import "android.content.IntentFilter"
	import "com.androlua.LuaBroadcastReceiver"
	br=LuaBroadcastReceiver(LuaBroadcastReceiver.OnReceiveListener{
		onReceive=function(context, intent)
			if intent.getAction()=="com.nirenr.talkman.ACTION_ADD_CLIPBOARD" then
				if intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~="" or intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")~=nil then
					local 复制内容0= intent.getStringExtra("com.nirenr.talkman.EXTRA_TEXT_DATA")
					复制后运行(复制内容0)
				end --intent.getStringExtra
			end --intent.getAction
		end --function(conte
	})
	--动态注册广播接受者
	filter=IntentFilter()
	filter.addAction("com.nirenr.talkman.ACTION_ADD_CLIPBOARD")
	filter.setPriority(Integer.MAX_VALUE)
	--开启广播接收
	service.registerReceiver(br,filter)
end --if 全局变量
--]]

function onStartInput(a,b)
 --print(a,b)
end

function onStartInputView(v,a)
  --print("55",type(v),type(a),type(b))
end

--程序启动
function onCreate()
  print("onCreate")
end

--程序销毁
function onDestroy(a,b,c)
  print(a,b,c)
end

--编辑框更改后
function onOptionChanged(v,b)
  --print(v,b)
end

function onkeydown()
  --print("55")
end

--软键盘隐藏时
if _G.软键盘隐藏时执行状态==nil _G.软键盘隐藏时执行状态=1 end --防止执行再次
function onWindowHidden()
    if _G.软键盘隐藏时执行状态==1 then
      for n=1,#脚本组  do
       local 当前脚本方法=dofile(脚本组[n])
       if (type(当前脚本方法)=="table" and 当前脚本方法.软键盘隐藏时~=nil)  then 当前脚本方法.软键盘隐藏时() end
     end
     _G.软键盘隐藏时执行状态=2
   else
     _G.软键盘隐藏时执行状态=1
   end
end

--软键盘显示时
function onWindowShown()
  
end

function onConfigurationChanged()
  --print(a,b)
end



--上屏后的处理
function commitText(候选)
 task(10,function() 
  for n=1,#脚本组  do
     local 当前脚本方法=dofile(脚本组[n])
     if type(当前脚本方法)=="table" and 当前脚本方法.上屏后处理~=nil 当前脚本方法.上屏后处理(候选) end
   end
 end)--间隔时间
end


local function 当前候选延时处理(i,c,t)
  --print("已过2s了")
  local 当前候选=t
  for n=1,#脚本组  do
     local 当前脚本方法=dofile(脚本组[n])
     if (type(当前脚本方法)=="table" and 当前脚本方法.当前候选延时处理~=nil)  then 当前脚本方法.当前候选延时处理(当前候选) end
   end
end

全局变量_方案变量组.候选计时器开始计时= false
全局变量_方案变量组.计时秒数=0
if 全局变量_方案变量组.候选计时器==nil then
  --print("载入候选计时器")
  全局变量_方案变量组.候选计时器=Ticker() 
  全局变量_方案变量组.候选计时器.Period=20
  全局变量_方案变量组.候选计时器.start()
  全局变量_方案变量组.候选计时器.onTick= function() 
    if 全局变量_方案变量组.候选计时器开始计时== false 全局变量_方案变量组.计时秒数=0 end
    
    
    全局变量_方案变量组.计时秒数=全局变量_方案变量组.计时秒数+1
    local 当前候选=Rime.getComposingText()  --当前候选 
    
    if 当前候选=="" then
      全局变量_方案变量组.计时秒数=0
      全局变量_方案变量组.候选计时器开始计时= false 
    end
    if 全局变量_方案变量组.当前候选~=当前候选  then
      全局变量_方案变量组.计时秒数=0
      全局变量_方案变量组.候选计时器开始计时= false 
    end
    
    if 全局变量_方案变量组.计时秒数==50 then
      全局变量_方案变量组.计时秒数=0
      全局变量_方案变量组.候选计时器开始计时= false 
      当前候选延时处理(i,c,t)
    end
  end--
end


执行否= false
--当前候选处理
local function 当前候选处理(i,c,t)
  for n=1,#脚本组  do
     local 当前脚本方法=dofile(脚本组[n])
     if (type(当前脚本方法)=="table" and 当前脚本方法.当前候选处理~=nil)  then 
     if 当前脚本方法.当前候选处理(i,c,t) ==true then
       break --运行后返回true时结束其它脚本运行,相当于拦截后面的脚本
     end--if
     end--if
   end--for
end

--当前候选处理
function updateComposing(i,c,t)
  --print(i)

if t==nil or t=="" then
   do return end --强行退出
  end
  --防止执行两次
---[[
  if 执行否 then
   执行否= false
  else
   执行否= true
      do return end --强行退出
  end
--]]
  当前候选处理(i,c,t)
  当前候选延时处理(i,c,t)
  --当前候选延时处理
  全局变量_方案变量组.当前候选=t
  全局变量_方案变量组.计时秒数=0
  全局变量_方案变量组.候选计时器开始计时= true
end


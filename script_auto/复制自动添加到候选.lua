--改脚本需要与自动脚本启动器配合使用
--将该脚本放置到"rime/script_auto"中即可

require "import"
import "com.osfans.trime.*"
local function CopyAutoaddCandidates()
  this.addCandidates({tostring(this.getSystemService(Context.CLIPBOARD_SERVICE).getText())}) --刷新候选栏
end
return {复制后运行=CopyAutoaddCandidates}

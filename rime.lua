function date_translator(input, seg)
   if (input == "orq") then
      --- Candidate(type, start, end, text, comment)
      yield(Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), " "))
      yield(Candidate("date", seg.start, seg._end, os.date("%Y年%m月%d日"), ""))      
      yield(Candidate("date", seg.start, seg._end, os.date("%Y%m%d"), " "))
   end
end

function time_translator(input, seg)
   if (input == "ouj") then
      --- local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M"), " ")
      local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), " ")
      cand.quality = 1
      yield(cand)
      cand = Candidate("time", seg.start, seg._end, os.date("%H时%M分%S秒"), " ")
      cand.quality = 2
      yield(cand)
      cand = Candidate("time", seg.start, seg._end, os.date("%H%M%S"), " ")
      cand.quality = 3
      yield(cand)
   end
end

function date_time_translator(input, seg)
   if (input == "orj") then
      local cand = Candidate("time", seg.start, seg._end, os.date("%Y-%m-%d %H:%M:%S"), " ")
      cand.quality = 1
      yield(cand)
      cand = Candidate("time", seg.start, seg._end, os.date("%Y年%m月%d日 %H时%M分%S秒"), " ")
      cand.quality = 2
      yield(cand)
      cand = Candidate("time", seg.start, seg._end, os.date("%Y%m%d-%H%M%S"), " ")
      cand.quality = 3
      yield(cand)
      cand = Candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), " ")
      cand.quality = 4
      yield(cand)
   end
end

calculator_translator = require("calculator_translator")
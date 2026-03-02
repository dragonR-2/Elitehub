local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PianoController = Knit.GetController("PianoController")

-- متغيرات التحكم
local Playing = false
local CurrentText = ""
local WaitTime = 0.18

-- المترجم الشامل (لجميع النوتات 1-88)
local FullMap = {
    ["1"]=22, ["!"]=23, ["2"]=24, ["@"]=25, ["3"]=26, ["4"]=27, ["$"]=28, ["5"]=29, ["%"]=30, ["6"]=31, ["^"]=32, ["7"]=33, 
    ["8"]=34, ["*"]=35, ["9"]=36, ["("]=37, ["0"]=38, ["q"]=39, ["Q"]=40, ["w"]=41, ["W"]=42, ["e"]=43, ["E"]=44, ["r"]=45, 
    ["R"]=46, ["t"]=47, ["T"]=48, ["y"]=49, ["Y"]=50, ["u"]=51, ["U"]=52, ["i"]=53, ["I"]=54, ["o"]=55, ["O"]=56, ["p"]=57, 
    ["P"]=58, ["a"]=59, ["A"]=60, ["s"]=61, ["S"]=62, ["d"]=63, ["D"]=64, ["f"]=65, ["F"]=66, ["g"]=67, ["G"]=68, ["h"]=69, 
    ["H"]=70, ["j"]=71, ["J"]=72, ["k"]=73, ["K"]=74, ["l"]=75, ["L"]=76, ["z"]=77, ["Z"]=78, ["x"]=79, ["X"]=80, ["c"]=81, 
    ["C"]=82, ["v"]=83, ["V"]=84, ["b"]=85, ["B"]=86, ["n"]=87, ["m"]=88
}

local Window = Rayfield:CreateWindow({
   Name = "Elite Piano Hub 🎹",
   LoadingTitle = "جاري تفعيل محرك النفس الموسيقي...",
})

local Tab = Window:CreateTab("Master Player", 4483362458)

Tab:CreateInput({
   Name = "صق النوتات هنا",
   PlaceholderText = "انسخ Sheet من جوجل وضعه هنا...",
   Callback = function(Text)
      CurrentText = Text
   end,
})

-- زر التشغيل مع تقنية (Humanize & Sustain)
Tab:CreateButton({
   Name = "▶️ بدء العزف (بشري)",
   Callback = function()
      if Playing or CurrentText == "" then return end
      Playing = true
      
      task.spawn(function()
          local i = 1
          while i <= #CurrentText and Playing do
              local char = CurrentText:sub(i,i)
              
              -- تقنية الصوت العسلي: قوة ضغط متغيرة (Velocity)
              local vol = 0.7 + (math.random(-8, 8) / 100)
              
              if char == "[" then -- معالجة الأوتار (Chords)
                  local chord = {}
                  i = i + 1
                  while i <= #CurrentText and CurrentText:sub(i,i) ~= "]" do
                      local c = CurrentText:sub(i,i)
                      if FullMap[c] then table.insert(chord, FullMap[c]) end
                      i = i + 1
                  end
                  for _, n in ipairs(chord) do PianoController:PressClientKey(n, n, nil, nil, vol) end
                  task.wait(WaitTime)
                  -- ترك النوتة ترن قليلاً قبل الإغلاق (Sustain)
                  task.delay(0.12, function()
                      for _, n in ipairs(chord) do PianoController:ReleaseClientKey(n) end
                  end)
              elseif FullMap[char] then
                  local n = FullMap[char]
                  PianoController:PressClientKey(n, n, nil, nil, vol)
                  -- تأخير بشري بسيط لجعل الإيقاع "يتنفس"
                  task.wait(WaitTime + (math.random(-15, 15) / 1000))
                  task.delay(0.12, function() PianoController:ReleaseClientKey(n) end)
              elseif char == " " then
                  task.wait(WaitTime * 2.5) -- النفس بين الجمل الموسيقية
              end
              i = i + 1
              task.wait()
          end
          Playing = false
      end)
   end,
})

Tab:CreateButton({
   Name = "⏹️ إيقاف فوري",
   Callback = function() Playing = false end,
})

Tab:CreateButton({
   Name = "🗑️ مسح النص",
   Callback = function() CurrentText = "" end,
})

Tab:CreateSlider({
   Name = "سرعة الإيقاع (Tempo)",
   Range = {0.05, 0.5},
   Increment = 0.01,
   CurrentValue = 0.18,
   Callback = function(V) WaitTime = V end,
})

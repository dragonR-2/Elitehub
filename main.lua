local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PianoController = Knit.GetController("PianoController")

-- المتغيرات الأساسية للتحكم
local Playing = false
local InputText = ""
local WaitTime = 0.15 -- السرعة الافتراضية

-- جدول التحويل الكامل (من ملفك البرمجي)
local FullMap = {
    ["1"]=22, ["!"]=23, ["2"]=24, ["@"]=25, ["3"]=26, ["4"]=27, ["$"]=28, ["5"]=29, ["%"]=30, ["6"]=31, ["^"]=32, ["7"]=33, 
    ["8"]=34, ["*"]=35, ["9"]=36, ["("]=37, ["0"]=38, ["q"]=39, ["Q"]=40, ["w"]=41, ["W"]=42, ["e"]=43, ["E"]=44, ["r"]=45, 
    ["R"]=46, ["t"]=47, ["T"]=48, ["y"]=49, ["Y"]=50, ["u"]=51, ["U"]=52, ["i"]=53, ["I"]=54, ["o"]=55, ["O"]=56, ["p"]=57, 
    ["P"]=58, ["a"]=59, ["A"]=60, ["s"]=61, ["S"]=62, ["d"]=63, ["D"]=64, ["f"]=65, ["F"]=66, ["g"]=67, ["G"]=68, ["h"]=69, 
    ["H"]=70, ["j"]=71, ["J"]=72, ["k"]=73, ["K"]=74, ["l"]=75, ["L"]=76, ["z"]=77, ["Z"]=78, ["x"]=79, ["X"]=80, ["c"]=81, 
    ["C"]=82, ["v"]=83, ["V"]=84, ["b"]=85, ["B"]=86, ["n"]=87, ["m"]=88
}

local Window = Rayfield:CreateWindow({
   Name = "Elite Piano Pro 🎹",
   LoadingTitle = "جاري تشغيل محرك العزف...",
   LoadingSubtitle = "نظام 88 مفتاحاً متصل",
})

local Tab = Window:CreateTab("Main Player", 4483362458)

-- 1. صندوق إدخال النوتات
Tab:CreateInput({
   Name = "صق النوتات هنا",
   PlaceholderText = "مثال: [uI] [pS] f g h",
   Callback = function(Text)
      InputText = Text
   end,
})

-- 2. زر التشغيل (Play)
Tab:CreateButton({
   Name = "▶️ تشغيل",
   Callback = function()
      if Playing then return end
      Playing = true
      
      local i = 1
      while i <= #InputText and Playing do
          local char = InputText:sub(i,i)
          
          if char == "[" then
              local chord = {}
              i = i + 1
              while i <= #InputText and Text:sub(i,i) ~= "]" do
                  local c = InputText:sub(i,i)
                  if FullMap[c] then table.insert(chord, FullMap[c]) end
                  i = i + 1
              end
              -- عزف الوتر (Chord) كما يدعم ملفك
              for _, note in ipairs(chord) do
                  PianoController:PressClientKey(note, note, nil, nil, 0.7)
              end
              task.wait(WaitTime)
              for _, note in ipairs(chord) do PianoController:ReleaseClientKey(note) end
          elseif FullMap[char] then
              local note = FullMap[char]
              -- إرسال الإشارة للسيرفر
              PianoController:PressClientKey(note, note, nil, nil, 0.7)
              task.wait(WaitTime)
              PianoController:ReleaseClientKey(note)
          end
          i = i + 1
          task.wait()
      end
      Playing = false
   end,
})

-- 3. زر الإيقاف (Stop)
Tab:CreateButton({
   Name = "⏹️ إيقاف",
   Callback = function()
      Playing = false
      Rayfield:Notify({Title = "توقف", Content = "تم إيقاف العزف", Duration = 2})
   end,
})

-- 4. التحكم في السرعة (Speed Slider)
Tab:CreateSlider({
   Name = "سرعة العزف (Delay)",
   Info = "كلما قل الرقم زادت السرعة",
   Range = {0.05, 0.5},
   Increment = 0.01,
   CurrentValue = 0.15,
   Callback = function(Value)
      WaitTime = Value
   end,
})

-- 5. زر مسح النص (Clear)
Tab:CreateButton({
   Name = "🗑️ مسح النص",
   Callback = function()
      InputText = ""
      Rayfield:Notify({Title = "تم المسح", Content = "تم تصفير صندوق النوتات", Duration = 2})
   end,
})

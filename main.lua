local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PianoController = Knit.GetController("PianoController")

-- المتغيرات الأساسية (خارج الـ Callbacks لتعمل الأزرار)
local Playing = false
local CurrentText = "" 
local WaitTime = 0.15

local FullMap = {
    ["1"]=22, ["!"]=23, ["2"]=24, ["@"]=25, ["3"]=26, ["4"]=27, ["$"]=28, ["5"]=29, ["%"]=30, ["6"]=31, ["^"]=32, ["7"]=33, 
    ["8"]=34, ["*"]=35, ["9"]=36, ["("]=37, ["0"]=38, ["q"]=39, ["Q"]=40, ["w"]=41, ["W"]=42, ["e"]=43, ["E"]=44, ["r"]=45, 
    ["R"]=46, ["t"]=47, ["T"]=48, ["y"]=49, ["Y"]=50, ["u"]=51, ["U"]=52, ["i"]=53, ["I"]=54, ["o"]=55, ["O"]=56, ["p"]=57, 
    ["P"]=58, ["a"]=59, ["A"]=60, ["s"]=61, ["S"]=62, ["d"]=63, ["D"]=64, ["f"]=65, ["F"]=66, ["g"]=67, ["G"]=68, ["h"]=69, 
    ["H"]=70, ["j"]=71, ["J"]=72, ["k"]=73, ["K"]=74, ["l"]=75, ["L"]=76, ["z"]=77, ["Z"]=78, ["x"]=79, ["X"]=80, ["c"]=81, 
    ["C"]=82, ["v"]=83, ["V"]=84, ["b"]=85, ["B"]=86, ["n"]=87, ["m"]=88
}

local Window = Rayfield:CreateWindow({
   Name = "Elite Piano Controller 🎹",
   LoadingTitle = "جاري الربط مع محرك اللعبة...",
})

local Tab = Window:CreateTab("Player Control", 4483362458)

-- 1. صندوق الإدخال (يحفظ النص فقط ولا يعزف)
local InputField = Tab:CreateInput({
   Name = "أدخل النوتات هنا",
   PlaceholderText = "صق أحرف المعزوفة...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      CurrentText = Text -- حفظ النص في المتغير فقط
   end,
})

-- 2. زر التشغيل (Play) - الآن هو المسؤول الوحيد عن العزف
Tab:CreateButton({
   Name = "▶️ بدء العزف",
   Callback = function()
      if Playing or CurrentText == "" then return end
      Playing = true
      
      task.spawn(function() -- تشغيل في خلفية منفصلة لكي لا يعلق السكربت
          local i = 1
          while i <= #CurrentText and Playing do
              local char = CurrentText:sub(i,i)
              
              if char == "[" then
                  local chord = {}
                  i = i + 1
                  while i <= #CurrentText and CurrentText:sub(i,i) ~= "]" do
                      local c = CurrentText:sub(i,i)
                      if FullMap[c] then table.insert(chord, FullMap[c]) end
                      i = i + 1
                  end
                  for _, note in ipairs(chord) do
                      PianoController:PressClientKey(note, note, nil, nil, 0.7)
                  end
                  task.wait(WaitTime)
                  for _, note in ipairs(chord) do PianoController:ReleaseClientKey(note) end
              elseif FullMap[char] then
                  local note = FullMap[char]
                  PianoController:PressClientKey(note, note, nil, nil, 0.7)
                  task.wait(WaitTime)
                  PianoController:ReleaseClientKey(note)
              elseif char == " " then -- معالجة المسافات لتعطي وقتاً إضافياً
                  task.wait(WaitTime)
              end
              i = i + 1
          end
          Playing = false
      end)
   end,
})

-- 3. زر الإيقاف الفوري
Tab:CreateButton({
   Name = "⏹️ إيقاف العزف",
   Callback = function()
      Playing = false
   end,
})

-- 4. زر حذف النص (Clear)
Tab:CreateButton({
   Name = "🗑️ مسح الصندوق",
   Callback = function()
      CurrentText = ""
      -- ملاحظة: لمسح النص من واجهة Rayfield بصرياً، يجب إعادة كتابته يدوياً
      Rayfield:Notify({Title = "تم الحذف", Content = "يمكنك الآن لصق معزوفة جديدة", Duration = 2})
   end,
})

-- 5. التحكم في السرعة
Tab:CreateSlider({
   Name = "سرعة الإيقاع",
   Range = {0.05, 0.6},
   Increment = 0.01,
   CurrentValue = 0.15,
   Callback = function(Value)
      WaitTime = Value
   end,
})

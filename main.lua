local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local PianoController = Knit.GetController("PianoController")

-- جدول التحويل الكامل (88 مفتاحاً) لجميع الأحرف
local FullMap = {
    ["1"]=22, ["!"]=23, ["2"]=24, ["@"]=25, ["3"]=26, ["4"]=27, ["$"]=28, ["5"]=29, ["%"]=30, ["6"]=31, ["^"]=32, ["7"]=33, 
    ["8"]=34, ["*"]=35, ["9"]=36, ["("]=37, ["0"]=38, ["q"]=39, ["Q"]=40, ["w"]=41, ["W"]=42, ["e"]=43, ["E"]=44, ["r"]=45, 
    ["R"]=46, ["t"]=47, ["T"]=48, ["y"]=49, ["Y"]=50, ["u"]=51, ["U"]=52, ["i"]=53, ["I"]=54, ["o"]=55, ["O"]=56, ["p"]=57, 
    ["P"]=58, ["a"]=59, ["A"]=60, ["s"]=61, ["S"]=62, ["d"]=63, ["D"]=64, ["f"]=65, ["F"]=66, ["g"]=67, ["G"]=68, ["h"]=69, 
    ["H"]=70, ["j"]=71, ["J"]=72, ["k"]=73, ["K"]=74, ["l"]=75, ["L"]=76, ["z"]=77, ["Z"]=78, ["x"]=79, ["X"]=80, ["c"]=81, 
    ["C"]=82, ["v"]=83, ["V"]=84, ["b"]=85, ["B"]=86, ["n"]=87, ["m"]=88
}

local Window = Rayfield:CreateWindow({
   Name = "Ultimate Piano Translator 🎹",
   LoadingTitle = "جاري تفعيل المترجم الشامل...",
   LoadingSubtitle = "نظام 88 مفتاحاً جاهز",
})

local Tab = Window:CreateTab("Master Player", 4483362458)

Tab:CreateInput({
   Name = "صق النوتات (أحرف/رموز) هنا",
   PlaceholderText = "مثال: [uI] [pS] f g h",
   Callback = function(Text)
      -- نظام معالجة الأوتار (الأقواس)
      local i = 1
      while i <= #Text do
          local char = Text:sub(i,i)
          
          if char == "[" then -- بداية وتر (Chord)
              local chord = {}
              i = i + 1
              while i <= #Text and Text:sub(i,i) ~= "]" do
                  local c = Text:sub(i,i)
                  if FullMap[c] then table.insert(chord, FullMap[c]) end
                  i = i + 1
              end
              -- عزف الوتر معاً (Multi-key) كما يدعم ملفك
              for _, note in ipairs(chord) do
                  PianoController:PressClientKey(note, note, nil, nil, 0.7)
              end
              task.wait(0.2)
              for _, note in ipairs(chord) do PianoController:ReleaseClientKey(note) end
          elseif FullMap[char] then -- نوتة مفردة
              local note = FullMap[char]
              PianoController:PressClientKey(note, note, nil, nil, 0.7)
              task.wait(0.15)
              PianoController:ReleaseClientKey(note)
          end
          i = i + 1
      end
   end,
})


Tab:CreateButton({
   Name = "▶️ تشغيل المعزوفة",
   Callback = function()
      if Playing then return end -- منع التشغيل المزدوج
      Playing = true
      
      local i = 1
      while i <= #InputText and Playing do
          local char = InputText:sub(i,i)
          -- (هنا نضع نفس منطق المترجم الشامل الذي برمجناه سابقاً)
          -- تأكد من إضافة 'and Playing' في حلقة while لضمان التوقف الفوري
          i = i + 1
          task.wait() 
      end
      Playing = false
   end,
})


Tab:CreateButton({
   Name = "⏹️ إيقاف مؤقت",
   Callback = function()
      Playing = false -- كسر حلقة التشغيل فوراً
      Rayfield:Notify({Title = "توقف", Content = "تم إيقاف العزف بنجاح", Duration = 2})
   end,
})


Tab:CreateButton({
   Name = "🗑️ مسح النص",
   Callback = function()
      InputText = "" -- مسح المتغير
      -- ملاحظة: Rayfield لا يدعم مسح نص الـ Input برمجياً بشكل مباشر في بعض النسخ
      -- لكننا قمنا بصفر القيمة التي يقرأ منها المحرك
      Rayfield:Notify({Title = "تم المسح", Content = "صندوق النوتات أصبح فارغاً الآن", Duration = 2})
   end,
})

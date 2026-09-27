local Window = Aurora.new({
    Title = "Elite Hub",
    ToggleKey = Enum.KeyCode.RightShift,
    -- Accent = Color3.fromRGB(138, 43, 226), -- فعّلها لو تريد البنفسجي
})

local Combat = Window:CreateTab("Combat")
Combat:CreateSection("Main")
Combat:CreateToggle("Kill Aura", false, function(on) print("Kill Aura:", on) end)
Combat:CreateSlider("WalkSpeed", 16, 200, 16, function(v)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
end)
Combat:CreateDropdown("Target Part", {"Head", "Torso", "Random"}, "Head", print)

local Misc = Window:CreateTab("Misc")
Misc:CreateButton("Rejoin Server", function() print("Rejoining...") end)
Misc:CreateInput("Webhook URL", "https://...", function(text, enter) print(text, enter) end)
Misc:CreateKeybind("Hide Menu", Enum.KeyCode.RightControl, function() Window:Toggle() end)
Misc:CreateColorpicker("ESP Color", Color3.fromRGB(0, 140, 255), print)
Misc:CreateParagraph("ملاحظة", "هذه فقرة تتمدد تلقائياً حسب طول النص بدون قص.")

Window:OnClose(function() print("تنظيف نهائي عند الإغلاق") end)
local Window = Aurora.new({ Title = "Elite Hub" })

-- [1] إشعارات
Window:Notify("تم التحميل", "مرحباً بك في Elite Hub!", 4) -- الشكل المختصر
Window:Notify({                                          -- الشكل المتقدم
    Title = "انضم لسيرفرنا",
    Message = "اضغط الزر لنسخ رابط الديسكورد",
    Duration = 8,
    ButtonText = "Copy Link",
    ClipboardText = "https://discord.gg/your-invite", -- نسخ تلقائي بضغطة
    ButtonCallback = function() print("Clicked!") end,
})

-- [2] بطاقة المطور
local Info = Window:CreateTab("Info")
Info:CreateProfile("DevName", 123456789, "Owner & Developer", "Discord", function()
    Window:Notify("Discord", "تم نسخ الرابط", 3)
end)

-- [3] زر بأيقونة
Info:CreateButton("Rejoin Server", function() print("rejoin") end, 6031225767)

-- [4] حفظ / تحميل الإعدادات
local Settings = Window:CreateTab("Settings")
Settings:CreateButton("Save Config", function()
    local ok, path = Window:SaveConfig("EliteHub", "config")
    Window:Notify(ok and "Config Saved ✓" or "Save Failed", tostring(path), 3)
end)
Settings:CreateButton("Load Config", function()
    local ok, info = Window:LoadConfig("EliteHub", "config")
    Window:Notify(ok and "Config Loaded ✓" or "Load Failed", tostring(info), 3)
end)

-- تحميل تلقائي عند البدء + حفظ تلقائي عند الخروج
task.delay(0.5, function() Window:LoadConfig("EliteHub", "config") end)
Window:OnClose(function()
    Window:SaveConfig("EliteHub", "config")
end)

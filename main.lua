
local PandaAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/Panda-Development/PandaAuth/main/lib/PandaAuth.lua"))()
if not PandaAuth:Authenticate("5b0f91fe-b5b5-4623-9be2-86e24f32fed3") then
    return
end

--ma niga $$$$$

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Elite Hub | Universal",
   LoadingTitle = "جاري تحميل السكربت...",
   LoadingSubtitle = "بواسطة Elite Developer",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false -- كما اتفقنا، لا يوجد نظام مفاتيح حالياً
})

-- إنشاء التبويبات
local MainTab = Window:CreateTab("الرئيسية", 4483362458)
local PlayerTab = Window:CreateTab("اللاعب", 4483362458)
local VisualsTab = Window:CreateTab("الرؤية", 4483362458)

-- [[ التبويب الرئيسي ]]
MainTab:CreateSection("أدوات التحكم")

local StatsSection = MainTab:CreateSection("حالة الجهاز")

local LabelFPS = MainTab:CreateLabel("FPS: جاري الحساب...")
local LabelPing = MainTab:CreateLabel("Ping: جاري الحساب...")

-- محرك التحديث (طريقة مضمونة)
task.spawn(function()
    local RunService = game:GetService("RunService")
    while task.wait(0.5) do
        -- حساب الـ FPS
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        
        -- حساب الـ Ping (الطريقة الرسمية من إحصائيات الشبكة)
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        
        -- تحديث النصوص في السكربت
        LabelFPS:Set("FPS: " .. fps)
        LabelPing:Set("Ping: " .. ping .. "ms")
    end
end)


MainTab:CreateToggle({
   Name = "النقر التلقائي (Auto Clicker)",
   CurrentValue = false,
   Flag = "AutoClick",
   Callback = function(Value)
      _G.AutoClick = Value
   end,
})

MainTab:CreateButton({
   Name = "إعادة دخول السيرفر (Rejoin)",
   Callback = function()
      game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
   end,
})

MainTab:CreateButton({
   Name = "تحسين الفريمات (FPS Booster)",
   Info = "يقوم بحذف التأثيرات الزائدة لتقليل اللاق", -- شرح يظهر عند التمرير
   Callback = function()
       -- كود تحسين الأداء
       local Terrain = workspace:FindFirstChildOfClass('Terrain')
       Terrain.WaterWaveSize = 0
       Terrain.WaterWaveSpeed = 0
       Terrain.WaterReflectance = 0
       Terrain.WaterTransparency = 0
       
       settings().Rendering.QualityLevel = 1
       
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
               v.Material = Enum.Material.SmoothPlastic
               v.Reflectance = 0
           elseif v:IsA("Decal") or v:IsA("Texture") then
               v:Destroy()
           elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
           elseif v:IsA("Explosion") then
               v.Visible = false
           end
       end
       
       Rayfield:Notify({
          Title = "تم التحسين!",
          Content = "تم تفعيل وضع الأداء العالي بنجاح.",
          Duration = 3,
          Image = 4483362458,
       })
   end,
})

MainTab:CreateButton({
   Name = "🚀 وضع الأداء الخارق (Max FPS Boost)",
   Info = "سيقوم بتعطيل الظلال، التأثيرات، والرسومات تماماً لرفع السرعة",
   Callback = function()
       -- 1. تعطيل الإضاءة والظلال المعقدة
       local Lighting = game:GetService("Lighting")
       Lighting.GlobalShadows = false
       Lighting.FogEnd = 9e9
       Lighting.Brightness = 1
       settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

       -- 2. تعطيل التأثيرات البصرية في اللعبة
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
               v.Material = Enum.Material.SmoothPlastic
               v.Reflectance = 0
           elseif v:IsA("Decal") or v:IsA("Texture") then
               v:Destroy()
           elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
           elseif v:IsA("Explosion") then
               v.Visible = false
           elseif v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
               v.Enabled = false
           end
       end

       -- 3. تقليل جودة التضاريس (Terrain)
       local Terrain = workspace:FindFirstChildOfClass('Terrain')
       if Terrain then
           Terrain.WaterWaveSize = 0
           Terrain.WaterWaveSpeed = 0
           Terrain.WaterReflectance = 0
           Terrain.WaterTransparency = 0
       end

       -- 4. تعطيل معالجة الصور (PostProcessing)
       for _, effect in pairs(Lighting:GetChildren()) do
           if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
               effect.Enabled = false
           end
       end

       Rayfield:Notify({
          Title = "Elite Boost",
          Content = "تم تفعيل أقصى وضع للأداء (Extreme Mode On)",
          Duration = 5,
          Image = 4483362458,
       })
   end,
})

MainTab:CreateButton({
   Name = "حذف أي شيء تلمسه (Touch to Destroy)",
   Callback = function()
       Rayfield:Notify({Title = "Elite Hub", Content = "الميزة مفعلة! أي جزء تلمسه بجسدك سيختفي."})
       game.Players.LocalPlayer.Character.Humanoid.Touched:Connect(function(hit)
           if hit and hit:IsA("BasePart") and not hit.Parent:FindFirstChild("Humanoid") then
               hit:Destroy()
           end
       end)
   end,
})

MainTab:CreateButton({
   Name = "الانتقال لسيرفر آخر (Server Hop)",
   Callback = function()
       local HttpService = game:GetService("HttpService")
       local TeleportService = game:GetService("TeleportService")
       local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
       for _, v in pairs(Servers.data) do
           if v.playing < v.maxPlayers and v.id ~= game.JobId then
               TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
               break
           end
       end
   end,
})


-- [[ تبويب اللاعب ]]
PlayerTab:CreateSection("تطويرات الشخصية")

PlayerTab:CreateSlider({
   Name = "سرعة المشي",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "القفز اللانهائي",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfiniteJumpEnabled = Value
   end,
})

PlayerTab:CreateToggle({
   Name = "اختراق الجدران (Noclip)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      _G.NoclipEnabled = Value
   end,
})

local Flying = false
local FlySpeed = 16

PlayerTab:CreateSection("التحليق (Fly)")

-- الطيران

local Flying = false
local FlySpeed = 50
local player = game.Players.LocalPlayer

PlayerTab:CreateSection("نظام الطيران V2")

PlayerTab:CreateToggle({
   Name = "تفعيل الطيران",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local char = player.Character or player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      
      if Flying then
         -- إنشاء القوى الفيزيائية داخلياً لضمان العمل
         local bv = Instance.new("BodyVelocity", root)
         bv.Name = "EliteFlyBV"
         bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         bv.Velocity = Vector3.new(0, 0.1, 0)
         
         local bg = Instance.new("BodyGyro", root)
         bg.Name = "EliteFlyBG"
         bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
         bg.P = 15000
         
         task.spawn(function()
            while Flying and root and char.Parent do
               local hum = char:FindFirstChild("Humanoid")
               local cam = workspace.CurrentCamera
               
               if hum and hum.MoveDirection.Magnitude > 0 then
                  -- الطيران باتجاه الكاميرا عند تحريك زر المشي
                  bv.Velocity = cam.CFrame.LookVector * FlySpeed
               else
                  -- الثبات في المكان عند ترك الزر
                  bv.Velocity = Vector3.new(0, 0.1, 0)
               end
               
               bg.CFrame = cam.CFrame
               task.wait()
            end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
         end)
      else
         -- تنظيف عند الإغلاق
         if root:FindFirstChild("EliteFlyBV") then root.EliteFlyBV:Destroy() end
         if root:FindFirstChild("EliteFlyBG") then root.EliteFlyBG:Destroy() end
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "سرعة الطيران",
   Range = {10, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value)
      FlySpeed = Value
   end,
})


PlayerTab:CreateToggle({
   Name = "تفعيل الضربة البعيدة (Hitbox)",
   CurrentValue = false,
   Flag = "HitboxToggle",
   Callback = function(Value)
      _G.HitboxEnabled = Value
      
      -- تشغيل حلقة فحص الأعداء وتكبير حجمهم
      task.spawn(function()
          while _G.HitboxEnabled do
              for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                  -- ملاحظة: تأكد من أن اسم مجلد الأعداء في اللعبة هو Enemies أو غيره حسب الماب
                  if v:FindFirstChild("HumanoidRootPart") then
                      v.HumanoidRootPart.Size = Vector3.new(25, 25, 25) -- تكبير حجم العدو لتستطيع ضربه من بعيد
                      v.HumanoidRootPart.Transparency = 0.8 -- جعل الصندوق شبه شفاف لكي لا يزعجك
                      v.HumanoidRootPart.CanCollide = false
                  end
              end
              task.wait(1) -- فحص كل ثانية لتوفير الفريمات
          end
          
          -- إرجاع الأعداء لحجمهم الطبيعي عند إطفاء الميزة
          if not _G.HitboxEnabled then
              for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                  if v:FindFirstChild("HumanoidRootPart") then
                      v.HumanoidRootPart.Size = Vector3.new(2, 2, 1) -- الحجم الطبيعي
                      v.HumanoidRootPart.Transparency = 1
                  end
              end
          end
      end)
   end,
})

PlayerTab:CreateToggle({
   Name = "انتقال سريع عند الضغط (Click TP)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ClickTP = Value
      local Mouse = game.Players.LocalPlayer:GetMouse()
      Mouse.Button1Down:Connect(function()
          if _G.ClickTP and game.Players.LocalPlayer.Character then
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit + Vector3.new(0, 3, 0)
          end
      end)
   end,
})

PlayerTab:CreateToggle({
   Name = "تثبيت الكاميرا على الخصم (Lock Camera)",
   CurrentValue = false,
   Callback = function(Value)
      _G.LockCam = Value
      task.spawn(function()
          while _G.LockCam do
              local closestPlayer = nil
              local shortestDistance = math.huge
              for _, v in pairs(game.Players:GetPlayers()) do
                  if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                      local dist = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                      if dist < shortestDistance then
                          closestPlayer = v
                          shortestDistance = dist
                      end
                  end
              end
              if closestPlayer then
                  workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Character.HumanoidRootPart.Position)
              end
              task.wait()
          end
      end)
   end,
})


-- [[ تبويب الرؤية ]]
VisualsTab:CreateSection("كشف اللاعبين")

VisualsTab:CreateToggle({
   Name = "رؤية اللاعبين (ESP)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      _G.ESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "إضاءة كاملة (Full Bright)",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      if Value then
         game:GetService("Lighting").Brightness = 2
         game:GetService("Lighting").GlobalShadows = false
      else
         game:GetService("Lighting").Brightness = 1
         game:GetService("Lighting").GlobalShadows = true
      end
   end,
})

VisualsTab:CreateSlider({
   Name = "مجال الرؤية (FOV)",
   Range = {70, 120},
   Increment = 1,
   CurrentValue = 70,
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "كشف الأدوات والأسلحة (Universal Items)",
   CurrentValue = false,
   Callback = function(Value)
      _G.ItemESP = Value
      task.spawn(function()
          while _G.ItemESP do
              for _, v in pairs(workspace:GetDescendants()) do
                  -- يبحث عن أي شيء يحتوي على 'Handle' (وهو الجزء الأساسي في أي أداة)
                  if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("Part") then
                      local item = v.Parent.Parent
                      if not item:FindFirstChild("EliteHighlight") then
                          local h = Instance.new("Highlight", item)
                          h.Name = "EliteHighlight"
                          h.FillColor = Color3.fromRGB(255, 255, 0) -- لون أصفر للأدوات
                      end
                  end
              end
              task.wait(5) -- فحص كل 5 ثواني لتقليل اللاق في المابات الكبيرة
          end
      end)
   end,
})

VisualsTab:CreateButton({
   Name = "تفعيل خطوط التتبع (Tracers)",
   Callback = function()
       local lplayer = game.Players.LocalPlayer
       local cam = workspace.CurrentCamera

       local function createTracers(p)
           local line = Drawing.new("Line")
           line.Visible = false
           line.Color = Color3.fromRGB(255, 255, 255)
           line.Thickness = 1
           line.Transparency = 1

           game:GetService("RunService").RenderStepped:Connect(function()
               if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p ~= lplayer then
                   local vector, onscreen = cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                   if onscreen then
                       line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                       line.To = Vector2.new(vector.X, vector.Y)
                       line.Visible = true
                   else
                       line.Visible = false
                   end
               else
                   line.Visible = false
               end
           end)
       end
       for _, v in pairs(game.Players:GetPlayers()) do createTracers(v) end
   end,
})

VisualsTab:CreateToggle({
   Name = "الرؤية الواضحة (Full Bright)",
   CurrentValue = false,
   Callback = function(Value)
      if Value then
          game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
          game:GetService("Lighting").Brightness = 2
          game:GetService("Lighting").FogEnd = 100000
      else
          game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0) -- يعود لإعدادات الماب الأصلية
          game:GetService("Lighting").Brightness = 1
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "رؤية ما وراء الجدران (X-Ray Mode)",
   CurrentValue = false,
   Callback = function(Value)
      for _, v in pairs(workspace:GetDescendants()) do
          if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
              v.LocalTransparencyModifier = Value and 0.5 or 0
          end
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "تكبير رؤوس الأعداء (Huge Head)",
   CurrentValue = false,
   Callback = function(Value)
      _G.HugeHead = Value
      task.spawn(function()
          while _G.HugeHead do
              for _, v in pairs(game.Players:GetPlayers()) do
                  if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                      v.Character.Head.Size = Vector3.new(10, 10, 10) -- رأس عملاق
                      v.Character.Head.Transparency = 0.5
                      v.Character.Head.CanCollide = false
                  end
              end
              task.wait(1)
          end
      end)
   end,
})

VisualsTab:CreateButton({
   Name = "إزالة الضباب نهائياً (No Fog)",
   Callback = function()
       game:GetService("Lighting").FogEnd = 1000000
       for _, v in pairs(game:GetService("Lighting"):GetDescendants()) do
           if v:IsA("Atmosphere") then
               v:Destroy()
           end
       end
       Rayfield:Notify({Title = "Elite Hub", Content = "تم مسح الضباب، الرؤية الآن 100%!"})
   end,
})



---------------------------------------------------------
-- [[ المحركات البرمجية (Loops) ]]
---------------------------------------------------------

-- محرك Auto Clicker
task.spawn(function()
    while task.wait() do
        if _G.AutoClick then
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end
    end
end)

-- محرك الطيران
local RunService = game:GetService("RunService")
local LP = game.Players.LocalPlayer
RunService.RenderStepped:Connect(function()
    if _G.FlyEnabled and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
        local Root = LP.Character.HumanoidRootPart
        local Hum = LP.Character:FindFirstChildOfClass("Humanoid")
        local Camera = workspace.CurrentCamera
        Root.Velocity = Vector3.new(0, 0, 0)
        if Hum.MoveDirection.Magnitude > 0 then
            Root.CFrame = Root.CFrame + (Camera.CFrame.LookVector * (2 * Hum.MoveDirection.Magnitude))
        end
    end
end)

-- محرك القفز اللانهائي
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJumpEnabled and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- محرك Noclip
game:GetService("RunService").Stepped:Connect(function()
    if _G.NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- نظام ESP
local function createESP(p)
    local h = Instance.new("Highlight")
    h.FillTransparency = 0.5
    h.FillColor = Color3.fromRGB(255, 0, 0)
    game:GetService("RunService").RenderStepped:Connect(function()
        if p.Character and _G.ESPEnabled then h.Parent = p.Character else h.Parent = nil end
    end)
end
for _, v in pairs(game.Players:GetPlayers()) do if v ~= game.Players.LocalPlayer then createESP(v) end end
game.Players.PlayerAdded:Connect(createESP)

Rayfield:Notify({
   Title = "Elite Hub",
   Content = "تم تشغيل السكربت بنجاح!",
   Duration = 5,
   Image = 4483362458,
})

--// ================================
--// DELTA ADVANCED INTERCEPTOR + EXTERNAL TOGGLE
--// ================================

local MAX_LOG_SIZE = 500000
local logs = ""

--// UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DEBUG_MONITOR"
gui.DisplayOrder = 999

-- الزر الخارجي (الذي لا يختفي)
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0, 100, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.Text = "Show/Hide"
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.ZIndex = 20
openBtn.Draggable = true -- سحبه في أي مكان

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.7,0,0.7,0)
frame.Position = UDim2.new(0.15,0,0.15,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.ZIndex = 10
frame.Visible = true -- يبدأ ظاهراً

-- تشغيل الزر
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(25,25,25)
title.Text = "Delta Network & Loader Monitor"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 16

local box = Instance.new("TextBox", frame)
box.Position = UDim2.new(0,5,0,35)
box.Size = UDim2.new(1,-10,1,-75)
box.MultiLine = true
box.TextWrapped = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextYAlignment = Enum.TextYAlignment.Top
box.TextSize = 14
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(20,20,20)
box.ClearTextOnFocus = false
box.TextEditable = true
box.Text = ""

local clearBtn = Instance.new("TextButton", frame)
clearBtn.Position = UDim2.new(0,5,1,-35)
clearBtn.Size = UDim2.new(0.3,-10,0,30)
clearBtn.Text = "Clear"
clearBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
clearBtn.TextColor3 = Color3.new(1,1,1)

local copyBtn = Instance.new("TextButton", frame)
copyBtn.Position = UDim2.new(0.35,0,1,-35)
copyBtn.Size = UDim2.new(0.3,-10,0,30)
copyBtn.Text = "Copy All"
copyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
copyBtn.TextColor3 = Color3.new(1,1,1)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Position = UDim2.new(0.7,5,1,-35)
hideBtn.Size = UDim2.new(0.3,-10,0,30)
hideBtn.Text = "Close Frame" -- يغلق الإطار فقط
hideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideBtn.TextColor3 = Color3.new(1,1,1)

--// Logging
local function addLog(text)
    text = tostring(text)
    if #text > 10000 then
        text = string.sub(text,1,10000) .. "\n... [TRUNCATED]"
    end
    logs = logs .. "\n\n" .. text
    if #logs > MAX_LOG_SIZE then
        logs = string.sub(logs, -MAX_LOG_SIZE)
    end
    box.Text = logs
end

clearBtn.MouseButton1Click:Connect(function()
    logs = ""
    box.Text = ""
end)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(logs)
        addLog(">>> Copied to clipboard")
    else
        addLog("Clipboard not supported.")
    end
end)

hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

--// ================================
--// HOOKS (الأكواد الأصلية كما هي)
--// ================================

-- load
if load then
    local oldLoad = load
    hookfunction(load, function(str,...)
        addLog("LOAD CALLED:\n"..str)
        return oldLoad(str,...)
    end)
end

-- loadstring
if loadstring then
    local oldLoadString = loadstring
    hookfunction(loadstring, function(str,...)
        addLog("LOADSTRING:\n"..str)
        return oldLoadString(str,...)
    end)
end

-- request
if request then
    local oldRequest = request
    getgenv().request = function(tbl)
        addLog("REQUEST URL:\n"..tostring(tbl.Url))
        local res = oldRequest(tbl)
        if res and res.Body then
            addLog("RESPONSE BODY:\n"..res.Body)
        end
        return res
    end
end

-- HttpGet via __namecall
local mt = getrawmetatable(game)
if mt then
    setreadonly(mt,false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self,...)
        local method = getnamecallmethod()
        if method == "HttpGet" or method == "HttpGetAsync" then
            addLog("HTTP CALL:\n"..tostring(...))
        end
        return old(self,...)
    end)
    setreadonly(mt,true)
end

addLog(">>> Monitor Loaded Successfully")

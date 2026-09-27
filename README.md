🌌 Aurora UI v3.0 — Fluent macOS Hybrid Edition

Premium • Mobile-First • Leak-Free UI Library for Roblox ExecutorsmacOS Traffic Lights • Fluent Sidebar with Live Search • Acrylic Backgrounds • iOS Toggles • Cumulative Notifications • Config Save/Load System

VersionLanguagePlatformTested

📋 Table of Contents

Overview
Key Features
Installation & Quick Start
Full API Reference
4.1 Aurora.new(config)
4.2 Window:CreateTab()
4.3 Tab:CreateSection()
4.4 Tab:CreateButton()
4.5 Tab:CreateToggle()
4.6 Tab:CreateSlider()
4.7 Tab:CreateDropdown()
4.8 Tab:CreateInput()
4.9 Tab:CreateKeybind()
4.10 Tab:CreateColorpicker()
4.11 Tab:CreateParagraph()
4.12 Tab:CreateProfile()
4.13 Window:Notify()
4.14 Config System
4.15 Window Control
4.16 Utility Methods
Config File Format
Complete Working Example
Executor Compatibility
Best Practices (AI & Devs)
Troubleshooting
1. Overview

Aurora UI is a self-contained, single-file Luau UI library designed for Robloxscript executors (with first-class support for mobile executors such as Delta).

It combines a macOS-style window chrome (three traffic-light buttons) withFluent Design elements (glassmorphism, acrylic backgrounds, soft strokes,circular easing animations) into one stable, high-performance package.

Design Identity

Property	Value
Main Background	Color3.fromRGB(18, 18, 22) (glass, transparency 0.05)
Elements	Color3.fromRGB(28, 28, 35)
Accent	Color3.fromRGB(0, 140, 255) (configurable, purple alternative 138, 43, 226)
Corner Radius	10px on window & containers, 8px on inner controls
Strokes	UIStroke 1px, Transparency 0.85
Fonts	Gotham family (built-in, zero external assets)
Why it is stable on mobile executors

Zero external assets — every icon/glyph is plain text or a gradient. Nothing can 404.
Zero HttpService calls inside the library itself — no network = no executor detection risk.
All sizes use smart Scale + Offset mixing with UISizeConstraint caps, so thewindow never overflows a phone screen.
All ScrollingFrames use AutomaticCanvasSize — elements can never be cut off.
Every connection, thread, tween and cleanup function is tracked and releasedin Destroy() → no memory leaks, ever.
2. Key Features

Feature	Description
🚦 macOS Traffic Lights	Red = exit confirmation dialog, Yellow = minimize to floating orb, Green = maximize / restore size (with smooth tween). Glyphs (✕ − +) appear on hover, exactly like macOS.
🧭 Fluent Sidebar	Tabs with optional icons, active-tab accent glow + side indicator, and a live search bar that instantly filters elements of the active tab.
🖼 Acrylic Backgrounds	Set any image as window background via config.BackgroundImage or SetBackgroundImage(). A dark overlay (Transparency = 0.6) is applied automatically for text readability.
💎 Floating Action Button	Glassmorphic draggable orb with a layered soft shadow, pulsing accent glow, hover scale +10%, press shrink, and click-to-reopen.
🎛 iOS-Style Controls	Toggles with shadowed white knob + press pulse, thin 4px sliders with glowing ring knob, spring-smooth dropdowns.
📐 Resize Grip	Bottom-right ◢ handle. Mouse + Touch. math.clamp limits (320×230 → 560×400), viewport-aware ceiling, keeps top-left corner anchored.
🔔 Cumulative Notifications	UIListLayout with VerticalAlignment = Bottom (old toasts slide up automatically), slide-in/out tweens, lifetime progress bar, max 4 concurrent (oldest auto-dismisses), optional action button with built-in setclipboard support.
💾 Config System	SaveConfig / LoadConfig using JSONEncode + writefile. Persists all registered elements (Toggles, Sliders, Dropdowns, Colorpickers, Inputs, Keybinds) and the user's resized window size.
👤 Developer Profiles	CreateProfile() renders a circular avatar (auto-fallback to initial letter), name, role, and an interactive social button.
🔒 Leak-Free Architecture	OnClose hooks → thread cancel → connection disconnect → GUI destroy, all wrapped in pcall.
3. Installation & Quick Start

Option A — Hosted file (recommended)

Upload the library code to a raw host (GitHub raw, paste service) and load it:

local Aurora = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/Aurora-UI/main/Aurora.lua"))()
Option B — Local (inline)

Paste the entire library source at the top of your script, then:

local Window = Aurora.new({ Title = "My Hub" })local Tab = Window:CreateTab("Main")Tab:CreateButton("Hello", function()    print("Aurora UI works!")end)
⚠️ Note: The library itself never calls game:HttpGet. Only your loaderdoes. If your executor has HTTP disabled, use Option B.

Minimum viable script

local Aurora = loadstring(game:HttpGet("https://your-host/Aurora.lua"))()local Window = Aurora.new({    Title     = "Elite Hub",    ToggleKey = Enum.KeyCode.RightShift, -- show/hide hotkey})local Main = Window:CreateTab("Main")Main:CreateToggle("Speed Hack", false, function(on)    print("Speed Hack:", on)end)
Run it → the window appears centered with a welcome animation.

4. Full API Reference

📌 Element Handle Convention (read this first!)

Several element creators return a Handle table with Set / Getfunctions. These are plain functions stored in fields — call them with adot, not a colon:

local myToggle = Tab:CreateToggle("Fly", false, print)myToggle.Set(true)   -- ✅ correct-- myToggle:Set(true) -- ❌ wrong (passes the table as the value)
Creator	Returns
CreateToggle	{ Container, Set(bool), Get() → bool }
CreateSlider	{ Container, Set(number), Get() → number }
CreateDropdown	{ Container, Set(option), Get() → option }
CreateKeybind	{ Container, Set(KeyCode), Get() → KeyCode }
CreateColorpicker	{ Container, Set(Color3), Get() → Color3 }
CreateButton, CreateSection, CreateInput, CreateParagraph, CreateProfile	The container Frame
4.1 Aurora.new(config) — Create the Window

Creates the main window (ScreenGui + frame + sidebar + traffic lights + FAB +notification host + exit dialog) and plays the opening animation.

local Aurora  = loadstring(game:HttpGet("..."))()local Window  = Aurora.new(config)
Parameters (config: table? — all keys optional):

Key	Type	Default	Description
Title	string	"Aurora UI"	Window title (centered, macOS-style).
ToggleKey	Enum.KeyCode	Enum.KeyCode.RightShift	Global show/hide hotkey.
Accent	Color3	RGB(0,140,255)	Accent color. Use RGB(138,43,226) for purple.
BackgroundImage	string | number	(none)	Optional asset id ("rbxassetid://123" or raw 123). Adds acrylic image + dark overlay.
BackgroundTransparency	number	0	Transparency of the background image.
ExitMessage	string	(built-in)	Text shown in the exit confirmation dialog.
Returns: AuroraWindow object (see all methods below).

Example:

local Window = Aurora.new({    Title       = "Elite Hub",    ToggleKey   = Enum.KeyCode.RightShift,    Accent      = Color3.fromRGB(138, 43, 226),          -- purple theme    BackgroundImage = "rbxassetid://11654020077",        -- optional wallpaper    ExitMessage = "Close Elite Hub? Features will stop.",})
4.2 Window:CreateTab(name, icon?) — Create a Section Tab

Adds a tab to the sidebar. The first created tab is selected automatically.

Parameter	Type	Required	Description
name	string	✅	Tab label (also used as the config key prefix).
icon	string | number	❌	Optional asset id shown left of the label.
Returns: Tab object — the receiver for all Tab:* element creators.

local Main    = Window:CreateTab("Main",    6031225767)  -- with iconlocal Visuals = Window:CreateTab("Visuals")              -- without iconMain.Select()                                            -- programmatically switch to it
4.3 Tab:CreateSection(title) — Divider Label

An uppercase accent-colored label with a hairline underline. Purely visual.

Parameter	Type	Required
title	string	✅
Main:CreateSection("Movement")Main:CreateSection("Combat")
4.4 Tab:CreateButton(name, callback, icon?)

Fire-and-forget action button with a press-pulse animation and optional icon.

Parameter	Type	Required	Description
name	string	✅	Row label.
callback	function()	✅	Runs on click (pcall-protected).
icon	string | number	❌	Small image inside the "Run" pill.
Main:CreateButton("Rejoin Server", function()    game:GetService("TeleportService"):Teleport(game.PlaceId)end, 6034509993)
4.5 Tab:CreateToggle(name, default, callback) — iOS Switch

Modern pill switch: white shadowed knob, press pulse, full-row touch target(mobile friendly).

Parameter	Type	Required
name	string	✅
default	boolean	✅ (use false)
callback	function(state: boolean)	✅
Returns: Handle → .Set(bool), .Get() → bool, .Container

local flyToggle = Main:CreateToggle("Fly", false, function(state)    print("Fly:", state)end)-- Later, programmatically (visual-only, does NOT fire the callback):flyToggle.Set(true)print(flyToggle.Get())  --> true
4.6 Tab:CreateSlider(name, min, max, default, callback)

Thin 4px track, accent fill, glowing ring knob. Mouse + Touch, disables pagescrolling while dragging.

Parameter	Type	Required	Notes
name	string	✅	
min	number	✅	Auto-swaps if greater than max.
max	number	✅	
default	number	✅	Auto-clamped.
callback	function(value: number)	✅	Fires continuously while dragging.
Returns: Handle → .Set(number), .Get() → number, .Container

local speed = Main:CreateSlider("Walk Speed", 16, 200, 16, function(value)    local char = game.Players.LocalPlayer.Character    if char and char:FindFirstChildOfClass("Humanoid") then        char.Humanoid.WalkSpeed = value    endend)speed.Set(100) -- reset programmatically
4.7 Tab:CreateDropdown(name, options, default, callback)

Accordion dropdown with spring-smooth open/close, rotating arrow, and anaccent-highlighted selected row.

Parameter	Type	Required
name	string	✅
options	table<string | number>	✅
default	any (must exist in options)	✅
callback	function(option)	✅
Returns: Handle → .Set(option), .Get() → option, .Container

local target = Main:CreateDropdown("Target Part", {"Head", "Torso", "Random"}, "Head", function(choice)    print("Targeting:", choice)end)target.Set("Random")
4.8 Tab:CreateInput(name, placeholder, callback)

Text field with accent glow on focus. Value is registered in the Config System.

Parameter	Type	Required
name	string	✅
placeholder	string	✅
callback	function(text: string, enterPressed: boolean)	✅
Returns: container Frame.

Main:CreateInput("Webhook URL", "https://discord.com/api/webhooks/...", function(text, enter)    print("Saved:", text, "| pressed Enter:", enter)end)
4.9 Tab:CreateKeybind(name, defaultKey, callback)

Click the pill, press any key to rebind (another mouse/touch press cancels).

Parameter	Type	Required
name	string	✅
defaultKey	Enum.KeyCode	✅
callback	function()	✅ — fires when the bound key is pressed (not while game-processed).
Returns: Handle → .Set(KeyCode), .Get() → KeyCode, .Container

local hideBind = Main:CreateKeybind("Toggle Menu", Enum.KeyCode.RightControl, function()    Window:Toggle()end)hideBind.Set(Enum.KeyCode.F)
4.10 Tab:CreateColorpicker(name, defaultColor, callback)

Swatch that expands a responsive 6-column color grid. Stored/loaded as RGB mapin configs.

Parameter	Type	Required
name	string	✅
defaultColor	Color3	✅
callback	function(color: Color3)	✅
Returns: Handle → .Set(Color3), .Get() → Color3, .Container

local espColor = Visuals:CreateColorpicker("ESP Color", Color3.fromRGB(0,140,255), function(color)    Drawing.Color = color -- example usageend)espColor.Set(Color3.fromRGB(138, 43, 226))
4.11 Tab:CreateParagraph(title, body)

Auto-expanding text card (wrapped). Two call signatures:

Tab:CreateParagraph("Just text, no header")Tab:CreateParagraph("Header Title", "Body text that can be as long as needed and wraps automatically.")
Returns: container Frame (auto-height via AutomaticSize).

4.12 Tab:CreateProfile(name, imageId, role, buttonText, callback)

Developer/social card: circular avatar with accent ring (falls back to thefirst letter of the name when no image is provided), name, role with dot, andan optional interactive button.

Parameter	Type	Required	Description
name	string	✅	Developer name.
imageId	string | number	❌	Pass nil for letter avatar.
role	string	✅	e.g. "Owner & Developer".
buttonText	string?	❌	Omit to hide the button.
callback	function()?	❌	Button click action.
Info:CreateProfile("YourName", 123456789, "Owner & Developer", "Discord", function()    Window:Notify({ Title = "Discord", Message = "Invite copied!", ClipboardText = "https://discord.gg/invite" })end)
4.13 Window:Notify(options) — Notification System

Cumulative toast stack (top-right). New toasts appear at the bottom and pusholder ones upward. Max 4 concurrent — the oldest is auto-dismissed onoverflow. Every toast has a lifetime progress bar and an ✕ close button.

Form 1 — Simple:

Window:Notify(title: string, message: string, duration: number?)
Form 2 — Advanced (table):

Key	Type	Default	Description
Title	string	"Notification"	Bold header.
Message	string	""	Wrapped body (optional).
Duration	number	5	Seconds before auto-dismiss (clamped 1–60).
ButtonText	string?	(none)	Adds a full-width action button.
ClipboardText	string?	(none)	If set, clicking the button copies this via setclipboard/toclipboard and shows "Copied ✓".
ButtonCallback	function()?	(none)	Extra action on button click.
Returns: record table → record.Dismiss() (closes it programmatically).

-- SimpleWindow:Notify("Loaded", "Welcome to Elite Hub!", 4)-- Advanced: copy-to-clipboard buttonlocal toast = Window:Notify({    Title          = "Join our Discord",    Message        = "Daily updates and free keys.",    Duration       = 8,    ButtonText     = "Copy Invite Link",    ClipboardText  = "https://discord.gg/your-invite",    ButtonCallback = function() print("Copied!") end,})task.delay(10, function() toast.Dismiss() end) -- optional manual close
4.14 Config System — SaveConfig / LoadConfig

Persists element states and the resized window size to a JSON file.

local ok, pathOrError    = Window:SaveConfig(folderName: string?, fileName: string?)local ok, appliedOrError = Window:LoadConfig(folderName: string?, fileName: string?)
Parameter	Type	Default
folderName	string	"AuroraUI"
fileName	string	"config"
Returns:

SaveConfig → ok: boolean, path: string (or error message).
LoadConfig → ok: boolean, applied: number (count of restored values, or error message).
What gets saved: Toggle, Slider, Dropdown, Colorpicker, Input,Keybind — every element created through this library is auto-registered.Button, Section, Paragraph, Profile are visual-only and skipped.

Key rules:

Keys are "TabName/ElementName" → keep element names unique per tab.Duplicates are auto-suffixed (Combat/Kill Aura#2) and will still work, butavoid relying on them.
LoadConfig applies values silently — callbacks are NOT fired. Afterloading, read states via handles (handle.Get()) to sync gameplay.
Requires writefile/readfile (config) and isfolder/makefolder(auto-created folder). On executors without a file system it returnsfalse, "This executor does not support the file system" instead of crashing.
Recommended pattern — auto-load on start, auto-save on exit:

local CONFIG = { "EliteHub", "config" }task.delay(0.5, function() Window:LoadConfig(CONFIG[1], CONFIG[2]) end)Window:OnClose(function()    Window:SaveConfig(CONFIG[1], CONFIG[2])end)
ℹ️ OnClose callbacks run before the window is torn down(Destroy() ordering), so saving inside them always works.

4.15 Window Control — Toggle, OnClose, Destroy

Window:Toggle()          -- show if hidden, hide (to floating orb) if shownWindow:OnClose(function) -- register a cleanup/save hook (pcall-wrapped)Window:Destroy()         -- full teardown: OnClose hooks → threads → connections → GUI
Window:OnClose(function()    print("Saving world state...")    Window:SaveConfig("EliteHub", "config")end)
4.16 Utility Methods

Window:GetWindowSize() → width, height

Current pixel size of the window (includes Resize-Grip changes).

local w, h = Window:GetWindowSize()print(w, h) --> 480 340
Window:SetWindowSize(width, height) → boolean

Applies a size with the same safety rails as the grip (min 320×230,max 560×400, viewport ceiling). Cancels maximize state.

Window:SetWindowSize(500, 380)
Window:SetBackgroundImage(asset, transparency?) → boolean

Swaps the acrylic wallpaper at runtime (fades in, overlay auto-shown).Pass nil to fade out and remove.

Window:SetBackgroundImage("rbxassetid://11654020077", 0.1)Window:ClearBackgroundImage() -- alias for SetBackgroundImage(nil)
Window:Spawn(fn, ...) → thread

Runs a function in a managed coroutine (auto-cancelled on Destroy).

Window:Spawn(function()    while not Window.Destroyed do        task.wait(1)        -- background logic    endend)
Window:Track(connection) → connection

Registers any RBXScriptConnection for automatic disconnect on destroy.

Window:Track(workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()    -- camera-dependent logicend))
Library properties

Aurora.Version  --> "3.0.0"Aurora.Theme    --> shared theme table (Background, Element, Accent, ...)Window.Registry --> live table of registered config entries
5. Config File Format

Saved at <executor workspace>/<Folder>/<File>.json:

{  "WindowSize": { "W": 480, "H": 340 },  "Elements": {    "Main/Fly":              { "T": "Toggle",     "V": true },    "Main/Walk Speed":       { "T": "Slider",     "V": 120 },    "Main/Target Part":      { "T": "Dropdown",   "V": "Head" },    "Main/Webhook URL":      { "T": "Input",      "V": "https://..." },    "Visuals/ESP Color":     { "T": "Colorpicker","V": { "R": 0.0, "G": 0.549, "B": 1.0 } },    "Settings/Toggle Menu":  { "T": "Keybind",    "V": "RightControl" }  }}
WindowSize is restored first (through SetWindowSize, so phone-screenceilings still apply even if the file came from a bigger device).
Colorpicker values round-trip through an {R, G, B} map because Color3is not JSON-serializable directly.
6. Complete Working Example

A single copy-paste script using every feature of the library:

--═══════════════════════════════════════════════════════════════════--  ELITE HUB • Complete Aurora UI v3.0 Demo (works instantly)--═══════════════════════════════════════════════════════════════════local Aurora = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/Aurora-UI/main/Aurora.lua"))()local CONFIG_FOLDER = "EliteHub"local CONFIG_FILE   = "config"local AUTO_SAVE     = true-- [1] Window ----------------------------------------------------------local Window = Aurora.new({    Title           = "Elite Hub",    ToggleKey       = Enum.KeyCode.RightShift,    Accent          = Color3.fromRGB(0, 140, 255),    BackgroundImage = "rbxassetid://11654020077", -- remove this line for plain glass    ExitMessage     = "Close Elite Hub? All active features will be terminated.",})-- [2] MAIN TAB --------------------------------------------------------local Main = Window:CreateTab("Main", 6031225767)Main:CreateSection("Movement")local flyToggle = Main:CreateToggle("Fly", false, function(state)    print("[EliteHub] Fly:", state)end)local speedSlider = Main:CreateSlider("Walk Speed", 16, 200, 16, function(value)    local char = game.Players.LocalPlayer.Character    if char and char:FindFirstChildOfClass("Humanoid") then        char.Humanoid.WalkSpeed = value    endend)Main:CreateButton("Reset Speed", function()    speedSlider.Set(16) -- dot-call! (plain function stored in a field)end, 6034509993)        -- optional icon asset idMain:CreateSection("Targeting")local targetDropdown = Main:CreateDropdown("Target Part", {"Head", "Torso", "Random"}, "Head", function(choice)    print("[EliteHub] Target:", choice)end)Main:CreateButton("Show Current Target", function()    Window:Notify("Current Target", tostring(targetDropdown.Get()), 3)end)-- [3] VISUALS TAB -----------------------------------------------------local Visuals = Window:CreateTab("Visuals", 4483345998)Visuals:CreateSection("ESP")Visuals:CreateToggle("ESP Enabled", false, function(on)    print("[EliteHub] ESP:", on)end)local espColor = Visuals:CreateColorpicker("ESP Color", Color3.fromRGB(0, 140, 255), function(color)    print("[EliteHub] ESP color:", color)end)Visuals:CreateDropdown("ESP Style", {"Box", "Highlight", "Chams"}, "Box", function(style)    print("[EliteHub] ESP style:", style)end)Visuals:CreateParagraph("How it works",    "ESP is rendered locally on your device only. Change the color anytime — " ..    "it is saved automatically inside your config file.")-- [4] SETTINGS TAB ----------------------------------------------------local Settings = Window:CreateTab("Settings", 6031280882)Settings:CreateSection("General")Settings:CreateInput("Webhook URL", "https://discord.com/api/webhooks/...", function(text, enter)    print("[EliteHub] Webhook:", text, "| Enter:", enter)end)Settings:CreateKeybind("Quick Hide", Enum.KeyCode.RightControl, function()    Window:Toggle()end)Settings:CreateToggle("Auto Save on Exit", AUTO_SAVE, function(on)    AUTO_SAVE = onend)Settings:CreateSection("Configuration")Settings:CreateButton("💾 Save Config", function()    local ok, result = Window:SaveConfig(CONFIG_FOLDER, CONFIG_FILE)    Window:Notify({        Title   = ok and "Config Saved ✓" or "Save Failed",        Message = tostring(result),        Duration = 4,    })end)Settings:CreateButton("📂 Load Config", function()    local ok, result = Window:LoadConfig(CONFIG_FOLDER, CONFIG_FILE)    Window:Notify({        Title   = ok and ("Config Loaded ✓ (" .. tostring(result) .. " values)") or "Load Failed",        Message = ok and "Elements restored silently (no callbacks fired)." or tostring(result),        Duration = 4,    })end)Settings:CreateButton("🖼 Change Wallpaper", function()    Window:SetBackgroundImage("rbxassetid://9479755291", 0.15)end)Settings:CreateButton("🗑 Remove Wallpaper", function()    Window:ClearBackgroundImage()end)-- [5] INFO TAB --------------------------------------------------------local Info = Window:CreateTab("Info", 9403376148)Info:CreateProfile("YourName", 123456789, "Owner & Developer", "Discord", function()    Window:Notify({        Title         = "Discord",        Message       = "Invite link copied to your clipboard!",        Duration      = 6,        ButtonText    = "Copy Again",        ClipboardText = "https://discord.gg/your-invite",        ButtonCallback = function()            print("[EliteHub] Invite copied!")        end,    })end)Info:CreateParagraph("Welcome!",    "Resize the window with the ◢ grip in the bottom-right corner. " ..    "The green macOS light maximizes/restores, the yellow one minimizes to " ..    "the floating orb, and RightShift toggles everything.")-- [6] PROGRAMMATIC CONTROL DEMO ---------------------------------------task.delay(4, function()    espColor.Set(Color3.fromRGB(138, 43, 226)) -- silent UI update    print("[EliteHub] ESP color changed programmatically:", espColor.Get())end)-- [7] STARTUP / SHUTDOWN HOOKS ----------------------------------------task.delay(0.5, function()    local ok, result = Window:LoadConfig(CONFIG_FOLDER, CONFIG_FILE)    if ok then        print("[EliteHub] Config restored:", result, "values")    endend)Window:OnClose(function()    if AUTO_SAVE then        local ok = Window:SaveConfig(CONFIG_FOLDER, CONFIG_FILE)        print("[EliteHub] Auto-save on exit:", ok)    endend)-- [8] WELCOME NOTIFICATIONS -------------------------------------------Window:Notify("Welcome", "Elite Hub loaded successfully!", 4)task.delay(2, function()    Window:Notify({        Title         = "Join our community",        Message       = "Daily updates, support and free scripts.",        Duration      = 8,        ButtonText    = "Copy Discord Link",        ClipboardText = "https://discord.gg/your-invite",    })end)
Replace YOUR_USERNAME and the placeholder asset ids with your own.

7. Executor Compatibility

Executor	Status	Notes
Delta (Android/iOS)	✅ Full	Primary target. Touch-optimized.
Codex / Hydrogen	✅ Full	
Fluxus / Arceus X	✅ Full	
Synapse Z / Wave	✅ Full	Uses syn.protect_gui when available.
KRNL / Swift	✅ Full	
Any Lua-capable executor	⚠️ Degraded	Config system returns a friendly error if writefile is missing; clipboard button shows no copy if setclipboard is missing. No crashes either way.
Functions used (all optional-guarded): gethui, syn.protect_gui,writefile, readfile, isfolder, makefolder, setclipboard,toclipboard, clipboard.set.

8. Best Practices for AI Models & Developers

When generating scripts with this library, follow these rules to avoid errors:

Dot-call the handles. handle.Set(x) / handle.Get() — never handle:Set(x).
LoadConfig is silent. It updates the UI but does not fire callbacks.Read back values with handle.Get() to sync your exploit logic.
Unique names per tab. Config keys are "Tab/Element". Renaming anelement invalidates its saved value.
Never call window methods after Destroy(). Guard long loops withif Window.Destroyed then break end or use Window:Spawn().
Wrap risky logic in your callbacks yourself if needed — the librarypcalls them and logs [Aurora] ... callback error, but your feature logicis your responsibility.
Assets must be valid rbxassetid values (numbers or fullrbxassetid://... strings). Invalid ids simply render blank — no errors.
Sliders fire continuously while dragging. For expensive actions(teleports, remotes), debounce inside your callback.
Keep one window per script. Creating multiple windows is possible butthey overlay each other.
Prefer Window:Spawn over raw coroutine/spawn for background workso threads are cleaned up on destroy.
Use task.delay, not wait, in examples you generate.
9. Troubleshooting / FAQ

SaveConfig returns "This executor does not support the file system"
The notification button doesn't copy anything
Search hides my elements
The sidebar search filters the active tab only. Clear the search box torestore everything; switching tabs re-applies the current filter.
Window doesn't appear
Config size didn't restore exactly
Can I change the theme colors after creation?
 Aurora UI v3.0 — Built with ❤️ for the executor community.
 Single file • Zero dependencies • Zero external assets • Zero leaks.


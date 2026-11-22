--[[
    ORBIT HUB — Blox Fruits-inspired UI framework
    Place this LocalScript in StarterPlayer > StarterPlayerScripts in your
    own Roblox Studio experience.

    This is an original GUI framework, not Banana Hub code.
    It does not exploit Blox Fruits, automate farming, inspect other players,
    or invoke remote events. The controls below are UI/demo settings.
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("OrbitHub")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(13, 15, 22),
    panel = Color3.fromRGB(20, 23, 33),
    panel2 = Color3.fromRGB(27, 31, 44),
    stroke = Color3.fromRGB(48, 55, 73),
    text = Color3.fromRGB(239, 242, 250),
    muted = Color3.fromRGB(145, 154, 176),
    accent = Color3.fromRGB(139, 92, 246),
    accent2 = Color3.fromRGB(91, 141, 239),
    green = Color3.fromRGB(67, 196, 139),
    red = Color3.fromRGB(230, 91, 105),
}

local function round(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = obj
end

local function outline(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.stroke
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = obj
end

local function padding(obj, left, right, top, bottom)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, left or 0)
    p.PaddingRight = UDim.new(0, right or 0)
    p.PaddingTop = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.Parent = obj
end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local gui = make("ScreenGui", {
    Name = "OrbitHub",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(760, 500),
    Position = UDim2.new(0.5, -380, 0.5, -250),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
}, gui)
round(main, 16)
outline(main, C.stroke)

local scale = make("UIScale", {Scale = 1}, main)
local function updateScale()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    scale.Scale = math.clamp(math.min(v.X / 900, v.Y / 650), 0.62, 1)
end
updateScale()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end

-- Dragging
local dragging, dragStart, startPos
local topbar = make("Frame", {
    Name = "Topbar",
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, main)
round(topbar, 16)
local topFix = make("Frame", {
    Position = UDim2.new(0, 0, 1, -16),
    Size = UDim2.new(1, 0, 0, 16),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, topbar)

local logo = make("Frame", {
    Position = UDim2.fromOffset(18, 13),
    Size = UDim2.fromOffset(36, 36),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
}, topbar)
round(logo, 11)
make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamBold,
    Text = "O",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 21,
}, logo)

make("TextLabel", {
    Position = UDim2.fromOffset(64, 11),
    Size = UDim2.fromOffset(220, 22),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "ORBIT HUB",
    TextColor3 = C.text,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
}, topbar)
make("TextLabel", {
    Position = UDim2.fromOffset(64, 33),
    Size = UDim2.fromOffset(280, 17),
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "BLOX FRUITS-INSPIRED INTERFACE",
    TextColor3 = C.muted,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, topbar)

local status = make("TextLabel", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -62, 0.5, 0),
    Size = UDim2.fromOffset(130, 28),
    BackgroundColor3 = C.panel2,
    Font = Enum.Font.GothamMedium,
    Text = "●  UI READY",
    TextColor3 = C.green,
    TextSize = 10,
}, topbar)
round(status, 8)

local close = make("TextButton", {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Color3.fromRGB(55, 36, 49),
    Text = "×",
    TextColor3 = C.red,
    TextSize = 20,
    Font = Enum.Font.Gotham,
    AutoButtonColor = true,
}, topbar)
round(close, 9)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(14, 76),
    Size = UDim2.new(0, 174, 1, -90),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0,
}, main)
round(sidebar, 12)
padding(sidebar, 10, 10, 12, 10)

make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 22),
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "NAVIGATION",
    TextColor3 = C.muted,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
}, sidebar)

local navList = make("Frame", {
    Position = UDim2.fromOffset(0, 30),
    Size = UDim2.new(1, 0, 1, -30),
    BackgroundTransparency = 1,
}, sidebar)
local navLayout = make("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, navList)

local content = make("Frame", {
    Position = UDim2.fromOffset(202, 76),
    Size = UDim2.new(1, -216, 1, -90),
    BackgroundTransparency = 1,
}, main)

local pages = {}
local navButtons = {}
local currentPage

local function newPage(name)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, content)
    padding(page, 2, 8, 2, 10)
    local list = make("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    pages[name] = page
    return page
end

local function selectPage(name)
    currentPage = name
    for pageName, page in pairs(pages) do page.Visible = pageName == name end
    for pageName, button in pairs(navButtons) do
        local active = pageName == name
        button.BackgroundColor3 = active and Color3.fromRGB(53, 43, 83) or C.panel
        button.TextColor3 = active and Color3.new(1, 1, 1) or C.muted
    end
end

local function addNav(name, icon, order)
    local b = make("TextButton", {
        Name = name .. "Button",
        LayoutOrder = order,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = C.panel,
        Text = "   " .. icon .. "    " .. name,
        TextColor3 = C.muted,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
    }, navList)
    round(b, 9)
    navButtons[name] = b
    b.MouseButton1Click:Connect(function() selectPage(name) end)
end

local function section(parent, title, subtitle)
    local card = make("Frame", {
        Size = UDim2.new(1, -4, 0, 58),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = C.panel,
        BorderSizePixel = 0,
    }, parent)
    round(card, 11)
    outline(card)
    padding(card, 14, 14, 12, 12)
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = C.text,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    if subtitle then
        make("TextLabel", {
            Position = UDim2.fromOffset(0, 22),
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Font = Enum.Font.Gotham,
            Text = subtitle,
            TextColor3 = C.muted,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, card)
    end
    local body = make("Frame", {
        Position = UDim2.fromOffset(0, subtitle and 48 or 26),
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, card)
    make("UIListLayout", {Padding = UDim.new(0, 8)}, body)
    return body
end

local function infoRow(parent, title, detail)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = C.panel2,
        BorderSizePixel = 0,
    }, parent)
    round(row, 8)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 4),
        Size = UDim2.new(1, -20, 0, 16),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = title,
        TextColor3 = C.text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 21),
        Size = UDim2.new(1, -20, 0, 15),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = detail,
        TextColor3 = C.muted,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
end

local function toggleRow(parent, label, description, default, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = C.panel2,
        BorderSizePixel = 0,
    }, parent)
    round(row, 8)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 6),
        Size = UDim2.new(1, -75, 0, 17),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = label,
        TextColor3 = C.text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 24),
        Size = UDim2.new(1, -75, 0, 14),
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        Text = description,
        TextColor3 = C.muted,
        TextSize = 8,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local on = default == true
    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(42, 23),
        BackgroundColor3 = on and C.accent or C.stroke,
        Text = on and "ON" or "OFF",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
    }, row)
    round(button, 7)
    button.MouseButton1Click:Connect(function()
        on = not on
        button.Text = on and "ON" or "OFF"
        TweenService:Create(button, TweenInfo.new(0.14), {
            BackgroundColor3 = on and C.accent or C.stroke,
        }):Play()
        if callback then callback(on) end
    end)
end

local function actionRow(parent, label, buttonText, callback)
    local row = make("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.panel2,
        BorderSizePixel = 0,
    }, parent)
    round(row, 8)
    make("TextLabel", {
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, -115, 1, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = label,
        TextColor3 = C.text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)
    local b = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(92, 27),
        BackgroundColor3 = C.accent2,
        Text = buttonText,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
    }, row)
    round(b, 7)
    b.MouseButton1Click:Connect(callback)
end

-- Pages
local dashboard = newPage("Dashboard")
local farm = newPage("Farm")
local fruits = newPage("Fruits")
local travel = newPage("Travel")
local playerPage = newPage("Player")
local settings = newPage("Settings")

addNav("Dashboard", "⌂", 1)
addNav("Farm", "◈", 2)
addNav("Fruits", "✦", 3)
addNav("Travel", "➤", 4)
addNav("Player", "◎", 5)
addNav("Settings", "⚙", 6)

local welcome = section(dashboard, "Welcome to Orbit Hub", "An original, customizable interface framework.")
infoRow(welcome, "Profile", player.DisplayName .. "  (@" .. player.Name .. ")")
infoRow(welcome, "Experience", "Blox Fruits-inspired layout")
infoRow(welcome, "Status", "Interface loaded successfully")

local quick = section(dashboard, "Quick controls", "These switches demonstrate UI state only.")
toggleRow(quick, "Compact mode", "Demo preference; does not alter the game.", false)
toggleRow(quick, "Notifications", "Demo preference; no game events are monitored.", true)
toggleRow(quick, "Show status badge", "Demo preference.", true)

local farmBody = section(farm, "Farm panel", "UI controls only — no farming automation is included.")
toggleRow(farmBody, "Farm enabled", "Demo switch; does not attack or move your character.", false)
toggleRow(farmBody, "Quest helper", "Demo switch; does not accept or complete quests.", false)
toggleRow(farmBody, "Mob selection", "Demo switch; no NPC scanning is performed.", false)

local fruitBody = section(fruits, "Fruit panel", "Manual notes and interface preferences.")
infoRow(fruitBody, "Fruit notifier", "Not connected to game-world fruit events.")
toggleRow(fruitBody, "Notifier display", "Demo switch only.", false)
toggleRow(fruitBody, "Play alert sound", "Demo switch only.", false)
actionRow(fruitBody, "Fruit checklist", "OPEN", function()
    status.Text = "●  CHECKLIST READY"
    status.TextColor3 = C.green
end)

local travelBody = section(travel, "Travel panel", "Teleport destinations are not configured for this experience.")
infoRow(travelBody, "Destination list", "Add your own place destinations in your own game.")
actionRow(travelBody, "Show travel notice", "NOTICE", function()
    status.Text = "●  NO DESTINATIONS"
    status.TextColor3 = C.muted
end)

local playerBody = section(playerPage, "Player panel", "Read-only profile information.")
infoRow(playerBody, "Username", player.Name)
infoRow(playerBody, "Display name", player.DisplayName)
infoRow(playerBody, "User ID", tostring(player.UserId))

local settingsBody = section(settings, "Interface settings", "Customize this UI framework.")
toggleRow(settingsBody, "Open by default", "The hub opens when this LocalScript runs.", true)
actionRow(settingsBody, "Reset window position", "CENTER", function()
    main.Position = UDim2.new(0.5, -380, 0.5, -250)
end)
actionRow(settingsBody, "Close hub", "CLOSE", function()
    gui:Destroy()
end)

selectPage("Dashboard")

-- RightShift hides/shows the interface.
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

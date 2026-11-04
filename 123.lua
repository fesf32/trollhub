-- LocalScript: Troll Hub Pro (النسخة النهائية مع تحكم السرعة واختراق الجدران في التبويبات العلوية)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local customName = "اسمك_الوهمي"
local headSize = 5
local customSpeed = 32
local headScalerEnabled = false
local espEnabled = false
local aimbotEnabled = false
local speedEnabled = false
local noclipEnabled = false
local savedPosition = nil
local isGuiVisible = true
local trackedCharacters = {}
local espHighlights = {}

-- قائمة الحماية والاستثناءات للايم بوت
local ignoredUsernames = {}
local isDropdownOpen = false

-- إنشاء الواجهة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollHubProTabsHell"
screenGui.ResetOnSpawn = false

local success, _ = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- الإطار الرئيسي العريض
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 345)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -172)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 6, 6)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 25, 25)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- خلفية الهيكل العظمي المرعب الأصلية
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "SkeletonBackground"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = "rbxassetid://6071575915"
bgImage.ImageColor3 = Color3.fromRGB(240, 50, 50)
bgImage.ImageTransparency = 0.2
bgImage.BackgroundTransparency = 1
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 1
bgImage.Parent = mainFrame

-- طبقة تعتيم خفيفة
local bgOverlay = Instance.new("Frame")
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.BackgroundColor3 = Color3.fromRGB(10, 4, 4)
bgOverlay.BackgroundTransparency = 0.45
bgOverlay.BorderSizePixel = 0
bgOverlay.ZIndex = 1
bgOverlay.Parent = mainFrame

-- شريط العنوان العلوي
local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1, 0, 0, 36)
headerBar.BackgroundColor3 = Color3.fromRGB(20, 6, 6)
headerBar.BackgroundTransparency = 0.2
headerBar.BorderSizePixel = 0
headerBar.ZIndex = 2
headerBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "≡ Troll Hub Pro"
titleLabel.TextColor3 = Color3.fromRGB(255, 75, 75)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 2
titleLabel.Parent = headerBar

local keyHintLabel = Instance.new("TextLabel")
keyHintLabel.Size = UDim2.new(0, 120, 1, 0)
keyHintLabel.Position = UDim2.new(1, -130, 0, 0)
keyHintLabel.BackgroundTransparency = 1
keyHintLabel.Text = "[F5] إخفاء/إظهار"
keyHintLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
keyHintLabel.TextSize = 11
keyHintLabel.Font = Enum.Font.GothamMedium
keyHintLabel.ZIndex = 2
keyHintLabel.Parent = headerBar

-- شريط التبويبات العلوي (التفاعلي)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 28)
tabBar.Position = UDim2.new(0, 0, 0, 36)
tabBar.BackgroundColor3 = Color3.fromRGB(18, 14, 14)
tabBar.BackgroundTransparency = 0.25
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = mainFrame

-- حاويات محتوى التبويبات
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = true
mainContainer.Parent = mainFrame

local farmContainer = Instance.new("Frame")
farmContainer.Size = UDim2.new(1, 0, 1, 0)
farmContainer.BackgroundTransparency = 1
farmContainer.Visible = false
farmContainer.Parent = mainFrame

local fishingContainer = Instance.new("Frame")
fishingContainer.Size = UDim2.new(1, 0, 1, 0)
fishingContainer.BackgroundTransparency = 1
fishingContainer.Visible = false
fishingContainer.Parent = mainFrame

-- أزرار التبويبات العلوية
local tabMain = Instance.new("TextButton")
tabMain.Size = UDim2.new(0.2, 0, 1, 0)
tabMain.Position = UDim2.new(0, 0, 0, 0)
tabMain.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
tabMain.Text = "MAIN"
tabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMain.Font = Enum.Font.GothamBold
tabMain.TextSize = 11
tabMain.ZIndex = 2
tabMain.Parent = tabBar

local tabFarm = Instance.new("TextButton")
tabFarm.Size = UDim2.new(0.2, 0, 1, 0)
tabFarm.Position = UDim2.new(0.2, 0, 0, 0)
tabFarm.BackgroundTransparency = 1
tabFarm.Text = "FARM (السرعة)"
tabFarm.TextColor3 = Color3.fromRGB(130, 130, 140)
tabFarm.Font = Enum.Font.GothamBold
tabFarm.TextSize = 10
tabFarm.ZIndex = 2
tabFarm.Parent = tabBar

local tabFishing = Instance.new("TextButton")
tabFishing.Size = UDim2.new(0.2, 0, 1, 0)
tabFishing.Position = UDim2.new(0.4, 0, 0, 0)
tabFishing.BackgroundTransparency = 1
tabFishing.Text = "FISHING (جدران)"
tabFishing.TextColor3 = Color3.fromRGB(130, 130, 140)
tabFishing.Font = Enum.Font.GothamBold
tabFishing.TextSize = 10
tabFishing.ZIndex = 2
tabFishing.Parent = tabBar

local tabProtect = Instance.new("TextLabel")
tabProtect.Size = UDim2.new(0.2, 0, 1, 0)
tabProtect.Position = UDim2.new(0.6, 0, 0, 0)
tabProtect.BackgroundTransparency = 1
tabProtect.Text = "PROTECT"
tabProtect.TextColor3 = Color3.fromRGB(130, 130, 140)
tabProtect.Font = Enum.Font.GothamBold
tabProtect.TextSize = 10
tabProtect.ZIndex = 2
tabProtect.Parent = tabBar

local tabMisc = Instance.new("TextLabel")
tabMisc.Size = UDim2.new(0.2, 0, 1, 0)
tabMisc.Position = UDim2.new(0.8, 0, 0, 0)
tabMisc.BackgroundTransparency = 1
tabMisc.Text = "MISC"
tabMisc.TextColor3 = Color3.fromRGB(130, 130, 140)
tabMisc.Font = Enum.Font.GothamBold
tabMisc.TextSize = 10
tabMisc.ZIndex = 2
tabMisc.Parent = tabBar

-- تفعيل التنقل بين التبويبات
tabMain.MouseButton1Click:Connect(function()
    mainContainer.Visible = true
    farmContainer.Visible = false
    fishingContainer.Visible = false
    tabMain.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
    tabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabFarm.BackgroundTransparency = 1
    tabFarm.TextColor3 = Color3.fromRGB(130, 130, 140)
    tabFishing.BackgroundTransparency = 1
    tabFishing.TextColor3 = Color3.fromRGB(130, 130, 140)
end)

tabFarm.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
    farmContainer.Visible = true
    fishingContainer.Visible = false
    tabFarm.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
    tabFarm.BackgroundTransparency = 0
    tabFarm.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMain.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabMain.TextColor3 = Color3.fromRGB(130, 130, 140)
    tabFishing.BackgroundTransparency = 1
    tabFishing.TextColor3 = Color3.fromRGB(130, 130, 140)
end)

tabFishing.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
    farmContainer.Visible = false
    fishingContainer.Visible = true
    tabFishing.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
    tabFishing.BackgroundTransparency = 0
    tabFishing.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMain.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    tabMain.TextColor3 = Color3.fromRGB(130, 130, 140)
    tabFarm.BackgroundTransparency = 1
    tabFarm.TextColor3 = Color3.fromRGB(130, 130, 140)
end)

-- محتوى تبويب FARM (التحكم بالسرعة وتخصيصها)
local farmContent = Instance.new("Frame")
farmContent.Size = UDim2.new(0.96, 0, 0, 270)
farmContent.Position = UDim2.new(0.02, 0, 0, 68)
farmContent.BackgroundTransparency = 1
farmContent.ZIndex = 2
farmContent.Parent = farmContainer

local speedToggleBtn = Instance.new("TextButton")
speedToggleBtn.Size = UDim2.new(1, 0, 0, 44)
speedToggleBtn.Position = UDim2.new(0, 0, 0, 10)
speedToggleBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 25)
speedToggleBtn.BackgroundTransparency = 0.2
speedToggleBtn.Text = "تشغيل/إيقاف السرعة الخارقة: معطل"
speedToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggleBtn.Font = Enum.Font.GothamBold
speedToggleBtn.TextSize = 12
speedToggleBtn.ZIndex = 2
speedToggleBtn.Parent = farmContent
Instance.new("UICorner", speedToggleBtn).CornerRadius = UDim.new(0, 6)

local speedControlBox = Instance.new("Frame")
speedControlBox.Size = UDim2.new(1, 0, 0, 46)
speedControlBox.Position = UDim2.new(0, 0, 0, 65)
speedControlBox.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
speedControlBox.BackgroundTransparency = 0.25
speedControlBox.ZIndex = 2
speedControlBox.Parent = farmContent
Instance.new("UICorner", speedControlBox).CornerRadius = UDim.new(0, 6)

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
speedLabel.Position = UDim2.new(0.03, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "السرعة الحالية: " .. customSpeed
speedLabel.TextColor3 = Color3.fromRGB(240, 200, 200)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.ZIndex = 2
speedLabel.Parent = speedControlBox

local speedMinus = Instance.new("TextButton")
speedMinus.Size = UDim2.new(0, 40, 0, 30)
speedMinus.Position = UDim2.new(0.7, 0, 0.17, 0)
speedMinus.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
speedMinus.Text = "-5"
speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedMinus.Font = Enum.Font.GothamBold
speedMinus.ZIndex = 2
speedMinus.Parent = speedControlBox
Instance.new("UICorner", speedMinus).CornerRadius = UDim.new(0, 4)

local speedPlus = Instance.new("TextButton")
speedPlus.Size = UDim2.new(0, 40, 0, 30)
speedPlus.Position = UDim2.new(0.85, 0, 0.17, 0)
speedPlus.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
speedPlus.Text = "+5"
speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
speedPlus.Font = Enum.Font.GothamBold
speedPlus.ZIndex = 2
speedPlus.Parent = speedControlBox
Instance.new("UICorner", speedPlus).CornerRadius = UDim.new(0, 4)

speedMinus.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed - 5, 16, 200)
    speedLabel.Text = "السرعة الحالية: " .. customSpeed
end)

speedPlus.MouseButton1Click:Connect(function()
    customSpeed = math.clamp(customSpeed + 5, 16, 200)
    speedLabel.Text = "السرعة الحالية: " .. customSpeed
end)

speedToggleBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedToggleBtn.Text = "السرعة الخارقة: مفعلة (" .. customSpeed .. ")"
        speedToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 60)
    else
        speedToggleBtn.Text = "تشغيل/إيقاف السرعة الخارقة: معطل"
        speedToggleBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 25)
    end
end)

-- محتوى تبويب FISHING (اختراق الجدران Noclip)
local fishingContent = Instance.new("Frame")
fishingContent.Size = UDim2.new(0.96, 0, 0, 270)
fishingContent.Position = UDim2.new(0.02, 0, 0, 68)
fishingContent.BackgroundTransparency = 1
fishingContent.ZIndex = 2
fishingContent.Parent = fishingContainer

local noclipToggleBtn = Instance.new("TextButton")
noclipToggleBtn.Size = UDim2.new(1, 0, 0, 50)
noclipToggleBtn.Position = UDim2.new(0, 0, 0, 20)
noclipToggleBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 25)
noclipToggleBtn.BackgroundTransparency = 0.2
noclipToggleBtn.Text = "👻 اختراق الجدران (Noclip): معطل"
noclipToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggleBtn.Font = Enum.Font.GothamBold
noclipToggleBtn.TextSize = 13
noclipToggleBtn.ZIndex = 2
noclipToggleBtn.Parent = fishingContent
Instance.new("UICorner", noclipToggleBtn).CornerRadius = UDim.new(0, 6)

noclipToggleBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipToggleBtn.Text = "👻 اختراق الجدران (Noclip): مفعل"
        noclipToggleBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 60)
    else
        noclipToggleBtn.Text = "👻 اختراق الجدران (Noclip): معطل"
        noclipToggleBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 25)
    end
end)

-- إطار المحتوى الرئيسي (MAIN)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0.96, 0, 0, 270)
contentFrame.Position = UDim2.new(0.02, 0, 0, 68)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 2
contentFrame.Parent = mainContainer

-- 1. خانة تغيير الاسم الوهمي
local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.72, 0, 0, 34)
nameBox.Position = UDim2.new(0, 0, 0, 6)
nameBox.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
nameBox.BackgroundTransparency = 0.3
nameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameBox.PlaceholderText = "اكتب اسمك الوهمي هنا..."
nameBox.Text = ""
nameBox.TextSize = 12
nameBox.Font = Enum.Font.GothamMedium
nameBox.ZIndex = 2
nameBox.Parent = contentFrame
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)
local strokeBox = Instance.new("UIStroke")
strokeBox.Color = Color3.fromRGB(140, 30, 30)
strokeBox.Transparency = 0.3
strokeBox.Parent = nameBox

local applyNameBtn = Instance.new("TextButton")
applyNameBtn.Size = UDim2.new(0.25, 0, 0, 34)
applyNameBtn.Position = UDim2.new(0.75, 0, 0, 6)
applyNameBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
applyNameBtn.BackgroundTransparency = 0.1
applyNameBtn.Text = "تطبيق ✨"
applyNameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyNameBtn.Font = Enum.Font.GothamBold
applyNameBtn.TextSize = 12
applyNameBtn.ZIndex = 2
applyNameBtn.Parent = contentFrame
Instance.new("UICorner", applyNameBtn).CornerRadius = UDim.new(0, 6)

-- 2. أزرار التشغيل الرئيسية الثلاثة
local function createRowButton(posY, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.32, 0, 0, 36)
    btn.Position = UDim2.new(posY, 0, 0, 44)
    btn.BackgroundColor3 = color
    btn.BackgroundTransparency = 0.25
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.ZIndex = 2
    btn.Parent = contentFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(160, 40, 40)
    s.Transparency = 0.3
    s.Parent = btn
    return btn
end

local headBtn = createRowButton(0, "تكبير الرأس: معطل", Color3.fromRGB(130, 25, 25))
local espBtn = createRowButton(0.34, "كشف الأماكن: معطل", Color3.fromRGB(130, 25, 25))
local aimbotBtn = createRowButton(0.68, "الايم بوت: معطل", Color3.fromRGB(130, 25, 25))

-- 3. قائمة الحماية والاستثناءات المنسدلة
local dropdownToggleBtn = Instance.new("TextButton")
dropdownToggleBtn.Size = UDim2.new(1, 0, 0, 34)
dropdownToggleBtn.Position = UDim2.new(0, 0, 0, 84)
dropdownToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
dropdownToggleBtn.BackgroundTransparency = 0.25
dropdownToggleBtn.Text = "🛡️ قائمة الحماية والاستثناءات (اضغط للفتح) 🔽"
dropdownToggleBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
dropdownToggleBtn.Font = Enum.Font.GothamBold
dropdownToggleBtn.TextSize = 11
dropdownToggleBtn.ZIndex = 3
dropdownToggleBtn.Parent = contentFrame
Instance.new("UICorner", dropdownToggleBtn).CornerRadius = UDim.new(0, 6)
local strokeDrop = Instance.new("UIStroke")
strokeDrop.Color = Color3.fromRGB(140, 30, 30)
strokeDrop.Transparency = 0.3
strokeDrop.Parent = dropdownToggleBtn

local dropdownContainer = Instance.new("ScrollingFrame")
dropdownContainer.Size = UDim2.new(1, 0, 0, 90)
dropdownContainer.Position = UDim2.new(0, 0, 0, 120)
dropdownContainer.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
dropdownContainer.BackgroundTransparency = 0.15
dropdownContainer.BorderSizePixel = 0
dropdownContainer.Visible = false
dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownContainer.ScrollBarThickness = 4
dropdownContainer.ZIndex = 4
dropdownContainer.Parent = contentFrame
Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 6)

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 3)
uiListLayout.Parent = dropdownContainer

local function refreshPlayerDropdown()
    for _, child in ipairs(dropdownContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local ySize = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            ySize = ySize + 30
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, -6, 0, 26)
            pBtn.BackgroundColor3 = table.find(ignoredUsernames, player.Name) and Color3.fromRGB(180, 35, 35) or Color3.fromRGB(35, 12, 12)
            pBtn.Text = "👤 " .. player.DisplayName .. " (@" .. player.Name .. ")"
            pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            pBtn.TextSize = 11
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.ZIndex = 4
            pBtn.Parent = dropdownContainer
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
            
            pBtn.MouseButton1Click:Connect(function()
                local index = table.find(ignoredUsernames, player.Name)
                if index then
                    table.remove(ignoredUsernames, index)
                    pBtn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
                else
                    table.insert(ignoredUsernames, player.Name)
                    pBtn.BackgroundColor3 = Color3.fromRGB(180, 35, 35)
                end
            end)
        end
    end
    dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

dropdownToggleBtn.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    dropdownContainer.Visible = isDropdownOpen
    if isDropdownOpen then
        refreshPlayerDropdown()
        dropdownToggleBtn.Text = "🛡️ إخفاء القائمة 🔼"
    else
        dropdownToggleBtn.Text = "🛡️ قائمة الحماية والاستثناءات (اضغط للفتح) 🔽"
    end
end)

-- 4. التحكم في حجم الرأس (+ و -)
local headControlFrame = Instance.new("Frame")
headControlFrame.Size = UDim2.new(1, 0, 0, 36)
headControlFrame.Position = UDim2.new(0, 0, 0, 122)
headControlFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
headControlFrame.BackgroundTransparency = 0.25
headControlFrame.ZIndex = 2
headControlFrame.Parent = contentFrame
Instance.new("UICorner", headControlFrame).CornerRadius = UDim.new(0, 6)
local strokeHC = Instance.new("UIStroke")
strokeHC.Color = Color3.fromRGB(140, 30, 30)
strokeHC.Transparency = 0.3
strokeHC.Parent = headControlFrame

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(0.5, 0, 1, 0)
sizeLabel.Position = UDim2.new(0.03, 0, 0, 0)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "حجم الرأس الحالي: " .. headSize
sizeLabel.TextColor3 = Color3.fromRGB(240, 200, 200)
sizeLabel.TextSize = 12
sizeLabel.Font = Enum.Font.GothamBold
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.ZIndex = 2
sizeLabel.Parent = headControlFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 32, 0, 24)
minusBtn.Position = UDim2.new(0.73, 0, 0.17, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
minusBtn.BackgroundTransparency = 0.2
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.ZIndex = 2
minusBtn.Parent = headControlFrame
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 32, 0, 24)
plusBtn.Position = UDim2.new(0.86, 0, 0.17, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
plusBtn.BackgroundTransparency = 0.2
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.ZIndex = 2
plusBtn.Parent = headControlFrame
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)

-- 5. أزرار الانتقال (Teleport)
local saveTpBtn = Instance.new("TextButton")
saveTpBtn.Size = UDim2.new(0.49, 0, 0, 36)
saveTpBtn.Position = UDim2.new(0, 0, 0, 162)
saveTpBtn.BackgroundColor3 = Color3.fromRGB(110, 30, 80)
saveTpBtn.BackgroundTransparency = 0.2
saveTpBtn.Text = "💾 حفظ المكان"
saveTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveTpBtn.Font = Enum.Font.GothamBold
saveTpBtn.TextSize = 12
saveTpBtn.ZIndex = 2
saveTpBtn.Parent = contentFrame
Instance.new("UICorner", saveTpBtn).CornerRadius = UDim.new(0, 6)

local doTpBtn = Instance.new("TextButton")
doTpBtn.Size = UDim2.new(0.49, 0, 0, 36)
doTpBtn.Position = UDim2.new(0.51, 0, 0, 162)
doTpBtn.BackgroundColor3 = Color3.fromRGB(30, 110, 50)
doTpBtn.BackgroundTransparency = 0.2
doTpBtn.Text = "🚀 الانتقال للـ Saved"
doTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
doTpBtn.Font = Enum.Font.GothamBold
doTpBtn.TextSize = 12
doTpBtn.ZIndex = 2
doTpBtn.Parent = contentFrame
Instance.new("UICorner", doTpBtn).CornerRadius = UDim.new(0, 6)

-- البرمجة والوظائف الداخلية وتطبيق السرعة و Noclip
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char and customName ~= "" then
        pcall(function()
            LocalPlayer.DisplayName = customName
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayName = customName end
            
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("TextLabel") and (obj.Text:find(LocalPlayer.Name) or obj.Text == "Cq_1n") then
                    if obj.Text ~= customName and not obj.Text:find("@") then
                        obj.Text = customName
                    end
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("TextLabel") and not obj.Text:find("@") then
                    obj.Text = customName
                end
            end
        end)
    end
    
    -- تطبيق السرعة
    if char and char:FindFirstChildOfClass("Humanoid") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if speedEnabled then
            hum.WalkSpeed = customSpeed
        else
            hum.WalkSpeed = 16
        end
    end
    
    -- تطبيق اختراق الجدران (Noclip)
    if noclipEnabled and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

applyNameBtn.MouseButton1Click:Connect(function()
    if nameBox.Text ~= "" then
        customName = nameBox.Text
        applyNameBtn.Text = "تم ✔️"
        task.wait(1)
        applyNameBtn.Text = "تطبيق ✨"
    end
end)

local function modifyHead(character)
    if not character then return end
    local head = character:WaitForChild("Head", 5)
    if head and head:IsA("BasePart") then
        if not trackedCharacters[character] then
            trackedCharacters[character] = {
                Head = head,
                OriginalSize = head.Size,
                OriginalCanCollide = head.CanCollide,
                OriginalMassless = head.Massless
            }
        end
        
        if headScalerEnabled then
            head.Size = Vector3.new(headSize, headSize, headSize)
            head.CanCollide = false
            head.Massless = true
        else
            local data = trackedCharacters[character]
            if data then
                head.Size = data.OriginalSize
                head.CanCollide = data.OriginalCanCollide
                head.Massless = data.OriginalMassless
            end
        end
        local mesh = head:FindFirstChildOfClass("SpecialMesh")
        if mesh then mesh.Scale = Vector3.new(1, 1, 1) end
    end
end

local function setupEsp(player, character)
    if player == LocalPlayer then return end
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
    if espEnabled and character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.Parent = character
        highlight.FillColor = Color3.fromRGB(220, 30, 30)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        espHighlights[player] = highlight
    end
end

local function removeEsp(player)
    if espHighlights[player] then
        espHighlights[player]:Destroy()
        espHighlights[player] = nil
    end
end

local function updateAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            modifyHead(player.Character)
            if espEnabled then
                setupEsp(player, player.Character)
            else
                removeEsp(player)
            end
        end
    end
    
    headBtn.Text = headScalerEnabled and ("تكبير الرأس: مفعل (" .. headSize .. ")") or "تكبير الرأس: معطل"
    headBtn.BackgroundColor3 = headScalerEnabled and Color3.fromRGB(35, 140, 60) or Color3.fromRGB(130, 25, 25)
    
    espBtn.Text = espEnabled and "كشف الأماكن: مفعل" or "كشف الأماكن: معطل"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(35, 140, 60) or Color3.fromRGB(130, 25, 25)

    aimbotBtn.Text = aimbotEnabled and "الايم بوت: مفعل" or "الايم بوت: معطل"
    aimbotBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(35, 140, 60) or Color3.fromRGB(130, 25, 25)
    
    sizeLabel.Text = "حجم الرأس الحالي: " .. headSize
end

headBtn.MouseButton1Click:Connect(function()
    headScalerEnabled = not headScalerEnabled
    updateAll()
end)

espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if not espEnabled then
        for player, _ in pairs(espHighlights) do removeEsp(player) end
    end
    updateAll()
end)

aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    updateAll()
end)

plusBtn.MouseButton1Click:Connect(function()
    headSize = math.clamp(headSize + 1, 1, 20)
    updateAll()
end)

minusBtn.MouseButton1Click:Connect(function()
    headSize = math.clamp(headSize - 1, 1, 20)
    updateAll()
end)

saveTpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        saveTpBtn.Text = "تم حفظ المكان! ✔️"
        task.wait(1.5)
        saveTpBtn.Text = "💾 حفظ المكان"
    end
end)

doTpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedPosition then
        char.HumanoidRootPart.CFrame = savedPosition
    end
end)

-- الايم بوت المحمي مع فحص قائمة الاستثناءات
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local targetHead = nil
        local minDist = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local isIgnored = table.find(ignoredUsernames, player.Name) ~= nil
                
                if not isIgnored then
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    local head = player.Character:FindFirstChild("Head")
                    if hum and hum.Health > 0 and head then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local mouseDist = (Vector2.new(screenPos.X, screenPos.Y) - UserInputService:GetMouseLocation()).Magnitude
                            if mouseDist < minDist then
                                minDist = mouseDist
                                targetHead = head
                            end
                        end
                    end
                end
            end
        end
        
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- إخفاء وإظهار الواجهة بـ F5
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
        isGuiVisible = not isGuiVisible
        mainFrame.Visible = isGuiVisible
    end
end)

local function onPlayerAdded(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        modifyHead(character)
        setupEsp(player, character)
    end)
    player.CharacterRemoving:Connect(function()
        removeEsp(player)
    end)
    if isDropdownOpen then refreshPlayerDropdown() end
end

local function onPlayerRemoving(player)
    if isDropdownOpen then refreshPlayerDropdown() end
end

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

updateAll()

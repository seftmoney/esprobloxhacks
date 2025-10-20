-- ESP System Loadstring
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ESP = {
    Enabled = false,
    Objects = {},
    SavedPosition = nil,
    ButtonsVisible = false,
    ButtonFrame = nil,
    WalkSpeed = 16,
    Noclip = false,
    Invisible = false
}

-- Show enhanced loading screen
local function showLoadingScreen()
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "LoadingScreen"
    loadingGui.Parent = game.CoreGui
    loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main background with gradient
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 10))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    mainFrame.Parent = loadingGui

    -- Animated particles in background
    for i = 1, 15 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(4, 10), 0, math.random(4, 10))
        particle.Position = UDim2.new(0, math.random(0, 1000), 0, math.random(0, 600))
        particle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        particle.BorderSizePixel = 0
        particle.Parent = mainFrame
        
        local particleCorner = Instance.new("UICorner")
        particleCorner.CornerRadius = UDim.new(1, 0)
        particleCorner.Parent = particle
        
        -- Animate particle
        spawn(function()
            while particle.Parent do
                local tween = TweenService:Create(particle, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Position = UDim2.new(0, math.random(0, 1000), 0, math.random(0, 600)),
                    BackgroundColor3 = Color3.fromRGB(math.random(200, 255), 0, math.random(50, 100))
                })
                tween:Play()
                wait(3)
            end
        end)
    end

    -- Red accent bar at top with shine effect
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 6)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame

    -- Shine effect on top bar
    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(0, 100, 1, 0)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.7
    shine.BorderSizePixel = 0
    shine.Parent = topBar
    
    local shineTween = TweenService:Create(shine, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
        Position = UDim2.new(1, 0, 0, 0)
    })
    shineTween:Play()

    -- Center content with glass morphism effect
    local centerFrame = Instance.new("Frame")
    centerFrame.Size = UDim2.new(0, 450, 0, 280)
    centerFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
    centerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    centerFrame.BackgroundTransparency = 0.2
    centerFrame.BorderSizePixel = 0
    centerFrame.Parent = mainFrame

    local centerCorner = Instance.new("UICorner")
    centerCorner.CornerRadius = UDim.new(0, 16)
    centerCorner.Parent = centerFrame

    local centerStroke = Instance.new("UIStroke")
    centerStroke.Color = Color3.fromRGB(255, 0, 0)
    centerStroke.Thickness = 3
    centerStroke.Parent = centerFrame

    -- Background blur effect
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = game.Lighting

    -- Title with glow effect
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 70)
    title.Position = UDim2.new(0, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "ESP SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 36
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    title.TextStrokeTransparency = 0.7
    title.Parent = centerFrame

    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Position = UDim2.new(0, 0, 0, 90)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Advanced Player Tracking"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    subtitle.TextSize = 18
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = centerFrame

    -- Made by text with animation
    local madeBy = Instance.new("TextLabel")
    madeBy.Size = UDim2.new(1, 0, 0, 40)
    madeBy.Position = UDim2.new(0, 0, 0, 130)
    madeBy.BackgroundTransparency = 1
    madeBy.Text = "Made by stupidmf_ez 1x"
    madeBy.TextColor3 = Color3.fromRGB(255, 100, 100)
    madeBy.TextSize = 20
    madeBy.Font = Enum.Font.GothamBold
    madeBy.Parent = centerFrame

    -- Animate made by text
    local madeByTween = TweenService:Create(madeBy, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        TextColor3 = Color3.fromRGB(255, 200, 200)
    })
    madeByTween:Play()

    -- Platform text
    local platform = Instance.new("TextLabel")
    platform.Size = UDim2.new(1, 0, 0, 30)
    platform.Position = UDim2.new(0, 0, 0, 170)
    platform.BackgroundTransparency = 1
    platform.Text = "On Roblox | Premium Edition"
    platform.TextColor3 = Color3.fromRGB(150, 150, 150)
    platform.TextSize = 14
    platform.Font = Enum.Font.Gotham
    platform.Parent = centerFrame

    -- Loading bar background
    local loadBarBg = Instance.new("Frame")
    loadBarBg.Size = UDim2.new(0.8, 0, 0, 12)
    loadBarBg.Position = UDim2.new(0.1, 0, 0.8, 0)
    loadBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadBarBg.BorderSizePixel = 0
    loadBarBg.Parent = centerFrame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = loadBarBg

    -- Loading bar fill with gradient
    local loadBar = Instance.new("Frame")
    loadBar.Size = UDim2.new(0, 0, 1, 0)
    loadBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    loadBar.BorderSizePixel = 0
    loadBar.Parent = loadBarBg

    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    barGradient.Parent = loadBar

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = loadBar

    -- Loading percentage text
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(1, 0, 0, 20)
    percentText.Position = UDim2.new(0, 0, 0.7, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "Loading... 0%"
    percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentText.TextSize = 14
    percentText.Font = Enum.Font.GothamBold
    percentText.Parent = centerFrame

    -- Status text
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0, 20)
    statusText.Position = UDim2.new(0, 0, 0.9, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Initializing ESP System..."
    statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = centerFrame

    -- Animate loading bar with percentage updates
    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loadBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    
    -- Update percentage during load
    spawn(function()
        for i = 0, 100, 2 do
            percentText.Text = string.format("Loading... %d%%", i)
            statusText.Text = i < 25 and "Initializing ESP System..." 
                            or i < 50 and "Loading Player Tracking..." 
                            or i < 75 and "Setting Up Interface..." 
                            or "Finalizing..."
            wait(0.08)
        end
    end)
    
    tween:Play()

    -- Remove after animation and clean up
    spawn(function()
        wait(4.2)
        
        -- Fade out animation
        local fadeTween = TweenService:Create(centerFrame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -225, 0.5, -300)
        })
        fadeTween:Play()
        
        wait(0.5)
        loadingGui:Destroy()
        blur:Destroy()
    end)
end

-- Call enhanced loading screen
showLoadingScreen()

-- Simple notification system (smaller)
function ESP:ShowNotification(title, message, duration)
    duration = duration or 5
    
    -- Create screen GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NotificationGUI"
    screenGui.Parent = game.CoreGui

    -- Create main frame (smaller)
    local notification = Instance.new("Frame")
    notification.Name = "PositionNotification"
    notification.Size = UDim2.new(0, 250, 0, 80)
    notification.Position = UDim2.new(1, -270, 1, -100)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notification.BorderSizePixel = 0
    notification.AnchorPoint = Vector2.new(0, 0)
    notification.Parent = screenGui
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notification
    
    -- Red border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = notification
    
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    -- Message label
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0, 25)
    messageLabel.Position = UDim2.new(0, 10, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    -- Progress bar (smaller)
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, -20, 0, 3)
    progressBar.Position = UDim2.new(0, 10, 1, -12)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = notification

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressBar
    
    -- Animate entrance
    notification.Position = UDim2.new(1, 300, 1, -100)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -270, 1, -100)
    })
    tweenIn:Play()
    
    -- Animate progress bar
    local tweenProgress = TweenService:Create(progressBar, TweenInfo.new(duration), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    
    -- Auto remove after duration
    spawn(function()
        tweenProgress:Play()
        wait(duration)
        screenGui:Destroy()
    end)
end

-- Function to find nearest player
function ESP:FindNearestPlayer()
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return nil end
    
    local myHead = myCharacter:FindFirstChild("Head")
    if not myHead then return nil end
    
    local nearestPlayer = nil
    local nearestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local theirHead = player.Character:FindFirstChild("Head")
            if theirHead then
                local distance = (myHead.Position - theirHead.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer, nearestDistance
end

-- Function to teleport to nearest player
function ESP:TeleportToNearestPlayer()
    local nearestPlayer, distance = self:FindNearestPlayer()
    
    if not nearestPlayer then
        self:ShowNotification("Error", "No other players found!", 3)
        return
    end
    
    local myCharacter = LocalPlayer.Character
    local theirCharacter = nearestPlayer.Character
    
    if not myCharacter or not theirCharacter then
        self:ShowNotification("Error", "Cannot teleport - character not found", 3)
        return
    end
    
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local theirRoot = theirCharacter:FindFirstChild("HumanoidRootPart")
    
    if not myRoot or not theirRoot then
        self:ShowNotification("Error", "Cannot teleport - missing HumanoidRootPart", 3)
        return
    end
    
    -- Teleport to nearest player
    myRoot.CFrame = theirRoot.CFrame + Vector3.new(0, 3, 0) -- Slightly above to avoid getting stuck
    
    self:ShowNotification("Teleported", string.format("Teleported to %s (%.1fm away)", 
        nearestPlayer.DisplayName, distance), 4)
end

-- Set walkspeed
function ESP:SetSpeed(speed)
    speed = tonumber(speed)
    if speed and speed > 0 and speed <= 200 then
        self.WalkSpeed = speed
        
        -- Apply to current character
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
        
        self:ShowNotification("Speed Set", string.format("Walk speed: %d", speed), 3)
    else
        self:ShowNotification("Error", "Speed must be between 1-200", 3)
    end
end

-- Apply walkspeed to character when it loads
local function applyWalkSpeed(character)
    wait(1) -- Wait for character to load
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = ESP.WalkSpeed
    end
end

-- Noclip function
function ESP:ToggleNoclip()
    self.Noclip = not self.Noclip
    
    local character = LocalPlayer.Character
    if not character then return end
    
    if self.Noclip then
        -- Enable noclip
        self.NoclipConnection = RunService.Stepped:Connect(function()
            if not self.Noclip then return end
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        self:ShowNotification("Noclip Enabled", "You can walk through walls", 3)
    else
        -- Disable noclip
        if self.NoclipConnection then
            self.NoclipConnection:Disconnect()
            self.NoclipConnection = nil
        end
        
        -- Restore collision
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        self:ShowNotification("Noclip Disabled", "Collision restored", 3)
    end
end

-- Invisibility function
function ESP:ToggleInvisibility()
    self.Invisible = not self.Invisible
    
    local character = LocalPlayer.Character
    if not character then return end
    
    if self.Invisible then
        -- Make invisible
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            elseif part:IsA("Decal") then
                part.Transparency = 1
            end
        end
        self:ShowNotification("Invisible", "You are now invisible", 3)
    else
        -- Make visible
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            elseif part:IsA("Decal") then
                part.Transparency = 0
            end
        end
        self:ShowNotification("Visible", "You are now visible", 3)
    end
end

-- Draggable buttons system
function ESP:ToggleButtons()
    if self.ButtonsVisible then
        self:HideButtons()
    else
        self:ShowButtons()
    end
end

function ESP:ShowButtons()
    if self.ButtonFrame then
        self.ButtonFrame:Destroy()
    end
    
    -- Create button GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ButtonGUI"
    screenGui.Parent = game.CoreGui
    
    -- Main frame (draggable)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "ButtonFrame"
    mainFrame.Size = UDim2.new(0, 150, 0, 230) -- Increased height for new button
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 25)
    title.BackgroundTransparency = 1
    title.Text = "Quick Actions"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Set Position Button
    local setPosBtn = Instance.new("TextButton")
    setPosBtn.Size = UDim2.new(0.8, 0, 0, 25)
    setPosBtn.Position = UDim2.new(0.1, 0, 0.12, 0)
    setPosBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    setPosBtn.Text = "Set Position"
    setPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    setPosBtn.TextSize = 12
    setPosBtn.Font = Enum.Font.GothamBold
    setPosBtn.Parent = mainFrame
    
    local btnCorner1 = Instance.new("UICorner")
    btnCorner1.CornerRadius = UDim.new(0, 6)
    btnCorner1.Parent = setPosBtn
    
    -- Go to Position Button
    local goPosBtn = Instance.new("TextButton")
    goPosBtn.Size = UDim2.new(0.8, 0, 0, 25)
    goPosBtn.Position = UDim2.new(0.1, 0, 0.24, 0)
    goPosBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    goPosBtn.Text = "Go to Position"
    goPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    goPosBtn.TextSize = 12
    goPosBtn.Font = Enum.Font.GothamBold
    goPosBtn.Parent = mainFrame
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = goPosBtn
    
    -- TP to Player Button
    local tpPlayerBtn = Instance.new("TextButton")
    tpPlayerBtn.Size = UDim2.new(0.8, 0, 0, 25)
    tpPlayerBtn.Position = UDim2.new(0.1, 0, 0.36, 0)
    tpPlayerBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    tpPlayerBtn.Text = "TP to Player"
    tpPlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpPlayerBtn.TextSize = 12
    tpPlayerBtn.Font = Enum.Font.GothamBold
    tpPlayerBtn.Parent = mainFrame
    
    local btnCorner6 = Instance.new("UICorner")
    btnCorner6.CornerRadius = UDim.new(0, 6)
    btnCorner6.Parent = tpPlayerBtn
    
    -- Speed Button
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(0.8, 0, 0, 25)
    speedBtn.Position = UDim2.new(0.1, 0, 0.48, 0)
    speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    speedBtn.Text = "Speed: " .. self.WalkSpeed
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 12
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.Parent = mainFrame
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 6)
    btnCorner3.Parent = speedBtn
    
    -- Noclip Button
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0.8, 0, 0, 25)
    noclipBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    noclipBtn.Text = "Noclip: OFF"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.TextSize = 12
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.Parent = mainFrame
    
    local btnCorner4 = Instance.new("UICorner")
    btnCorner4.CornerRadius = UDim.new(0, 6)
    btnCorner4.Parent = noclipBtn
    
    -- Invisibility Button
    local invisBtn = Instance.new("TextButton")
    invisBtn.Size = UDim2.new(0.8, 0, 0, 25)
    invisBtn.Position = UDim2.new(0.1, 0, 0.72, 0)
    invisBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    invisBtn.Text = "Invisible: OFF"
    invisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    invisBtn.TextSize = 12
    invisBtn.Font = Enum.Font.GothamBold
    invisBtn.Parent = mainFrame
    
    local btnCorner5 = Instance.new("UICorner")
    btnCorner5.CornerRadius = UDim.new(0, 6)
    btnCorner5.Parent = invisBtn
    
    -- Button functions
    setPosBtn.MouseButton1Click:Connect(function()
        self:SetPosition()
    end)
    
    goPosBtn.MouseButton1Click:Connect(function()
        self:GoToPosition()
    end)
    
    tpPlayerBtn.MouseButton1Click:Connect(function()
        self:TeleportToNearestPlayer()
    end)
    
    speedBtn.MouseButton1Click:Connect(function()
        self:ShowNotification("Set Speed", "Use ;speed [number]\nExample: ;speed 100", 4)
    end)
    
    noclipBtn.MouseButton1Click:Connect(function()
        self:ToggleNoclip()
        noclipBtn.Text = "Noclip: " .. (self.Noclip and "ON" or "OFF")
    end)
    
    invisBtn.MouseButton1Click:Connect(function()
        self:ToggleInvisibility()
        invisBtn.Text = "Invisible: " .. (self.Invisible and "ON" or "OFF")
    end)
    
    -- Make draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    self.ButtonFrame = screenGui
    self.ButtonsVisible = true
    self:ShowNotification("Buttons Shown", "Drag to move buttons", 3)
end

function ESP:HideButtons()
    if self.ButtonFrame then
        self.ButtonFrame:Destroy()
        self.ButtonFrame = nil
    end
    self.ButtonsVisible = false
    self:ShowNotification("Buttons Hidden", "Buttons removed", 3)
end

-- Function to create ESP for a player (with thicker lines and distance tracking)
function ESP:Create(player)
    if player == LocalPlayer then return end
    if ESP.Objects[player] then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    if not character then return end
    
    -- Random color for lines
    local randomColor = Color3.new(math.random(), math.random(), math.random())
    
    -- Create highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name .. "_ESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    -- Create name tag (NO MAX DISTANCE - always visible)
    local head = character:WaitForChild("Head", 5)
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = player.Name .. "_NameTag"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 60) -- Increased height for distance
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.Adornee = head
        billboard.MaxDistance = 0 -- 0 means infinite distance (always visible)
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Parent = billboard
        
        -- Distance label
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "0m"
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.TextSize = 12
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.Parent = billboard
        
        -- Create line to player (THICKER lines)
        local line = Instance.new("Beam")
        line.Name = player.Name .. "_Line"
        line.Color = ColorSequence.new(randomColor)
        line.Width0 = 0.3 -- Thicker lines
        line.Width1 = 0.3 -- Thicker lines
        line.FaceCamera = true
        line.Parent = character
        
        -- Set line attachments
        local attachment0 = Instance.new("Attachment")
        attachment0.Name = "LineAttachment0"
        attachment0.Parent = head
        
        local myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
        local attachment1 = Instance.new("Attachment")
        attachment1.Name = "LineAttachment1"
        
        if myHead then
            attachment1.Parent = myHead
        else
            attachment1.Parent = head -- Fallback
        end
        
        line.Attachment0 = attachment0
        line.Attachment1 = attachment1
        
        ESP.Objects[player] = {
            Highlight = highlight,
            Billboard = billboard,
            DistanceLabel = distanceLabel,
            Line = line,
            Attachment0 = attachment0,
            Attachment1 = attachment1
        }
    end
    
    -- Handle character respawns
    player.CharacterAdded:Connect(function(newCharacter)
        wait(1)
        ESP:Remove(player)
        if ESP.Enabled then
            ESP:Create(player)
        end
    end)
end

-- Update distance labels
function ESP:UpdateDistances()
    if not self.Enabled then return end
    
    local myCharacter = LocalPlayer.Character
    if not myCharacter then return end
    
    local myHead = myCharacter:FindFirstChild("Head")
    if not myHead then return end
    
    for player, espData in pairs(self.Objects) do
        if player and player.Character and espData.DistanceLabel then
            local theirHead = player.Character:FindFirstChild("Head")
            if theirHead then
                local distance = (myHead.Position - theirHead.Position).Magnitude
                espData.DistanceLabel.Text = string.format("%.1fm", distance)
            end
        end
    end
end

-- Function to remove ESP for a player
function ESP:Remove(player)
    if ESP.Objects[player] then
        if ESP.Objects[player].Highlight then
            ESP.Objects[player].Highlight:Destroy()
        end
        if ESP.Objects[player].Billboard then
            ESP.Objects[player].Billboard:Destroy()
        end
        if ESP.Objects[player].Line then
            ESP.Objects[player].Line:Destroy()
        end
        if ESP.Objects[player].Attachment0 then
            ESP.Objects[player].Attachment0:Destroy()
        end
        if ESP.Objects[player].Attachment1 then
            ESP.Objects[player].Attachment1:Destroy()
        end
        ESP.Objects[player] = nil
    end
end

-- Function to toggle ESP
function ESP:Toggle(state)
    if state == nil then
        state = not ESP.Enabled
    end
    
    ESP.Enabled = state
    
    if state then
        for _, player in ipairs(Players:GetPlayers()) do
            ESP:Create(player)
        end
        
        Players.PlayerAdded:Connect(function(player)
            if ESP.Enabled then
                ESP:Create(player)
            end
        end)
        
        -- Start distance update loop
        self.DistanceUpdate = RunService.Heartbeat:Connect(function()
            ESP:UpdateDistances()
        end)
        
        self:ShowNotification("ESP Enabled", "Players highlighted + lines + distance", 3)
    else
        for player, _ in pairs(ESP.Objects) do
            ESP:Remove(player)
        end
        
        -- Stop distance update loop
        if self.DistanceUpdate then
            self.DistanceUpdate:Disconnect()
            self.DistanceUpdate = nil
        end
        
        self:ShowNotification("ESP Disabled", "ESP turned off", 3)
    end
end

-- Function to save current position
function ESP:SetPosition()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        ESP.SavedPosition = character.HumanoidRootPart.Position
        self:ShowNotification("Position Saved", string.format("X: %.1f, Y: %.1f, Z: %.1f", 
            ESP.SavedPosition.X, ESP.SavedPosition.Y, ESP.SavedPosition.Z), 5)
    else
        self:ShowNotification("Error", "Cannot save position", 3)
    end
end

-- Function to teleport to saved position
function ESP:GoToPosition()
    if not ESP.SavedPosition then
        self:ShowNotification("Error", "No position saved! Use ;setpos first", 3)
        return
    end
    
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(ESP.SavedPosition)
        self:ShowNotification("Teleported", "Warped to saved position!", 3)
    else
        self:ShowNotification("Error", "Cannot teleport", 3)
    end
end

-- Chat command handler
local function handleChat(message)
    local msg = string.lower(message)
    
    if msg == ";enable esp" then
        ESP:Toggle(true)
    elseif msg == ";disable esp" then
        ESP:Toggle(false)
    elseif msg == ";esp" then
        ESP:Toggle()
    elseif msg == ";setpos" then
        ESP:SetPosition()
    elseif msg == ";gopos" then
        ESP:GoToPosition()
    elseif msg == ";tpplayer" then
        ESP:TeleportToNearestPlayer()
    elseif msg == ";noclip" then
        ESP:ToggleNoclip()
    elseif msg == ";invisible" then
        ESP:ToggleInvisibility()
    elseif msg == ";showbtns" then
        ESP:ToggleButtons()
    elseif string.sub(msg, 1, 7) == ";speed " then
        local speed = string.sub(msg, 8)
        ESP:SetSpeed(speed)
    end
end

-- Initialize the system
local function init()
    LocalPlayer.Chatted:Connect(handleChat)
    
    -- Apply walkspeed when character loads
    LocalPlayer.CharacterAdded:Connect(applyWalkSpeed)
    if LocalPlayer.Character then
        applyWalkSpeed(LocalPlayer.Character)
    end
    
    Players.PlayerRemoving:Connect(function(player)
        ESP:Remove(player)
    end)
    
    print("ESP System Loaded Successfully!")
    print("Made by stupidmf_ez 1x")
    print("Chat Commands:")
    print(";enable esp - Enable ESP")
    print(";disable esp - Disable ESP") 
    print(";esp - Toggle ESP")
    print(";setpos - Save current position")
    print(";gopos - Teleport to saved position")
    print(";tpplayer - Teleport to nearest player")
    print(";noclip - Toggle noclip (walk through walls)")
    print(";invisible - Toggle invisibility")
    print(";speed [number] - Set walk speed (1-200)")
    print(";showbtns - Toggle draggable buttons")
end

-- Auto-initialize
if LocalPlayer then
    init()
end

return ESP

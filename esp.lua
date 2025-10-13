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
    Flying = false,
    BodyVelocity = nil,
    ButtonsVisible = false,
    ButtonFrame = nil,
    WalkSpeed = 16
}

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

-- Mobile fly system (magic carpet style)
function ESP:Fly()
    if self.Flying then
        self:Unfly()
        return
    end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    self.Flying = true
    
    -- Save original gravity
    self.OriginalGravity = workspace.Gravity
    
    -- Set gravity to 0 for smooth flight
    workspace.Gravity = 0
    
    -- Create BodyVelocity for flight
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    self.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    self.BodyVelocity.Parent = rootPart
    
    -- Enable platform stand
    humanoid.PlatformStand = true
    
    -- Thumbstick for mobile movement
    local thumbstickFrame = Instance.new("Frame")
    local thumbstickBackground = Instance.new("Frame")
    local thumbstickHandle = Instance.new("Frame")
    
    if UserInputService.TouchEnabled then
        -- Create mobile thumbstick
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FlyStickGUI"
        screenGui.Parent = game.CoreGui
        
        thumbstickFrame = Instance.new("Frame")
        thumbstickFrame.Size = UDim2.new(0, 150, 0, 150)
        thumbstickFrame.Position = UDim2.new(0, 50, 1, -200)
        thumbstickFrame.BackgroundTransparency = 0.7
        thumbstickFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        thumbstickFrame.BorderSizePixel = 0
        thumbstickFrame.Parent = screenGui
        
        local thumbstickCorner = Instance.new("UICorner")
        thumbstickCorner.CornerRadius = UDim.new(1, 0)
        thumbstickCorner.Parent = thumbstickFrame
        
        thumbstickBackground = Instance.new("Frame")
        thumbstickBackground.Size = UDim2.new(0, 80, 0, 80)
        thumbstickBackground.Position = UDim2.new(0.5, -40, 0.5, -40)
        thumbstickBackground.BackgroundTransparency = 0.5
        thumbstickBackground.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        thumbstickBackground.BorderSizePixel = 0
        thumbstickBackground.Parent = thumbstickFrame
        
        local backgroundCorner = Instance.new("UICorner")
        backgroundCorner.CornerRadius = UDim.new(1, 0)
        backgroundCorner.Parent = thumbstickBackground
        
        thumbstickHandle = Instance.new("Frame")
        thumbstickHandle.Size = UDim2.new(0, 40, 0, 40)
        thumbstickHandle.Position = UDim2.new(0.5, -20, 0.5, -20)
        thumbstickHandle.BackgroundTransparency = 0.3
        thumbstickHandle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        thumbstickHandle.BorderSizePixel = 0
        thumbstickHandle.Parent = thumbstickFrame
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(1, 0)
        handleCorner.Parent = thumbstickHandle
        
        self.ThumbstickGUI = screenGui
    end
    
    -- Flight control connection
    self.FlightConnection = RunService.Heartbeat:Connect(function()
        if not self.Flying or not character or not rootPart then return end
        
        local direction = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        if UserInputService.TouchEnabled and thumbstickHandle then
            -- Mobile thumbstick movement
            local thumbstickPos = thumbstickHandle.Position
            local center = UDim2.new(0.5, -20, 0.5, -20)
            local offsetX = (thumbstickPos.X.Offset - center.X.Offset) / 40
            local offsetY = (thumbstickPos.Y.Offset - center.Y.Offset) / 40
            
            if math.abs(offsetX) > 0.1 or math.abs(offsetY) > 0.1 then
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                
                direction = direction + (rightVector * offsetX)
                direction = direction + (lookVector * offsetY)
            end
        else
            -- Keyboard fallback
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + lookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - lookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - rightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + rightVector
            end
        end
        
        -- Up/down controls
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        -- Apply velocity
        if direction.Magnitude > 0 then
            self.BodyVelocity.Velocity = direction.Unit * 50
        else
            self.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Mobile thumbstick touch events
    if UserInputService.TouchEnabled then
        local function onTouch(input, processed)
            if processed then return end
            if not self.Flying then return end
            
            local touchPos = input.Position
            local framePos = thumbstickFrame.AbsolutePosition
            local frameSize = thumbstickFrame.AbsoluteSize
            
            if touchPos.X >= framePos.X and touchPos.X <= framePos.X + frameSize.X and
               touchPos.Y >= framePos.Y and touchPos.Y <= framePos.Y + frameSize.Y then
               
                local center = Vector2.new(framePos.X + frameSize.X/2, framePos.Y + frameSize.Y/2)
                local maxDistance = frameSize.X/2 - 20
                local distance = (touchPos - center).Magnitude
                
                if distance > maxDistance then
                    touchPos = center + (touchPos - center).Unit * maxDistance
                end
                
                thumbstickHandle.Position = UDim2.new(0, touchPos.X - framePos.X - 20, 0, touchPos.Y - framePos.Y - 20)
            end
        end
        
        local function onTouchEnd()
            if not self.Flying then return end
            thumbstickHandle.Position = UDim2.new(0.5, -20, 0.5, -20)
        end
        
        UserInputService.TouchStarted:Connect(onTouch)
        UserInputService.TouchMoved:Connect(onTouch)
        UserInputService.TouchEnded:Connect(onTouchEnd)
    end
    
    self:ShowNotification("Flight Enabled", string.format("Speed: %d\nUse thumbstick to move", self.WalkSpeed), 4)
end

function ESP:Unfly()
    if not self.Flying then return end
    
    self.Flying = false
    
    -- Restore gravity
    if self.OriginalGravity then
        workspace.Gravity = self.OriginalGravity
    end
    
    -- Disconnect flight control
    if self.FlightConnection then
        self.FlightConnection:Disconnect()
        self.FlightConnection = nil
    end
    
    -- Remove BodyVelocity
    if self.BodyVelocity then
        self.BodyVelocity:Destroy()
        self.BodyVelocity = nil
    end
    
    -- Remove thumbstick
    if self.ThumbstickGUI then
        self.ThumbstickGUI:Destroy()
        self.ThumbstickGUI = nil
    end
    
    -- Reset character
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    self:ShowNotification("Flight Disabled", "Flight turned off", 3)
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
    mainFrame.Size = UDim2.new(0, 150, 0, 160) -- Increased height for new button
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
    setPosBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
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
    goPosBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
    goPosBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    goPosBtn.Text = "Go to Position"
    goPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    goPosBtn.TextSize = 12
    goPosBtn.Font = Enum.Font.GothamBold
    goPosBtn.Parent = mainFrame
    
    local btnCorner2 = Instance.new("UICorner")
    btnCorner2.CornerRadius = UDim.new(0, 6)
    btnCorner2.Parent = goPosBtn
    
    -- Speed Button
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(0.8, 0, 0, 25)
    speedBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
    speedBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    speedBtn.Text = "Speed: " .. self.WalkSpeed
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 12
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.Parent = mainFrame
    
    local btnCorner3 = Instance.new("UICorner")
    btnCorner3.CornerRadius = UDim.new(0, 6)
    btnCorner3.Parent = speedBtn
    
    -- Fly Button
    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0.8, 0, 0, 25)
    flyBtn.Position = UDim2.new(0.1, 0, 0.8, 0)
    flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flyBtn.Text = "Toggle Fly"
    flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyBtn.TextSize = 12
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.Parent = mainFrame
    
    local btnCorner4 = Instance.new("UICorner")
    btnCorner4.CornerRadius = UDim.new(0, 6)
    btnCorner4.Parent = flyBtn
    
    -- Button functions
    setPosBtn.MouseButton1Click:Connect(function()
        self:SetPosition()
    end)
    
    goPosBtn.MouseButton1Click:Connect(function()
        self:GoToPosition()
    end)
    
    speedBtn.MouseButton1Click:Connect(function()
        self:ShowNotification("Set Speed", "Use ;speed [number]\nExample: ;speed 100", 4)
    end)
    
    flyBtn.MouseButton1Click:Connect(function()
        self:Fly()
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
    elseif msg == ";fly" then
        ESP:Fly()
    elseif msg == ";unfly" then
        ESP:Unfly()
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
    print("Chat Commands:")
    print(";enable esp - Enable ESP")
    print(";disable esp - Disable ESP") 
    print(";esp - Toggle ESP")
    print(";setpos - Save current position")
    print(";gopos - Teleport to saved position")
    print(";fly - Toggle flight")
    print(";unfly - Disable flight")
    print(";speed [number] - Set walk speed (1-200)")
    print(";showbtns - Toggle draggable buttons")
end

-- Auto-initialize
if LocalPlayer then
    init()
end

return ESP

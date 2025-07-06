-- BrainCore UI for Steal a Brainrot - Full Mobile Friendly Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BrainCoreUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- Tombol Toggle GUI untuk HP & PC
local toggleButton = Instance.new("TextButton", ScreenGui)
toggleButton.Name = "ToggleGUI"
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(1, -110, 1, -40)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Toggle UI"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 6)
toggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Buat tombol fitur
local yOffset = 10
local function makeButton(name, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Text = name
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    yOffset += 40
end

-- 1. Anti Ragdoll
makeButton("Anti Ragdoll", function()
    local char = LocalPlayer.Character
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BallSocketConstraint") then
            v:Destroy()
        end
    end
end)

-- 2. ESP Player
makeButton("ESP Player", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            if not plr.Character.Head:FindFirstChild("BrainCoreESP") then
                local esp = Instance.new("BillboardGui", plr.Character.Head)
                esp.Name = "BrainCoreESP"
                esp.Size = UDim2.new(0, 100, 0, 40)
                esp.AlwaysOnTop = true
                local text = Instance.new("TextLabel", esp)
                text.Text = plr.Name
                text.Size = UDim2.new(1, 0, 1, 0)
                text.TextColor3 = Color3.new(1, 0, 0)
                text.BackgroundTransparency = 1
                text.Font = Enum.Font.SourceSansBold
                text.TextScaled = true
            end
        end
    end
end)

-- 3. ESP OP Brainrot
makeButton("ESP OP Brainrot", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            if not root:FindFirstChild("DeepESP") then
                local bg = Instance.new("BillboardGui", root)
                bg.Name = "DeepESP"
                bg.Size = UDim2.new(0,120,0,50)
                bg.AlwaysOnTop = true
                local name = Instance.new("TextLabel", bg)
                name.Text = plr.Name
                name.Size = UDim2.new(1,0,0.5,0)
                name.BackgroundTransparency = 1
                name.TextColor3 = Color3.fromRGB(0,255,0)
                name.Font = Enum.Font.SourceSansBold
                name.TextScaled = true
                local info = Instance.new("TextLabel", bg)
                info.Position = UDim2.new(0,0,0.5,0)
                info.Size = UDim2.new(1,0,0.5,0)
                info.BackgroundTransparency = 1
                info.TextColor3 = Color3.fromRGB(255,255,255)
                info.Font = Enum.Font.SourceSans
                info.TextScaled = true
                RunService.Heartbeat:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                        local hp = math.floor(plr.Character.Humanoid.Health)
                        local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                        info.Text = "HP: "..hp.."  D: "..dist
                    end
                end)
            end
        end
    end
end)

-- 4. Anti Steal
makeButton("Anti Steal", function()
    LocalPlayer.Backpack.ChildRemoved:Connect(function(child)
        wait(0.1)
        if not LocalPlayer.Backpack:FindFirstChild(child.Name) then
            local tool = Instance.new("Tool")
            tool.Name = child.Name
            tool.Parent = LocalPlayer.Backpack
        end
    end)
end)

-- 5. Lock Base
makeButton("Lock Base", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Position - root.Position).Magnitude < 15 then
            part.Anchored = true
        end
    end
end)

-- 6. Toggle NoClip
local noclipActive = false
makeButton("Toggle NoClip", function()
    noclipActive = not noclipActive
end)

RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 7. TP ke Base
makeButton("TP ke Base", function()
    local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("MainBase")
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if base and root then
        root.CFrame = base:GetModelCFrame and base:GetModelCFrame() or base.CFrame + Vector3.new(0,5,0)
    else
        warn("Base tidak ditemukan.")
    end
end)

-- 8. Speed Boost
makeButton("Speed Boost", function()
    Humanoid.WalkSpeed = 100
end)

-- 9. High Jump
makeButton("High Jump", function()
    Humanoid.JumpPower = 150
end)

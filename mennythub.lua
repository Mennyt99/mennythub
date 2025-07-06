-- MENNYt Exploit GUI (No Key)
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "MENNYtHub"
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 260)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", Frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Text = "MENNYt"

-- Tabs
local tabs = {"Main", "Visual", "Misc"}
local tabFrames = {}
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1/3, 0, 0, 24)
    btn.Position = UDim2.new((i-1)/3, 0, 0, 30)
    btn.Text = tab
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    tabFrames[tab] = Instance.new("Frame", Frame)
    tabFrames[tab].Size = UDim2.new(1, -10, 1, -60)
    tabFrames[tab].Position = UDim2.new(0, 5, 0, 60)
    tabFrames[tab].Visible = (i == 1)
    btn.MouseButton1Click:Connect(function()
        for tName, tf in pairs(tabFrames) do
            tf.Visible = (tName == tab)
        end
    end)
end

-- Settings
local SETTINGS = {AntiRagdoll=false, LockBase=false, NoClip=false, ESP=false, ESPBrainrot=false, AntiSteal=false}

-- Helper
local function createToggle(parent, text, key)
    local y = #parent:GetChildren()*30
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 26)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text.." : OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        SETTINGS[key] = not SETTINGS[key]
        btn.Text = text.." : "..(SETTINGS[key] and "ON" or "OFF")
    end)
end

-- Create toggles
createToggle(tabFrames["Main"], "Anti Ragdoll", "AntiRagdoll")
createToggle(tabFrames["Main"], "Lock Base", "LockBase")
createToggle(tabFrames["Main"], "NoClip", "NoClip")

createToggle(tabFrames["Visual"], "ESP Player", "ESP")
createToggle(tabFrames["Visual"], "ESP OP Brainrot", "ESPBrainrot")

createToggle(tabFrames["Misc"], "Anti Steal", "AntiSteal")

-- Feature Logic

-- Anti Ragdoll
Run.RenderStepped:Connect(function()
    if SETTINGS.AntiRagdoll and plr.Character then
        local c = plr.Character
        if c:FindFirstChild("Ragdoll") then c.Ragdoll:Destroy() end
        if c:FindFirstChild("Stunned") then c.Stunned:Destroy() end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)

-- Lock Base
Run.RenderStepped:Connect(function()
    if SETTINGS.LockBase then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("base") then
                obj.Anchored = true
                obj.Locked = true
            end
        end
    end
end)

-- NoClip
Run.Stepped:Connect(function()
    if SETTINGS.NoClip and plr.Character then
        for _, part in ipairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP Player
Run.RenderStepped:Connect(function()
    if SETTINGS.ESP then
        for _, p in ipairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character then
                if not p.Character:FindFirstChild("ESPBox") then
                    local h = Instance.new("Highlight", p.Character)
                    h.Name = "ESPBox"
                    h.FillColor = Color3.fromRGB(255,0,0)
                    h.OutlineColor = Color3.fromRGB(255,255,255)
                end
            else
                local esp = p.Character:FindFirstChild("ESPBox")
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- ESP OP Brainrot (highlight NPC bernama "Brainrot")
Run.RenderStepped:Connect(function()
    if SETTINGS.ESPBrainrot then
        local npc = workspace:FindFirstChild("Brainrot")
        if npc and npc:IsA("Model") and not npc:FindFirstChild("OPBox") then
            local h = Instance.new("Highlight", npc)
            h.Name = "OPBox"
            h.FillColor = Color3.fromRGB(0,255,0)
            h.OutlineColor = Color3.fromRGB(255,255,255)
        elseif npc and npc:FindFirstChild("OPBox") and not SETTINGS.ESPBrainrot then
            npc:FindFirstChild("OPBox"):Destroy()
        end
    else
        local npc = workspace:FindFirstChild("Brainrot")
        if npc and npc:FindFirstChild("OPBox") then npc:FindFirstChild("OPBox"):Destroy() end
    end
end)

-- Anti Steal (contoh: tag "Stealable" di part)
Run.RenderStepped:Connect(function()
    if SETTINGS.AntiSteal then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("Stealable") then
                obj.Parent = plr.Character
            end
        end
    end
end)

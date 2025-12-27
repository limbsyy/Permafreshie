local Players = game:GetService("Players")
local TeleportQueued = false

local queue =
    queue_on_teleport
    or queueonteleport
    or queueteleport
    or (syn and syn.queue_on_teleport)

if queue then
    Players.LocalPlayer.OnTeleport:Connect(function()
        if TeleportQueued then return end
        TeleportQueued = true

        queue([[
            loadstring(game:HttpGet("https://raw.githubusercontent.com/limbsyy/Permafreshie/refs/heads/main/script.lua"))()
        ]])
    end)
end




if game.PlaceId == 126222071643660 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Permafreshie",
        Text = "Cannot run in lobby.",
        Duration = 5
    })
    return
end

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles


local Window = Library:CreateWindow({
    Title = "Permafreshie",
    Footer = "version: 1.0",
    Icon = 12985862028,
    NotifySide = "Right",
    ShowCustomCursor = false,
})


local ESPTab = Window:AddTab("ESP")
local MiscTab = Window:AddTab("Misc")
local SettingsTab = Window:AddTab("Settings")


local esp, esp_renderstep, framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/ESP-Library/refs/heads/main/nomercy.rip/source.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")


local function notify(title, text)
    Library:Notify({
        Title = title,
        Description = text,
        Time = 4
    })
end

local function playSound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 1
    s.Parent = SoundService
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
end

local HighlightColor = Color3.fromRGB(255,255,0)
local function highlightModel(model)
    if not model then return end
    for _,part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstChild("ESP_Highlight") then
            local hl=Instance.new("Highlight")
            hl.Name="ESP_Highlight"
            hl.FillColor=HighlightColor
            hl.OutlineColor=HighlightColor
            hl.FillTransparency=0.6
            hl.OutlineTransparency=0.6
            hl.Adornee=part
            hl.Parent=part
        end
    end
end

local function clearHighlights(model)
    if not model then return end
    for _,part in ipairs(model:GetDescendants()) do
        local hl=part:FindFirstChild("ESP_Highlight")
        if hl then hl:Destroy() end
    end
end


local alerts = {
    ["???"] = {Folder=Workspace:WaitForChild("Live"), ModelName="???", AlertEnabled=false, HighlightEnabled=false, SoundId="rbxassetid://5621616510"},
    Divinos = {Folder=Workspace:WaitForChild("NPCs"), ModelName="Divinos", AlertEnabled=false, HighlightEnabled=false, SoundId="rbxassetid://87681552750899"},
    Chest1 = {Folder=Workspace:WaitForChild("Thrown"), ModelName="Chest1", AlertEnabled=false, HighlightEnabled=false, SoundId="rbxassetid://998971542"},
    Chest2 = {Folder=Workspace:WaitForChild("Thrown"), ModelName="Chest2", AlertEnabled=false, HighlightEnabled=false, SoundId="rbxassetid://998971542"},
    ChestRR = {Folder=Workspace:WaitForChild("Thrown"), ModelName="ChestRR", AlertEnabled=false, HighlightEnabled=false, SoundId="rbxassetid://998971542"},
}


local MiscAlertsBox = MiscTab:AddLeftGroupbox("Alerts")
local MiscHighlightBox = MiscTab:AddLeftGroupbox("Highlights")
local MiscSoundsBox = MiscTab:AddLeftGroupbox("Alert Sounds")

for name,data in pairs(alerts) do

    MiscAlertsBox:AddToggle("Alert_"..name,{
        Text = "Alert "..name,
        Default = false,
    }):OnChanged(function(v) data.AlertEnabled=v end)


    MiscHighlightBox:AddToggle("Highlight_"..name,{
        Text = "Highlight "..name,
        Default = false,
    }):OnChanged(function(v)
        data.HighlightEnabled=v
        local model = data.Folder:FindFirstChild(data.ModelName)
        if model then
            if v then highlightModel(model) else clearHighlights(model) end
        end
    end)


    MiscSoundsBox:AddButton({
        Text = "Test Sound "..name,
        Func = function() playSound(data.SoundId) end,
    })
end


local PlayerESPBox = ESPTab:AddLeftGroupbox("Player ESP")


local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local obj = esp:GetObject(player)
        if obj then
            if typeof(obj.UpdateSettings) == "function" then
                obj:UpdateSettings(esp.Settings)
            else
                if obj.Box then obj.Box.Visible = esp.Settings.Box.Enabled end
                if obj.BoxOutline then obj.BoxOutline.Visible = esp.Settings.Box_Outline.Enabled end
                if obj.NameTag then obj.NameTag.Visible = esp.Settings.Name.Enabled end
                if obj.HealthBar then obj.HealthBar.Visible = esp.Settings.Health.Enabled end
                if obj.HealthText then obj.HealthText.Visible = esp.Settings.Health.Enabled end
                if obj.DistanceText then obj.DistanceText.Visible = esp.Settings.Distance.Enabled end
            end
        end
    end
end


PlayerESPBox:AddToggle("ESP_Enabled", {
    Text = "Enable Player ESP",
    Default = false,
}):OnChanged(function(v)
    esp.Settings.Enabled = v
    updateESP()
end)


PlayerESPBox:AddToggle("ESP_Names", {
    Text = "Show Names",
    Default = false,
}):OnChanged(function(v)
    esp.Settings.Name.Enabled = v
    updateESP()
end)


PlayerESPBox:AddToggle("ESP_Boxes", {
    Text = "Show Boxes",
    Default = false,
}):OnChanged(function(v)
    esp.Settings.Box.Enabled = v
    esp.Settings.Box_Outline.Enabled = v
    updateESP()
end)


PlayerESPBox:AddToggle("ESP_Health", {
    Text = "Show Health",
    Default = false,
}):OnChanged(function(v)
    esp.Settings.Health.Enabled = v
    esp.Settings.Healthbar.Enabled = v
    updateESP()
end)


PlayerESPBox:AddToggle("ESP_Distance", {
    Text = "Show Distance",
    Default = false,
}):OnChanged(function(v)
    esp.Settings.Distance.Enabled = v
    updateESP()
end)


PlayerESPBox:AddSlider("ESP_MaxDistance", {
    Text = "Player Max Distance",
    Default = 500,
    Min = 0,
    Max = 2000,
    Rounding = 0,
}):OnChanged(function(v)
    esp.Settings.Maximal_Distance = v
    updateESP()
end)


for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        esp:Player(player)
    end
end
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        esp:Player(player)
        updateESP()
    end
end)
Players.PlayerRemoving:Connect(function(player)
    local obj = esp:GetObject(player)
    if obj then obj:Destroy() end
end)


task.spawn(function()
    while true do
        task.wait(2)
        for name, data in pairs(alerts) do
            data.DetectedInstances = data.DetectedInstances or {}

            local folder = data.Folder
            if folder then
                for _, inst in ipairs(folder:GetChildren()) do
                    if inst.Name == data.ModelName then
                        if data.AlertEnabled and not data.DetectedInstances[inst] then
                            data.DetectedInstances[inst] = true
                            notify("Alert", name .. " spawned!")
                            playSound(data.SoundId)
                        end

                        if data.HighlightEnabled then
                            highlightModel(inst)
                        else
                            clearHighlights(inst)
                        end
                    end
                end

                for inst in pairs(data.DetectedInstances) do
                    if not inst.Parent then
                        data.DetectedInstances[inst] = nil
                    end
                end
            end
        end
    end
end)

-- ===== FULLBRIGHT =====
local Lighting = game:GetService("Lighting")
local initialAmbient = Lighting.Ambient
local initialBrightness = Lighting.Brightness

local MiscFullbrightBox = MiscTab:AddRightGroupbox("Visuals")

MiscFullbrightBox:AddToggle("Fullbright", {
    Text = "Fullbright",
    Default = false,
}):OnChanged(function(v)
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 1
    else
        Lighting.Ambient = initialAmbient
        Lighting.Brightness = initialBrightness
    end
end)


-- ===== THEME & SAVE MANAGER =====
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("Permafreshie")
SaveManager:SetFolder("Permafreshie/specific-game")
SaveManager:SetSubFolder("specific-place")
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()

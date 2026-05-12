local VALID_KEY = "SMART123"

local player = game.Players.LocalPlayer

local keyGui = Instance.new("ScreenGui")
keyGui.Name = "SmartKillKeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = player.PlayerGui

local keyFrame = Instance.new("Frame")
keyFrame.Parent = keyGui
keyFrame.Size = UDim2.new(0,300,0,180)
keyFrame.Position = UDim2.new(0.5,-150,0.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(20,20,30)

local title = Instance.new("TextLabel")
title.Parent = keyFrame
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "ENTER KEY"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold

local box = Instance.new("TextBox")
box.Parent = keyFrame
box.Size = UDim2.new(0,240,0,40)
box.Position = UDim2.new(0.5,-120,0,60)
box.PlaceholderText = "Input Key"
box.Text = ""
box.TextColor3 = Color3.fromRGB(255,255,255)
box.BackgroundColor3 = Color3.fromRGB(35,35,50)

local login = Instance.new("TextButton")
login.Parent = keyFrame
login.Size = UDim2.new(0,240,0,40)
login.Position = UDim2.new(0.5,-120,0,115)
login.Text = "LOGIN"
login.TextColor3 = Color3.fromRGB(255,255,255)
login.BackgroundColor3 = Color3.fromRGB(120,80,255)
login.Font = Enum.Font.GothamBold

login.MouseButton1Click:Connect(function()
    if box.Text ~= VALID_KEY then
        login.Text = "KEY SALAH"
        login.BackgroundColor3 = Color3.fromRGB(180,50,50)
        wait(1)
        login.Text = "LOGIN"
        login.BackgroundColor3 = Color3.fromRGB(120,80,255)
        return
    end

    keyGui:Destroy()

    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

    local Remote = game:GetService("ReplicatedStorage")
        :WaitForChild("RS")
        :WaitForChild("RGX")
        :WaitForChild("RIO")

    local colors = {
        SchemeColor = Color3.fromRGB(120,80,255),
        Background = Color3.fromRGB(10,10,18),
        Header = Color3.fromRGB(18,18,32),
        TextColor = Color3.fromRGB(180,220,255),
        ElementColor = Color3.fromRGB(25,25,45)
    }

    _G.KillAura = false
    _G.AuraHitCount = 5
    _G.AutoAFK = false

    local MainWin = Library.CreateLib("SMART KILL AURA", colors)

    -- AUTO STATS
    local StatsTab = MainWin:NewTab("Auto Stats")
    local StatsSec = StatsTab:NewSection("Upgrade")

    local function MakeStat(name,arg)
        _G[arg] = false

        StatsSec:NewToggle("Auto "..name, "Upgrade otomatis tiap 10 detik", function(v)
            _G[arg] = v

            if v then
                spawn(function()
                    while _G[arg] do
                        pcall(function()
                            Remote:FireServer("upgrade", arg)
                        end)

                        wait(10)
                    end
                end)
            end
        end)
    end

    MakeStat("DMG","DMG")
    MakeStat("HEAL","HEAL")
    MakeStat("SPEED","SPEED")
    MakeStat("HP","HP")

    -- COMBAT
    local CombatTab = MainWin:NewTab("Combat")
    local CombatSec = CombatTab:NewSection("Aura")

    CombatSec:NewDropdown("Jumlah Hit / Scan", "Pilih jumlah hit", {"1","2","3","4","5"}, function(v)
        _G.AuraHitCount = tonumber(v)
    end)

    CombatSec:NewToggle("Smart Kill Aura", "Auto attack enemy", function(v)
        _G.KillAura = v

        if v then
            spawn(function()
                while _G.KillAura do
                    pcall(function()
                        local mobs = workspace:FindFirstChild("Enemy")
                        local char = player.Character
                        if not mobs or not char then return end

                        local root = char:FindFirstChild("HumanoidRootPart")
                        local weapon = char:FindFirstChild("Weapon")

                        if root and weapon and weapon:FindFirstChild("revent") then
                            for _, mob in pairs(mobs:GetChildren()) do
                                local hum = mob:FindFirstChild("Humanoid")
                                local hrp = mob:FindFirstChild("HumanoidRootPart")

                                if hum and hrp and hum.Health > 0 then
                                    if (hrp.Position - root.Position).Magnitude <= 300 then
                                        for i = 1, _G.AuraHitCount do
                                            weapon.revent:FireServer("fire", mob)
                                        end
                                    end
                                end
                            end
                        end
                    end)

                    wait(0.09)
                end
            end)
        end
    end)

    -- MISC / AUTO AFK
    local MiscTab = MainWin:NewTab("Misc")
    local MiscSec = MiscTab:NewSection("AFK Lock System")

    MiscSec:NewToggle("Auto AFK Lock", "Anti AFK / unlock movement", function(state)
        _G.AutoAFK = state

        if _G.AutoAFK then
            spawn(function()
                while _G.AutoAFK do
                    pcall(function()
                        Remote:FireServer("afk", true)

                        local char = player.Character
                        if char then
                            local root = char:FindFirstChild("HumanoidRootPart")
                            local hum = char:FindFirstChild("Humanoid")

                            if root and root.Anchored then
                                root.Anchored = false
                            end

                            if hum then
                                if hum.WalkSpeed == 0 then hum.WalkSpeed = 16 end
                                if hum.JumpPower == 0 then hum.JumpPower = 50 end
                            end
                        end
                    end)

                    wait(0.5)
                end
            end)

            spawn(function()
                while _G.AutoAFK do
                    pcall(function()
                        local gameGui = player.PlayerGui:FindFirstChild("GameGui")

                        if gameGui then
                            local target = gameGui:FindFirstChild("XAFKUI")
                            if target then
                                target:Destroy()
                            end
                        end

                        for _, v in pairs(player.PlayerGui:GetChildren()) do
                            local name = string.lower(v.Name)

                            if v:IsA("ScreenGui") and (string.find(name, "afk") or string.find(name, "reward")) then
                                v:Destroy()
                            end
                        end
                    end)

                    wait(1)
                end
            end)
        else
            pcall(function()
                Remote:FireServer("afk", false)
            end)
        end
    end)

    local function findKavoMain()
        for _, place in pairs({game.CoreGui, player.PlayerGui}) do
            for _, g in pairs(place:GetChildren()) do
                if g:IsA("ScreenGui") and g:FindFirstChild("Main") then
                    return g, g.Main
                end
            end
        end
        return nil, nil
    end

    wait(0.5)

    local gui = Instance.new("ScreenGui")
    gui.Name = "SmartKillAuraMiniIcon"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local icon = Instance.new("TextButton")
    icon.Parent = gui
    icon.Size = UDim2.new(0,50,0,50)
    icon.Position = UDim2.new(0.5,-25,0,20)
    icon.Text = "⚔"
    icon.TextColor3 = Color3.fromRGB(255,255,255)
    icon.TextSize = 24
    icon.Font = Enum.Font.GothamBold
    icon.BackgroundColor3 = Color3.fromRGB(120,80,255)
    icon.BorderSizePixel = 0
    icon.Active = true
    icon.Draggable = true

    pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1,0)
        corner.Parent = icon
    end)

    icon.MouseButton1Click:Connect(function()
        local kavoGui, main = findKavoMain()

        if main then
            local opened = not main.Visible
            main.Visible = opened

            if opened then
                icon.Text = "⚔"
                icon.BackgroundColor3 = Color3.fromRGB(120,80,255)
            else
                icon.Text = "◉"
                icon.BackgroundColor3 = Color3.fromRGB(170,70,255)
            end
        else
            icon.Text = "!"
            icon.BackgroundColor3 = Color3.fromRGB(255,80,80)
        end
    end)
end)

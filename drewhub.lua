-- Drew Hub v2.5 | Script Premium para Blox Fruits (SEM KEY)
-- Desenvolvido para uso pessoal e educacional

-- 🧱 Carregar Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Drew Hub | Blox Fruits",
    LoadingTitle = "Iniciando Drew Hub...",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- 🌾 Variáveis de controle
global = {
    Autofarm = false,
    SelectedMob = nil,
    AutoCollectChests = false,
    AutoCollectFruits = false,
    AutoFarmBoss = false,
    AutoHaki = true,
    AntiAFK = true
}

-- 🚀 Funções auxiliares
local function teleportTo(cf)
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = cf
end

local function attackTarget(mob)
    local char = game.Players.LocalPlayer.Character
    if char and mob and mob:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        char:FindFirstChildOfClass("Humanoid"):ChangeState(3)
        mouse1click()
    end
end

-- 🧾 Aba: Auto Farm
local TabFarm = Window:CreateTab("🌾 Auto Farm", 4483362458)

TabFarm:CreateToggle({
    Name = "Ativar Auto Farm",
    CurrentValue = false,
    Callback = function(v) global.Autofarm = v end
})

TabFarm:CreateToggle({
    Name = "Auto Farm Bosses",
    CurrentValue = false,
    Callback = function(v) global.AutoFarmBoss = v end
})

TabFarm:CreateToggle({
    Name = "Ativar Haki automático",
    CurrentValue = true,
    Callback = function(v) global.AutoHaki = v end
})

TabFarm:CreateDropdown({
    Name = "Selecionar Inimigo",
    Options = {},
    CurrentOption = "",
    Callback = function(value) global.SelectedMob = value end
})

-- Atualização dinâmica da lista de inimigos
spawn(function()
    while wait(5) do
        local list = {}
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and not table.find(list, mob.Name) then
                table.insert(list, mob.Name)
            end
        end
        TabFarm:CreateDropdown({
            Name = "Atualizar Inimigos",
            Options = list,
            CurrentOption = global.SelectedMob or "",
            Callback = function(val) global.SelectedMob = val end
        })
    end
end)

-- Loop de Auto Farm
spawn(function()
    while wait(0.2) do
        if global.Autofarm and global.SelectedMob then
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob.Name == global.SelectedMob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    if global.AutoHaki then pcall(function() game:GetService("ReplicatedStorage").Remotes.CommE:InvokeServer("Buso") end) end
                    repeat wait()
                        attackTarget(mob)
                    until mob.Humanoid.Health <= 0 or not global.Autofarm
                end
            end
        end
    end
end)

-- Loop de Auto Farm Boss
spawn(function()
    while wait(1) do
        if global.AutoFarmBoss then
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.MaxHealth > 50000 then
                    if global.AutoHaki then pcall(function() game:GetService("ReplicatedStorage").Remotes.CommE:InvokeServer("Buso") end) end
                    repeat wait()
                        attackTarget(mob)
                    until mob.Humanoid.Health <= 0 or not global.AutoFarmBoss
                end
            end
        end
    end
end)

-- ⚙️ Aba: Extras
local TabExtras = Window:CreateTab("⚙️ Extras", 4483362458)

TabExtras:CreateToggle({
    Name = "Coletar Baús Automaticamente",
    CurrentValue = false,
    Callback = function(v) global.AutoCollectChests = v end
})

spawn(function()
    while wait(2) do
        if global.AutoCollectChests then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name:lower():match("chest") then
                    teleportTo(part.CFrame)
                    wait(0.3)
                end
            end
        end
    end
end)

TabExtras:CreateToggle({
    Name = "Coletar Frutas automaticamente",
    CurrentValue = false,
    Callback = function(v) global.AutoCollectFruits = v end
})

spawn(function()
    while wait(2) do
        if global.AutoCollectFruits then
            for _, f in pairs(workspace:GetChildren()) do
                if f:IsA("Tool") and f:FindFirstChild("Handle") then
                    teleportTo(f.Handle.CFrame)
                end
            end
        end
    end
end)

-- 💤 Anti-AFK
if global.AntiAFK then
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end
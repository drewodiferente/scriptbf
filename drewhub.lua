-- Drew Hub v2.5 | Script Premium para Blox Fruits (SEM KEY)
-- Desenvolvido para uso pessoal e educacional

-- 🧱 Carregar Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Drew Hub | Blox Fruits",
    LoadingTitle = "Iniciando Drew Hub...",
    ConfigurationSaving = {
        Enabled = true, -- ativar salvar config
        FolderName = nil, -- padrão (pasta do jogo)
        FileName = "DrewHubConfig"
    }
})

-- 🌾 Variáveis de controle
local global = {
    Autofarm = false,
    AutoFarmBoss = false,
    AutoHaki = true,
    AntiAFK = true,
    AutoCollectChests = false,
    AutoCollectFruits = false,
    SelectedMob = nil,
    TeleportToMob = true, -- nova opção: teleportar até inimigo no auto farm
}

-- Função para teleportar
local function teleportTo(cf)
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = cf
    end
end

-- Função para atacar alvo
local function attackTarget(mob)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not (char and mob and mob:FindFirstChild("HumanoidRootPart")) then return end

    -- Teleporta próximo do mob (se habilitado)
    if global.TeleportToMob then
        char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
    end

    -- Forçar o Humanoid atacar (usar estado 3 = atacando)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end

    -- Invocar ataque (usar o remote correto do jogo)
    -- Exemplo genérico:
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("MeleeAttack") -- pode variar, teste o remote correto
    end)
end

-- Atualizar dropdown de inimigos
local function getEnemyList()
    local list = {}
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and not table.find(list, mob.Name) then
            table.insert(list, mob.Name)
        end
    end
    return list
end

-- Criar abas e controles UI
local TabFarm = Window:CreateTab("🌾 Auto Farm", 4483362458)
local TabExtras = Window:CreateTab("⚙️ Extras", 4483362458)

-- Auto Farm toggle
TabFarm:CreateToggle({
    Name = "Ativar Auto Farm",
    CurrentValue = global.Autofarm,
    Flag = "AutoFarmToggle",
    Callback = function(v)
        global.Autofarm = v
    end
})

-- Auto Farm Bosses toggle
TabFarm:CreateToggle({
    Name = "Auto Farm Bosses",
    CurrentValue = global.AutoFarmBoss,
    Flag = "AutoFarmBossToggle",
    Callback = function(v)
        global.AutoFarmBoss = v
    end
})

-- Auto Haki toggle
TabFarm:CreateToggle({
    Name = "Ativar Haki Automático",
    CurrentValue = global.AutoHaki,
    Flag = "AutoHakiToggle",
    Callback = function(v)
        global.AutoHaki = v
    end
})

-- Teleport to mob toggle (novo)
TabFarm:CreateToggle({
    Name = "Teleportar para Inimigo",
    CurrentValue = global.TeleportToMob,
    Flag = "TeleportToMobToggle",
    Callback = function(v)
        global.TeleportToMob = v
    end
})

-- Dropdown de inimigos (inicial vazio)
local enemyDropdown = TabFarm:CreateDropdown({
    Name = "Selecionar Inimigo",
    Options = getEnemyList(),
    CurrentOption = global.SelectedMob or "",
    Flag = "SelectedMob",
    Callback = function(value)
        global.SelectedMob = value
    end
})

-- Atualizar lista de inimigos a cada 10s
spawn(function()
    while wait(10) do
        local enemies = getEnemyList()
        if #enemies > 0 then
            enemyDropdown:Refresh(enemies, global.SelectedMob)
        end
    end
end)

-- Loop Auto Farm comum
spawn(function()
    while wait(0.3) do
        if global.Autofarm and global.SelectedMob then
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob.Name == global.SelectedMob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    if global.AutoHaki then
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.CommE:InvokeServer("Buso")
                        end)
                    end
                    repeat
                        attackTarget(mob)
                        wait(0.2)
                        if not (global.Autofarm and mob.Humanoid and mob.Humanoid.Health > 0) then break end
                    until mob.Humanoid.Health <= 0 or not global.Autofarm
                end
            end
        else
            wait(1)
        end
    end
end)

-- Loop Auto Farm Boss
spawn(function()
    while wait(1) do
        if global.AutoFarmBoss then
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob:FindFirstChild("Humanoid") and mob.Humanoid.MaxHealth > 50000 and mob.Humanoid.Health > 0 then
                    if global.AutoHaki then
                        pcall(function()
                            game:GetService("ReplicatedStorage").Remotes.CommE:InvokeServer("Buso")
                        end)
                    end
                    repeat
                        attackTarget(mob)
                        wait(0.2)
                        if not (global.AutoFarmBoss and mob.Humanoid and mob.Humanoid.Health > 0) then break end
                    until mob.Humanoid.Health <= 0 or not global.AutoFarmBoss
                end
            end
        else
            wait(1)
        end
    end
end)

-- Aba Extras: Coletar baús automático
TabExtras:CreateToggle({
    Name = "Coletar Baús Automaticamente",
    CurrentValue = global.AutoCollectChests,
    Flag = "AutoCollectChests",
    Callback = function(v)
        global.AutoCollectChests = v
    end
})

spawn(function()
    while wait(2) do
        if global.AutoCollectChests then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") and part.Name:lower():find("chest") then
                    teleportTo(part.CFrame)
                    wait(0.5)
                end
            end
        end
    end
end)

-- Aba Extras: Coletar frutas automaticamente
TabExtras:CreateToggle({
    Name = "Coletar Frutas Automaticamente",
    CurrentValue = global.AutoCollectFruits,
    Flag = "AutoCollectFruits",
    Callback = function(v)
        global.AutoCollectFruits = v
    end
})

spawn(function()
    while wait(2) do
        if global.AutoCollectFruits then
            for _, item in pairs(workspace:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    teleportTo(item.Handle.CFrame)
                    wait(0.5)
                end
            end
        end
    end
end)

-- Anti AFK
local function setupAntiAfk()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if global.AntiAFK then
            vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end
    end)
end

-- Criar toggle Anti AFK
TabExtras:CreateToggle({
    Name = "Ativar Anti AFK",
    CurrentValue = global.AntiAFK,
    Flag = "AntiAFKToggle",
    Callback = function(v)
        global.AntiAFK = v
    end
})

setupAntiAfk()

-- Auto Equipar arma/fruta (funcionalidade extra)
local function autoEquip()
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()

    -- Equipar fruta, se tiver
    local backpack = player.Backpack
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            -- Priorizar fruta? Aqui só equipar o primeiro item
            player.Character.Humanoid:EquipTool(item)
            break
        end
    end
end

-- Rodar auto equip a cada 10s
spawn(function()
    while wait(10) do
        autoEquip()
    end
end)

print("Drew Hub carregado com sucesso!")
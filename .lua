-- Увеличиваем хитбоксы в 100 раз (на 10000%)
local HITBOX_INCREASE_FACTOR = 100.0

-- Функция для создания увеличенных хитбоксов
local function createHitbox(part)
    -- Создаём невидимую часть для хитбокса
    local hitbox = Instance.new("Part")
    hitbox.Size = part.Size * HITBOX_INCREASE_FACTOR
    hitbox.Transparency = 1 -- Полностью невидимый
    hitbox.Anchored = false
    hitbox.CanCollide = true -- Включаем коллизии
    hitbox.Name = "Hitbox"
    hitbox.Massless = true -- Убираем влияние на физику
    hitbox.CollisionGroup = "Hitboxes" -- Группа коллизий для управления взаимодействиями

    -- Привязываем хитбокс к оригинальной части
    local weld = Instance.new("Weld")
    weld.Part0 = part
    weld.Part1 = hitbox
    weld.C0 = CFrame.new() -- Позиция и ориентация хитбокса
    weld.Parent = hitbox

    -- Создаём BoxHandleAdornment для визуализации хитбокса
    local adornment = Instance.new("BoxHandleAdornment")
    adornment.Size = hitbox.Size
    adornment.Adornee = hitbox
    adornment.AlwaysOnTop = true
    adornment.ZIndex = 10
    adornment.Transparency = 0.97 -- Прозрачность 97%
    adornment.Color3 = Color3.new(1, 0, 0) -- Красный цвет
    adornment.Parent = hitbox

    -- Добавляем хитбокс в игру
    hitbox.Parent = part
end

-- Функция для обработки персонажей игроков
local function handlePlayer(player)
    if player ~= game.Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            -- Ждём, пока персонаж полностью загрузится
            character:WaitForChild("HumanoidRootPart")
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Hitbox" then
                    createHitbox(part)
                end
            end
        end)

        -- Обрабатываем существующего персонажа
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "Hitbox" then
                    createHitbox(part)
                end
            end
        end
    end
end

-- Настройка групп коллизий
local physicsService = game:GetService("PhysicsService")
physicsService:CreateCollisionGroup("Hitboxes")
physicsService:CollisionGroupSetCollidable("Hitboxes", "Hitboxes", false) -- Хитбоксы не сталкиваются друг с другом
physicsService:CollisionGroupSetCollidable("Hitboxes", "Default", true) -- Хитбоксы сталкиваются с другими объектами

-- Обрабатываем всех игроков на сервере
for _, player in pairs(game.Players:GetPlayers()) do
    handlePlayer(player)
end

-- Обрабатываем новых игроков, которые присоединяются к игре
game.Players.PlayerAdded:Connect(handlePlayer)

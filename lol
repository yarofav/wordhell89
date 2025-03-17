-- Ссылка на сырой файл скрипта на GitHub
local githubUrl = "https://github.com/yarofav/wordhell89/blob/main/.gitignore"

-- Функция для загрузки и выполнения скрипта
local function loadScriptFromGitHub(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local loadedFunction, errorMessage = loadstring(response)
        if loadedFunction then
            loadedFunction()
        else
            warn("Ошибка при загрузке скрипта: " .. errorMessage)
        end
    else
        warn("Не удалось загрузить скрипт: " .. response)
    end
end

-- Загружаем и выполняем скрипт
loadScriptFromGitHub(githubUrl)

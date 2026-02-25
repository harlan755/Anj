--// ==============================
--// CONFIG
--// ==============================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

--// ==============================
--// SERVICES
--// ==============================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

--// ==============================
--// FUNCTION SEND WEBHOOK
--// ==============================
local function sendStatus(status, color)
    local gameName
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)
    gameName = gameName or "Unknown Game"

    local data = {
        username = "Delta Executor Logger",
        embeds = {{
            title = "Player Status Update",
            description = "**Player:** "..(LocalPlayer and LocalPlayer.Name or "Unknown")..
                          "\n**UserId:** "..(LocalPlayer and LocalPlayer.UserId or "Unknown")..
                          "\n**Status:** "..status..
                          "\n**Game:** "..gameName..
                          "\n**Time:** "..os.date("%Y-%m-%d %H:%M:%S"),
            color = color
        }}
    }

    local jsonData = HttpService:JSONEncode(data)

    pcall(function()
        if request then
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        else
            HttpService:PostAsync(WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
        end
    end)
end

--// ==============================
--// INITIAL ONLINE STATUS
--// ==============================
sendStatus("🟢 ONLINE", 65280)

--// ==============================
--// SEDANG BERMAIN GAME
--// ==============================
-- Kirim status PLAYING setelah 5 detik agar pemain benar-benar berada di game
task.spawn(function()
    task.wait(5)
    sendStatus("🎮 PLAYING", 2551650) -- warna biru-ish
end)

--// ==============================
--// DISCONNECT DETECTION
--// ==============================
local success, coreGui = pcall(function()
    return game:GetService("CoreGui").RobloxPromptGui
end)

if success and coreGui then
    coreGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" then
            task.spawn(function()
                sendStatus("🟡 DISCONNECTED", 16776960)
            end)
        end
    end)
end

--// ==============================
--// OFFLINE (LEAVE GAME)
--// ==============================
game:BindToClose(function()
    task.spawn(function()
        sendStatus("🔴 OFFLINE", 16711680)
        task.wait(1) -- buffer agar request sempat dikirim
    end)
end)

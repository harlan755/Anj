--// ==============================
--// CONFIG
--// ==============================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

--// ==============================
--// SERVICES
--// ==============================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

--// ==============================
--// FUNCTION SEND WEBHOOK
--// ==============================
local function sendStatus(status, color)
    local data = {
        ["username"] = "Delta Executor Logger",
        ["embeds"] = {{
            ["title"] = "Player Status Update",
            ["description"] = "**Player:** "..LocalPlayer.Name..
                            "\n**UserId:** "..LocalPlayer.UserId..
                            "\n**Status:** "..status..
                            "\n**Game:** "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name..
                            "\n**Time:** "..os.date("%Y-%m-%d %H:%M:%S"),
            ["color"] = color
        }}
    }

    local jsonData = HttpService:JSONEncode(data)

    if request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end
end

--// ==============================
--// ONLINE STATUS
--// ==============================
sendStatus("🟢 ONLINE", 65280)

--// ==============================
--// DISCONNECT DETECTION
--// ==============================
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        sendStatus("🟡 DISCONNECTED", 16776960)
    end
end)

--// ==============================
--// OFFLINE (LEAVE GAME)
--// ==============================
game:BindToClose(function()
    sendStatus("🔴 OFFLINE", 16711680)
end)

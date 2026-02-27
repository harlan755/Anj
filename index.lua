local HttpService = game:GetService("HttpService")
-- Ganti dengan URL webhook Discord Anda
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

-- Fungsi untuk mendapatkan data player yang berperan sebagai bot
local function getBotPlayerData(botPlayer)
    -- Nama player/bot tidak perlu dimasker jika sudah merupakan nama bot resmi
    local botName = botPlayer.Name .. " (Bot)"

    return {
        status = "Farming Blocks", -- Aktivitas aktual bot saat ini
        botName = botName,
        botStatus = botPlayer:IsDescendantOf(game.Players) and "Online" or "Offline",
        botPing = tostring(math.floor(botPlayer:GetNetworkPing() * 1000)) .. "ms",
        botGems = tostring(botPlayer.leaderstats and botPlayer.leaderstats.Gems.Value or 0):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", ""),
        treesReady = botPlayer.leaderstats and botPlayer.leaderstats.TreesReady.Value or 0,
        treesUnReady = botPlayer.leaderstats and botPlayer.leaderstats.TreesUnReady.Value or 0
    }
end

-- Fungsi untuk mengirim webhook data bot (player)
local function sendBotPlayerWebhook(botPlayer)
    local botData = getBotPlayerData(botPlayer)

    local message = table.concat({
        "- <a:stat:1449444004801286268> `Status : " .. botData.status .. "`",
        "- <:Bot:1283696244165836812> `Bot Name : " .. botData.botName .. "`",
        "- <a:checkm:1181101683082797076> `Bot Status : " .. botData.status .. "`",
        "- <:stable_ping:1408556059496546384> `Bot Ping : " .. botData.botPing .. "`",
        "- <:gems:1465657925770154086> `Bot Gems : " .. botData.botGems .. "`",
        "- <:treegt:1174568853091659827> `Trees : " .. botData.treesReady .. " Ready | " .. botData.treesUnReady .. " UnReady`"
    }, "\n")

    local requestBody = HttpService:JSONEncode({
        content = message
    })

    local success, err = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, requestBody)
    end)

    if success then
        print("Webhook berhasil dikirim untuk bot (player): " .. botPlayer.Name)
    else
        warn("Gagal mengirim webhook untuk bot (player) " .. botPlayer.Name .. ": " .. err)
    end
end

-- Contoh: Jalankan saat bot player bergabung ke game
game.Players.PlayerAdded:Connect(function(player)
    -- Cek apakah player adalah bot (misalnya berdasarkan nama atau tag khusus)
    if string.find(player.Name, "Bot") or player:GetAttribute("IsBot") then
        player.CharacterAdded:Wait()
        sendBotPlayerWebhook(player)
        
        -- Opsional: Kirim update berkala setiap beberapa detik
        while player:IsDescendantOf(game.Players) do
            wait(30) -- Update setiap 30 detik
            sendBotPlayerWebhook(player)
        end
    end
end)

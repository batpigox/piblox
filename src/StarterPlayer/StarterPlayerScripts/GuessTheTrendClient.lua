local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local RemotesFolder = ReplicatedStorage:WaitForChild("GuessTheTrendRemotes")
local QuestionEvent = RemotesFolder:WaitForChild("Question")
local TimerEvent = RemotesFolder:WaitForChild("Timer")
local SubmitAnswer = RemotesFolder:WaitForChild("SubmitAnswer")
local ScoreUpdate = RemotesFolder:WaitForChild("ScoreUpdate")
local AnswerFeedback = RemotesFolder:WaitForChild("AnswerFeedback")
local QuestionSummary = RemotesFolder:WaitForChild("QuestionSummary")
local RoundResults = RemotesFolder:WaitForChild("RoundResults")
local IntermissionEvent = RemotesFolder:WaitForChild("Intermission")

local screenGui = playerGui:FindFirstChild("GuessTheTrendGui")
if screenGui then
    screenGui:Destroy()
end

screenGui = Instance.new("ScreenGui")
screenGui.Name = "GuessTheTrendGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 12)
uiPadding.PaddingBottom = UDim.new(0, 12)
uiPadding.PaddingLeft = UDim.new(0, 12)
uiPadding.PaddingRight = UDim.new(0, 12)
uiPadding.Parent = screenGui

local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 180, 0, 60)
logoFrame.Position = UDim2.new(0, 0, 0, 0)
logoFrame.BackgroundTransparency = 0.35
logoFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
logoFrame.Parent = screenGui

local logoUICorner = Instance.new("UICorner")
logoUICorner.CornerRadius = UDim.new(0, 12)
logoUICorner.Parent = logoFrame

local logoImage = Instance.new("ImageLabel")
logoImage.Size = UDim2.new(0, 42, 0, 42)
logoImage.Position = UDim2.new(0, 12, 0.5, -21)
logoImage.BackgroundTransparency = 1
logoImage.Image = "rbxassetid://6026663697"
logoImage.Parent = logoFrame

local logoText = Instance.new("TextLabel")
logoText.BackgroundTransparency = 1
logoText.Position = UDim2.new(0, 64, 0, 0)
logoText.Size = UDim2.new(1, -76, 1, 0)
logoText.Font = Enum.Font.GothamBold
logoText.Text = "Guess The Trend"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 20
logoText.TextXAlignment = Enum.TextXAlignment.Left
logoText.Parent = logoFrame

local promptLabel = Instance.new("TextLabel")
promptLabel.Name = "PromptLabel"
promptLabel.Size = UDim2.new(1, -24, 0, 60)
promptLabel.Position = UDim2.new(0, 12, 0, 70)
promptLabel.BackgroundTransparency = 0.25
promptLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
promptLabel.Font = Enum.Font.GothamBold
promptLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
promptLabel.TextSize = 24
promptLabel.TextWrapped = true
promptLabel.Text = "En attente de la prochaine manche..."
promptLabel.Parent = screenGui

local promptCorner = Instance.new("UICorner")
promptCorner.CornerRadius = UDim.new(0, 12)
promptCorner.Parent = promptLabel

local timerFrame = Instance.new("Frame")
timerFrame.Name = "TimerFrame"
timerFrame.Size = UDim2.new(0.3, 0, 0, 24)
timerFrame.Position = UDim2.new(0.35, 0, 0, 140)
timerFrame.BackgroundTransparency = 0.4
timerFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
timerFrame.Parent = screenGui

local timerCorner = Instance.new("UICorner")
timerCorner.CornerRadius = UDim.new(0, 12)
timerCorner.Parent = timerFrame

local timerBar = Instance.new("Frame")
timerBar.Name = "TimerBar"
timerBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
timerBar.Size = UDim2.new(1, 0, 1, 0)
timerBar.Parent = timerFrame

local timerBarCorner = Instance.new("UICorner")
timerBarCorner.CornerRadius = UDim.new(0, 12)
timerBarCorner.Parent = timerBar

local timerText = Instance.new("TextLabel")
timerText.BackgroundTransparency = 1
timerText.Size = UDim2.new(1, 0, 1, 0)
timerText.Font = Enum.Font.GothamSemibold
timerText.TextColor3 = Color3.fromRGB(255, 255, 255)
timerText.TextSize = 18
timerText.Text = "10"
timerText.Parent = timerFrame

local intermissionLabel = Instance.new("TextLabel")
intermissionLabel.Size = UDim2.new(1, -24, 0, 40)
intermissionLabel.Position = UDim2.new(0, 12, 0, 180)
intermissionLabel.BackgroundTransparency = 1
intermissionLabel.Font = Enum.Font.GothamSemibold
intermissionLabel.TextSize = 22
intermissionLabel.TextColor3 = Color3.fromRGB(255, 240, 180)
intermissionLabel.Text = ""
intermissionLabel.Parent = screenGui

local hintFrame = Instance.new("Frame")
hintFrame.Name = "HintFrame"
hintFrame.Size = UDim2.new(0.4, 0, 0.4, 0)
hintFrame.Position = UDim2.new(0.5, -200, 0, 240)
hintFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
hintFrame.BackgroundTransparency = 0.15
hintFrame.Parent = screenGui

local hintCorner = Instance.new("UICorner")
hintCorner.CornerRadius = UDim.new(0, 16)
hintCorner.Parent = hintFrame

local hintImage = Instance.new("ImageLabel")
hintImage.Name = "HintImage"
hintImage.Size = UDim2.new(1, -20, 1, -20)
hintImage.Position = UDim2.new(0, 10, 0, 10)
hintImage.BackgroundTransparency = 1
hintImage.Image = "rbxassetid://0"
hintImage.ScaleType = Enum.ScaleType.Fit
hintImage.Parent = hintFrame

local soundIcon = Instance.new("ImageLabel")
soundIcon.Name = "SoundIcon"
soundIcon.Visible = false
soundIcon.BackgroundTransparency = 1
soundIcon.Image = "rbxassetid://6031265975"
soundIcon.Size = UDim2.new(0, 120, 0, 120)
soundIcon.Position = UDim2.new(0.5, -60, 0.5, -60)
soundIcon.Parent = hintFrame

local hintSound = Instance.new("Sound")
hintSound.Name = "HintSound"
hintSound.Looped = false
hintSound.Parent = hintFrame

local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(0.6, 0, 0, 260)
buttonsFrame.Position = UDim2.new(0.5, -300, 1, -280)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = screenGui

local buttonsLayout = Instance.new("UIGridLayout")
buttonsLayout.CellSize = UDim2.new(0.5, -12, 0.5, -12)
buttonsLayout.CellPadding = UDim2.new(0, 12, 0, 12)
buttonsLayout.FillDirectionMaxCells = 2
buttonsLayout.Parent = buttonsFrame

local buttons = {}
local selectedOption

local function styleButton(button)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.5
    stroke.Parent = button
end

for i = 1, 4 do
    local button = Instance.new("TextButton")
    button.Name = "Option" .. i
    button.Size = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 22
    button.Font = Enum.Font.GothamSemibold
    button.TextWrapped = true
    button.AutoButtonColor = false
    button.Parent = buttonsFrame
    styleButton(button)
    buttons[i] = button
end

local scoreFrame = Instance.new("Frame")
scoreFrame.Name = "ScoreFrame"
scoreFrame.Size = UDim2.new(0, 220, 0, 140)
scoreFrame.Position = UDim2.new(1, -240, 0, 12)
scoreFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scoreFrame.BackgroundTransparency = 0.2
scoreFrame.Parent = screenGui

local scoreCorner = Instance.new("UICorner")
scoreCorner.CornerRadius = UDim.new(0, 14)
scoreCorner.Parent = scoreFrame

local scoreTitle = Instance.new("TextLabel")
scoreTitle.Size = UDim2.new(1, 0, 0, 36)
scoreTitle.BackgroundTransparency = 1
scoreTitle.Font = Enum.Font.GothamBold
scoreTitle.Text = "Classement"
scoreTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
scoreTitle.TextSize = 20
scoreTitle.Parent = scoreFrame

local scoreContent = Instance.new("TextLabel")
scoreContent.Name = "ScoreContent"
scoreContent.Size = UDim2.new(1, -20, 1, -40)
scoreContent.Position = UDim2.new(0, 10, 0, 38)
scoreContent.BackgroundTransparency = 1
scoreContent.Font = Enum.Font.Gotham
scoreContent.TextWrapped = true
scoreContent.TextXAlignment = Enum.TextXAlignment.Left
scoreContent.TextYAlignment = Enum.TextYAlignment.Top
scoreContent.TextColor3 = Color3.fromRGB(200, 200, 220)
scoreContent.TextSize = 18
scoreContent.Text = "En attente de joueurs..."
scoreContent.Parent = scoreFrame

local podiumFrame = Instance.new("Frame")
podiumFrame.Name = "PodiumFrame"
podiumFrame.Size = UDim2.new(0, 360, 0, 240)
podiumFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
podiumFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
podiumFrame.BackgroundTransparency = 0.15
podiumFrame.Visible = false
podiumFrame.Parent = screenGui

local podiumCorner = Instance.new("UICorner")
podiumCorner.CornerRadius = UDim.new(0, 18)
podiumCorner.Parent = podiumFrame

local podiumTitle = Instance.new("TextLabel")
podiumTitle.Size = UDim2.new(1, 0, 0, 48)
podiumTitle.BackgroundTransparency = 1
podiumTitle.Font = Enum.Font.GothamBold
podiumTitle.Text = "Podium"
podiumTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
podiumTitle.TextSize = 26
podiumTitle.Parent = podiumFrame

local podiumList = Instance.new("Frame")
podiumList.Name = "List"
podiumList.BackgroundTransparency = 1
podiumList.Position = UDim2.new(0, 20, 0, 56)
podiumList.Size = UDim2.new(1, -40, 1, -70)
podiumList.Parent = podiumFrame

local podiumLayout = Instance.new("UIListLayout")
podiumLayout.Padding = UDim.new(0, 12)
podiumLayout.FillDirection = Enum.FillDirection.Vertical
podiumLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
podiumLayout.SortOrder = Enum.SortOrder.LayoutOrder
podiumLayout.Parent = podiumList

local successSound = Instance.new("Sound")
successSound.SoundId = "rbxassetid://1843521225"
successSound.Volume = 1
successSound.Parent = screenGui

local failSound = Instance.new("Sound")
failSound.SoundId = "rbxassetid://138211516"
failSound.Volume = 1
failSound.Parent = screenGui

local function setButtonsEnabled(enabled)
    for _, button in ipairs(buttons) do
        button.AutoButtonColor = enabled
        button.Active = enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(40, 40, 65) or Color3.fromRGB(25, 25, 35)
    end
end

local function updateScoreboard(board)
    if #board == 0 then
        scoreContent.Text = "En attente de joueurs..."
        return
    end

    local lines = {}
    for index, entry in ipairs(board) do
        table.insert(lines, string.format("%d. %s - %d", index, entry.name, entry.score))
        if index >= 5 then
            break
        end
    end
    scoreContent.Text = table.concat(lines, "\n")
end

local function flashButton(button, color)
    local tween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundColor3 = color,
    })
    tween:Play()
end

local function vibrate()
    local success, err = pcall(function()
        StarterGui:SetCore("Vibrate", 0.35)
    end)
    if not success then
        -- silently ignore if device does not support vibration
    end
end

local function clearPodium()
    for _, child in ipairs(podiumList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

local function showPodium(entries)
    clearPodium()
    for index, entry in ipairs(entries) do
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 0, 32)
        label.Font = Enum.Font.GothamSemibold
        label.TextColor3 = index == 1 and Color3.fromRGB(255, 230, 120) or Color3.fromRGB(210, 210, 230)
        label.TextSize = 22
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.LayoutOrder = index
        label.Text = string.format("#%d %s - %d pts", index, entry.name, entry.score)
        label.Parent = podiumList
    end
    podiumFrame.Visible = true
end

local currentDuration = 10
local timerTween

local function updateTimer(remaining, duration)
    currentDuration = duration or currentDuration
    remaining = math.max(remaining, 0)
    timerText.Text = tostring(remaining)

    if timerTween then
        timerTween:Cancel()
    end

    local fraction = duration > 0 and (remaining / duration) or 0
    timerTween = TweenService:Create(timerBar, TweenInfo.new(0.2), {Size = UDim2.new(fraction, 0, 1, 0)})
    timerTween:Play()

    if remaining <= 3 and remaining > 0 then
        vibrate()
    end
end

local function prepareForQuestion(data)
    podiumFrame.Visible = false
    intermissionLabel.Text = ""
    setButtonsEnabled(true)
    selectedOption = nil

    promptLabel.Text = string.format("Q%d/%d - %s", data.questionNumber or 1, data.totalQuestions or 1, data.prompt or "")

    hintImage.Visible = data.kind == "Image"
    soundIcon.Visible = data.kind == "Sound"

    if data.kind == "Image" then
        hintImage.Image = data.assetId or "rbxassetid://0"
        if hintSound.IsPlaying then
            hintSound:Stop()
        end
    elseif data.kind == "Sound" then
        hintImage.Image = "rbxassetid://0"
        hintSound.SoundId = data.assetId or "rbxassetid://0"
        hintSound:Play()
    else
        hintImage.Image = "rbxassetid://0"
    end

    for index, option in ipairs(data.options or {}) do
        local button = buttons[index]
        if button then
            button.Text = option
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        end
    end

    updateTimer(currentDuration, currentDuration)
end

local function showAnswerSummary(summary)
    setButtonsEnabled(false)

    local correct = summary.correctOption
    if correct and buttons[correct] then
        flashButton(buttons[correct], Color3.fromRGB(0, 200, 120))
    end

    if summary.winner then
        intermissionLabel.Text = string.format("%s a répondu le plus vite !", summary.winner)
    else
        intermissionLabel.Text = "Personne n'a trouvé la bonne réponse..."
    end
end

for index, button in ipairs(buttons) do
    button.MouseButton1Click:Connect(function()
        if not button.Active then
            return
        end
        selectedOption = index
        setButtonsEnabled(false)
        flashButton(button, Color3.fromRGB(0, 150, 255))
        SubmitAnswer:FireServer(index)
    end)
end

QuestionEvent.OnClientEvent:Connect(function(data)
    currentDuration = data and data.duration or 10
    prepareForQuestion(data)
end)

TimerEvent.OnClientEvent:Connect(function(payload)
    updateTimer(payload.remaining or 0, payload.duration or currentDuration)
    if (payload.remaining or 0) == 0 then
        setButtonsEnabled(false)
    end
end)

ScoreUpdate.OnClientEvent:Connect(function(board)
    updateScoreboard(board or {})
end)

AnswerFeedback.OnClientEvent:Connect(function(correct)
    if correct then
        successSound:Play()
        intermissionLabel.Text = "Bonne réponse !"
    else
        failSound:Play()
        intermissionLabel.Text = "Raté !"
    end
end)

QuestionSummary.OnClientEvent:Connect(function(summary)
    showAnswerSummary(summary or {})
end)

RoundResults.OnClientEvent:Connect(function(payload)
    setButtonsEnabled(false)
    if hintSound.IsPlaying then
        hintSound:Stop()
    end
    if payload and payload.podium then
        showPodium(payload.podium)
    end
end)

IntermissionEvent.OnClientEvent:Connect(function(data)
    if data and data.message then
        intermissionLabel.Text = data.message
    end
    podiumFrame.Visible = false
end)

updateTimer(0, 10)

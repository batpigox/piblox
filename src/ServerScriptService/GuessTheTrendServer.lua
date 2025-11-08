local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

local Shared = require(ReplicatedStorage:WaitForChild("GuessTheTrendShared"))

local Questions = Shared.Questions
local Settings = Shared.Settings

local RemotesFolder = ReplicatedStorage:FindFirstChild("GuessTheTrendRemotes")
if not RemotesFolder then
    RemotesFolder = Instance.new("Folder")
    RemotesFolder.Name = "GuessTheTrendRemotes"
    RemotesFolder.Parent = ReplicatedStorage
end

local function createRemote(name)
    local remote = RemotesFolder:FindFirstChild(name)
    if not remote then
        remote = Instance.new("RemoteEvent")
        remote.Name = name
        remote.Parent = RemotesFolder
    end
    return remote
end

local QuestionEvent = createRemote("Question")
local TimerEvent = createRemote("Timer")
local SubmitAnswer = createRemote("SubmitAnswer")
local ScoreUpdate = createRemote("ScoreUpdate")
local AnswerFeedback = createRemote("AnswerFeedback")
local QuestionSummary = createRemote("QuestionSummary")
local RoundResults = createRemote("RoundResults")
local IntermissionEvent = createRemote("Intermission")

local playerScores = {}
local currentQuestionData
local currentRoundId = 0
local acceptingAnswers = false
local questionResolved = false
local answeredPlayers = {}

local function resetScores()
    for _, player in ipairs(Players:GetPlayers()) do
        playerScores[player.UserId] = 0
    end
    ScoreUpdate:FireAllClients({})
end

local function getSortedLeaderboard()
    local board = {}
    for userId, score in pairs(playerScores) do
        local player = Players:GetPlayerByUserId(userId)
        if player then
            table.insert(board, {name = player.DisplayName, userId = userId, score = score})
        end
    end
    table.sort(board, function(a, b)
        if a.score == b.score then
            return a.name < b.name
        end
        return a.score > b.score
    end)
    return board
end

local function broadcastScores()
    ScoreUpdate:FireAllClients(getSortedLeaderboard())
end

local function emitFireworks(player)
    local character = player.Character
    if not character then
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local attachment = Instance.new("Attachment")
    attachment.Name = "GuessTrendFireworkAttachment"
    attachment.Position = Vector3.new(0, 2, 0)
    attachment.Parent = hrp

    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://2415947841"
    emitter.LightEmission = 0.7
    emitter.Speed = NumberRange.new(8, 12)
    emitter.Lifetime = NumberRange.new(0.8, 1.2)
    emitter.Rate = 0
    emitter.RotSpeed = NumberRange.new(-90, 90)
    emitter.SpreadAngle = Vector2.new(360, 360)
    emitter.VelocitySpread = 360
    emitter.Drag = 2
    emitter.Brightness = 3
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 1.6),
        NumberSequenceKeypoint.new(1, 0.4),
    })
    emitter.Parent = attachment

    emitter:Emit(120)
    Debris:AddItem(attachment, 2)
end

local function glowWinner(player)
    if not player.Character then
        return
    end
    local highlight = player.Character:FindFirstChild("GuessTrendWinnerGlow")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "GuessTrendWinnerGlow"
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255, 170, 0)
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.Parent = player.Character
    end

    highlight.Enabled = true

    task.delay(6, function()
        if highlight then
            local tween = TweenService:Create(highlight, TweenInfo.new(1), {OutlineTransparency = 1})
            tween:Play()
            tween.Completed:Wait()
            highlight.Enabled = false
            highlight.OutlineTransparency = 0
        end
    end)
end

local function chooseQuestions()
    local indices = {}
    for i = 1, #Questions do
        table.insert(indices, i)
    end
    for i = #indices, 2, -1 do
        local j = math.random(i)
        indices[i], indices[j] = indices[j], indices[i]
    end

    local chosen = {}
    local total = math.min(Settings.RoundQuestions, #indices)
    for i = 1, total do
        table.insert(chosen, Questions[indices[i]])
    end
    return chosen
end

local function sendQuestion(questionNumber, totalQuestions, question)
    currentQuestionData = question
    answeredPlayers = {}
    questionResolved = false
    acceptingAnswers = true

    QuestionEvent:FireAllClients({
        questionNumber = questionNumber,
        totalQuestions = totalQuestions,
        prompt = question.prompt,
        kind = question.kind,
        assetId = question.assetId,
        options = question.options,
        duration = Settings.QuestionDuration,
    })
end

local function revealCorrectAnswer(winningPlayer)
    local winnerName = winningPlayer and winningPlayer.DisplayName or nil
    QuestionSummary:FireAllClients({
        correctOption = currentQuestionData and currentQuestionData.correctOption or 0,
        winner = winnerName,
    })
end

SubmitAnswer.OnServerEvent:Connect(function(player, optionIndex)
    if not acceptingAnswers or questionResolved or not currentQuestionData then
        return
    end
    if answeredPlayers[player] then
        return
    end
    answeredPlayers[player] = true

    if optionIndex == currentQuestionData.correctOption then
        questionResolved = true
        acceptingAnswers = false
        playerScores[player.UserId] = (playerScores[player.UserId] or 0) + 1
        broadcastScores()
        AnswerFeedback:FireClient(player, true)
        emitFireworks(player)
        revealCorrectAnswer(player)
    else
        AnswerFeedback:FireClient(player, false)
    end
end)

Players.PlayerAdded:Connect(function(player)
    playerScores[player.UserId] = playerScores[player.UserId] or 0
    broadcastScores()
end)

Players.PlayerRemoving:Connect(function(player)
    playerScores[player.UserId] = nil
    broadcastScores()
end)

local function runQuestion(questionNumber, totalQuestions, question)
    sendQuestion(questionNumber, totalQuestions, question)

    local remaining = Settings.QuestionDuration
    while remaining >= 0 and not questionResolved do
        TimerEvent:FireAllClients({remaining = remaining, duration = Settings.QuestionDuration})
        task.wait(1)
        remaining -= 1
    end

    acceptingAnswers = false
    TimerEvent:FireAllClients({remaining = 0, duration = Settings.QuestionDuration})

    if not questionResolved then
        revealCorrectAnswer(nil)
    end

    task.wait(2)
end

local function runRound()
    currentRoundId += 1
    resetScores()
    broadcastScores()

    local chosenQuestions = chooseQuestions()
    local totalQuestions = #chosenQuestions

    for index, question in ipairs(chosenQuestions) do
        runQuestion(index, totalQuestions, question)
    end

    local leaderboard = getSortedLeaderboard()
    local podium = {}
    for i = 1, math.min(3, #leaderboard) do
        table.insert(podium, leaderboard[i])
    end

    RoundResults:FireAllClients({
        leaderboard = leaderboard,
        podium = podium,
    })

    if podium[1] then
        local winner = Players:GetPlayerByUserId(podium[1].userId)
        if winner then
            glowWinner(winner)
        end
    end
end

local function runGameLoop()
    while true do
        if #Players:GetPlayers() == 0 then
            task.wait(2)
        else
            runRound()
            for remaining = Settings.TimeBetweenRounds, 1, -1 do
                IntermissionEvent:FireAllClients({message = string.format(Settings.IntermissionMessage, remaining)})
                task.wait(1)
            end
        end
    end
end

task.spawn(runGameLoop)

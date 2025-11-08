local Shared = {}

Shared.Settings = {
    RoundQuestions = 5,
    QuestionDuration = 10,
    TimeBetweenRounds = 8,
    IntermissionMessage = "Prochaine manche dans %d secondes...",
}

--[[
    Chaque question suit cette structure :
    {
        kind = "Image" or "Sound",
        assetId = "rbxassetid://<ID de l'image ou du son>",
        prompt = "Texte à afficher au dessus de l'indice",
        options = {"Réponse 1", "Réponse 2", "Réponse 3", "Réponse 4"},
        correctOption = 2 -- index de la bonne réponse (1-4)
    }

    💡 Pour ajouter vos propres questions, copiez l'un des exemples ci-dessous et adaptez
       simplement l'assetId, le prompt, les options et l'index correctOption.
       Gardez au minimum 4 options pour garantir un QCM cohérent.
]]
Shared.Questions = {
    {
        kind = "Image",
        assetId = "rbxassetid://11255109", -- Logo TikTok
        prompt = "Quel logo est présenté ici ?",
        options = {"Snapchat", "TikTok", "Instagram", "Discord"},
        correctOption = 2,
    },
    {
        kind = "Image",
        assetId = "rbxassetid://11818618463", -- Meme Doge
        prompt = "Quel mème internet est-ce ?",
        options = {"Doge", "Cheems", "Gigachad", "Pepe"},
        correctOption = 1,
    },
    {
        kind = "Image",
        assetId = "rbxassetid://5910082792", -- Logo YouTube
        prompt = "À quelle plateforme ce logo appartient-il ?",
        options = {"Twitch", "Netflix", "YouTube", "Vimeo"},
        correctOption = 3,
    },
    {
        kind = "Sound",
        assetId = "rbxassetid://9121159873", -- Son viral
        prompt = "Quel trend TikTok utilise ce son ?",
        options = {"Wednesday Dance", "Griddy", "Renegade", "Wednesday Clap"},
        correctOption = 1,
    },
    {
        kind = "Image",
        assetId = "rbxassetid://4483345878", -- Emoji tears of joy
        prompt = "Quel emoji est représenté ?",
        options = {"😂", "😭", "🤣", "😅"},
        correctOption = 1,
    },
    {
        kind = "Image",
        assetId = "rbxassetid://12136402295", -- Discord logo
        prompt = "Reconnaissez-vous ce logo ?",
        options = {"Slack", "Discord", "Skype", "Teams"},
        correctOption = 2,
    },
    {
        kind = "Sound",
        assetId = "rbxassetid://1846627277", -- OOF meme
        prompt = "Quel son viral venez-vous d'entendre ?",
        options = {"Bruh", "OOF", "Vine Boom", "Airhorn"},
        correctOption = 2,
    },
}

--[[
    ✨ Add your own questions below this line ✨
    Exemple rapide :
    table.insert(Shared.Questions, {
        kind = "Image",
        assetId = "rbxassetid://<votreID>",
        prompt = "Quel objet tendance voyez-vous ?",
        options = {"Option 1", "Option 2", "Option 3", "Option 4"},
        correctOption = 4,
    })
]]

return Shared

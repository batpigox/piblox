# Guess The Trend (Piblox)

Ce dépôt contient l'implémentation complète du mini-jeu Roblox **Guess The Trend**.

## Contenu du projet

- `src/ReplicatedStorage/GuessTheTrendShared.lua` : configuration des manches et banque de questions.
- `src/ServerScriptService/GuessTheTrendServer.lua` : logique serveur (manches, scores, podium, effets).
- `src/StarterPlayer/StarterPlayerScripts/GuessTheTrendClient.lua` : interface automatique, timer, interactions joueurs.

## Ajouter le jeu dans Roblox Studio

1. Importez les fichiers du dossier `src` dans votre place Roblox en respectant la hiérarchie :
   - Placez `GuessTheTrendShared.lua` dans **ReplicatedStorage**.
   - Placez `GuessTheTrendServer.lua` dans **ServerScriptService**.
   - Placez `GuessTheTrendClient.lua` dans **StarterPlayer ➜ StarterPlayerScripts**.
2. Lancez le Playtest : l'interface, les RemoteEvents et les effets sont générés automatiquement.

## Personnaliser les questions

Dans `GuessTheTrendShared.lua`, la table `Shared.Questions` contient les QCM. Chaque entrée utilise la structure :

```lua
{
    kind = "Image", -- ou "Sound"
    assetId = "rbxassetid://<ID>",
    prompt = "Quel élément culturel est représenté ?",
    options = {"Choix A", "Choix B", "Choix C", "Choix D"},
    correctOption = 2,
}
```

Ajoutez simplement une nouvelle table au tableau (ou utilisez la section "Add your own questions") pour enrichir le quiz.

## Fonctionnalités clés

- Interface responsive PC/mobile générée par script.
- Timer visuel + vibration mobile via `StarterGui:SetCore("Vibrate")`.
- Système de points : +1 point pour le joueur le plus rapide à répondre correctement.
- Feu d'artifice sur l'avatar en cas de bonne réponse.
- Son d'échec et résumé de chaque question.
- Podium final (top 3) avec effet glow sur le gagnant.
- Logo "Guess The Trend" affiché en haut à gauche de l'écran.

Amusez-vous bien !

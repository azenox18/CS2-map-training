# CS2 Training Map — Aim, Peek & Tracking

Map d'entraînement **Counter-Strike 2** complète, jouable **seul ou avec des amis** (chaque joueur a sa propre session, en même temps, sur le même serveur).

## Exercices inclus

| Exercice | Commande | Description |
|---|---|---|
| **Précision (Gridshot)** | `!precision` | 3 cibles pop dans un rayon faible devant toi. Dès que tu en tires une, elle repop ailleurs. Score = cibles/s sur 60 s. |
| **Tracking** | `!tracking` | Cibles qui bougent en continu (strafe). Objectif : garder ton crosshair dessus et les toucher. |
| **Peek / Réaction** | `!peek` | Des cibles pop à gauche/droite à des angles aléatoires et disparaissent vite. Entraîne le reflex de peek. |
| **Bots** | `!bots 5` | Ajoute de vrais bots (difficulté max) pour du peek/duel réaliste. `!nobots` pour les enlever. |

## Extras

- **Choix de couteaux** : `!knife karambit`, `!knife butterfly`, `!knife m9`, `!knife talon`, `!knife skeleton`… (liste complète avec `!knife`)
- **Choix d'armes** : `!weapon ak47`, `!weapon awp`, `!weapon deagle`… (liste complète avec `!weapon`)
- **Munitions infinies** : `!ammo`
- **Records personnels** : `!score`
- **Aide** : `!aide`

## Multijoueur

Lance la map en partie privée (Play → Practice / serveur dédié) et invite tes amis. Chaque joueur lance ses propres exercices via le chat (`!precision`, etc.), tout le monde s'entraîne **en même temps** avec ses propres cibles et son propre score.

## Contenu du dépôt

```
addon/game/csgo/addons/cs2_training/scripts/vscripts/
├── training_main.lua        ← point d'entrée : sessions, commandes chat, événements
├── training_precision.lua   ← mode Gridshot (3 cibles, respawn à chaque tir)
├── training_tracking.lua    ← mode Tracking (cibles mouvantes)
├── training_peek.lua        ← mode Peek/Réaction (pop gauche/droite)
├── training_knife.lua      ← menu couteaux + armes
├── training_utils.lua      ← helpers (spawn, vecteurs, give d'items)
└── training_config.lua     ← réglages (durées, distances, vitesses, listes)
docs/
├── INSTALLATION.md          ← comment installer et lancer
├── COMMANDES.md             ← toutes les commandes détaillées
└── CONSTRUCTION_MAP.md      ← guide Hammer (Workshop Tools) pour la géométrie
```

## Documentation

- [Installation & lancement](docs/INSTALLATION.md)
- [Guide Hammer clic par clic (recommandé)](docs/GUIDE_HAMMER_CLIC_PAR_CLIC.md)
- [Toutes les commandes](docs/COMMANDES.md)
- [Construire la map dans Hammer (résumé technique)](docs/CONSTRUCTION_MAP.md)

## Personnalisation rapide

Tout se règle dans `training_config.lua` : durée des sessions, nombre de cibles, rayon de spawn, vitesse des cibles de tracking, angles et durées de vie du mode peek, listes de couteaux/armes.

## Note importante sur VScript

Valve a désactivé le runtime VScript Lua dans le client CS2 de base lors d'une mise à jour récente (voir [CS2 Docs — VScript](https://cs2.poggu.me/dumped-data/vscript-list/)). Le code de ce projet est du VScript Lua standard pour CS2 : il fonctionne avec les **CS2 Workshop Tools** lors de la construction/publication de la map, et sur les environnements où VScript est (ré)activé. Si rien ne se passe en jeu et que la console affiche une erreur liée au scripting, c'est cette limitation — pas ton installation.

## Licence

Fait pour l'entraînement perso et entre amis. Fais-en ce que tu veux.

# Toutes les commandes (chat)

Tape ces commandes dans le **chat** (T ou Y) pendant la partie. Chaque joueur a ses propres sessions et records.

## Exercices

| Commande | Alias | Effet |
|---|---|---|
| `!precision` | `!gridshot`, `!grid` | Démarre le mode précision : **3 cibles** pop dans un petit rayon devant toi. Tire sur une cible → elle **repop ailleurs** immédiatement. Durée 60 s, score en cibles/s. |
| `!tracking` | `!track` | Démarre le mode tracking : cibles qui **bougent en continu** de gauche à droite. Objectif : suivre et toucher. |
| `!peek` | `!reaction` | Démarre le mode peek : une cible **pop à un angle aléatoire** (gauche/droite, 15°–80°) et disparaît après 0,6–1,1 s. Compte touches vs ratés. |
| `!stop` | | Arrête ta session en cours (résumé affiché). |
| `!score` | `!scores` | Affiche tes records personnels par mode. |

## Couteaux

| Commande | Effet |
|---|---|
| `!knife` | Affiche la liste des couteaux disponibles. |
| `!knife <nom>` | Te donne le couteau choisi (remplace ton équipement). |

Couteaux disponibles : classique, karambit, butterfly, m9 bayonet, bayonet, talon, skeleton, stiletto, ursus, nomad, paracord, survival, bowie, flip, gut, falchion, huntsman, shadow daggers, ghost knife.

Exemples : `!knife karambit`, `!knife talon`, `!knife m9`.

## Armes

| Commande | Effet |
|---|---|
| `!weapon` | Affiche la liste des armes disponibles. |
| `!weapon <nom>` | Te donne l'arme choisie (en plus de ton équipement). |

Exemples : `!weapon ak47`, `!weapon awp`, `!weapon deagle`, `!weapon usp`.

## Bots

| Commande | Effet |
|---|---|
| `!bots <n>` | Ajoute n bots Terroristes (difficulté max) — pratique pour le peek réaliste. Max 10. |
| `!nobots` | Retire tous les bots. |

> Les bots nécessitent un nav mesh sur la map : tape `nav_generate` une fois en console.

## Divers

| Commande | Effet |
|---|---|
| `!ammo` | Active/désactive les munitions infinies (serveur). |
| `!aide` / `!help` | Affiche l'aide complète dans le chat. |

## Réglages avancés

Modifie `training_config.lua` pour ajuster :

- `Precision` : durée, nombre de cibles (défaut 3), rayon de spawn, hauteur des cibles
- `Tracking` : vitesse des cibles, amplitude du strafe, mode `strafe` ou `orbit`
- `Peek` : angles min/max, distance, durée de vie des cibles, rythme de pop

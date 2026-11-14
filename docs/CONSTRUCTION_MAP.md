# Construire la map dans Hammer (CS2 Workshop Tools)

Ce guide crée une salle d'entraînement simple et branche les scripts VScript.

## 1. Préparer le projet

1. Installe les **CS2 Workshop Tools** (DLC gratuit de CS2 sur Steam) et lance-les.
2. Crée un nouvel addon : `training_aim`.
3. Copie les scripts de ce dépôt :
   ```
   addon/game/csgo/addons/cs2_training/scripts/vscripts/*.lua
   ```
   vers :
   ```
   <ton_addon>/game/csgo/addons/<ton_addon>/scripts/vscripts/
   ```

## 2. Créer la géométrie

Nouvelle map (une salle suffit) :

- **Salle principale** : environ `4096 x 4096 x 1024` unités, sol plat (très important : les modes calculent les positions de cibles à partir de la hauteur de tes pieds).
- **Zone de tir** : au moins `1200` unités de distance dégagée devant chaque zone de tir (les cibles spawnent entre 600 et 1100 unités du joueur).
- Optionnel : quelques **murs de couverture** au centre pour t'entraîner à peeker pour de vrai autour d'un angle.
- Éclairage : `light_environment` ou quelques `light_spot`. Ajoute un `skybox`.

## 3. Entités obligatoires

| Entité | Réglage | Rôle |
|---|---|---|
| `info_player_start` | au sol, zone de tir | spawn du joueur solo |
| `info_player_terrorist` (x5) | répartis dans la salle | spawns T |
| `info_player_counterterrorist` (x5) | répartis dans la salle | spawns CT (tes amis) |
| `logic_script` | propriété **Entity Scripts** : `training_main.lua` | charge tout le système d'entraînement |

> `logic_script` est la pièce clé : c'est lui qui exécute `training_main.lua` au chargement de la map. Pas besoin d'autres entités de logique — tout (cibles, scores, menus, couteaux) est géré par les scripts.

## 4. Nav mesh (pour `!bots`)

1. Compile la map (F9), lance-la en jeu.
2. Console : `sv_cheats 1` puis `nav_generate`.
3. Rejoins la map : les bots peuvent maintenant se déplacer.

## 5. Compiler et publier

1. F9 → compile (crée le `.vpk`).
2. Dans les Workshop Tools : **Upload** → renseigne nom/description → Publish.
3. En jeu, la map apparaît dans ton Workshop : lance-la en Practice et invite tes amis.

## 6. Tester sans Hammer

Voir [INSTALLATION.md](INSTALLATION.md) : `script_execute training_main` sur n'importe quelle map permet de tester les scripts immédiatement (si ton client autorise VScript).

## Astuces de réglage

- Les cibles du mode précision apparaissent dans un **rayon de 260 unités** autour d'un point à **850 unités** devant toi : garde cette zone libre de murs.
- Mode tracking : distance **1000 unités**, amplitude **±320**.
- Mode peek : cibles entre **600 et 1100 unités**, angles **15° à 80°** de chaque côté de ton regard.
- Tous ces nombres sont modifiables dans `training_config.lua`.

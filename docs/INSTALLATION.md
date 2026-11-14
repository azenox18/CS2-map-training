# Installation & lancement

## 1. Tester les scripts immédiatement (sans construire de map)

Tu peux tester toute la logique sur n'importe quelle map (ex. `de_dust2`) :

1. Copie le dossier `addon/game/csgo/addons/cs2_training/scripts` dans le dossier `game/csgo/scripts/` de ton installation CS2 (crée les dossiers si besoin).
2. Lance CS2 → **Jouer → Practice** → choisis une map.
3. Ouvre la console (`~`) et active les tricheurs :
   ```
   sv_cheats 1
   script_execute training_main
   ```
4. Tape `!aide` dans le chat. C'est parti.

> ⚠️ Voir la note "VScript" du README : si la commande `script_execute` n'existe pas chez toi, le runtime Lua est désactivé par ta version du jeu — passe par les Workshop Tools (étape 2).

## 2. Construire et publier la map (recommandé)

1. Installe les **Counter-Strike 2 Workshop Tools** : Steam → Bibliothèque → CS2 → Propriétés → DLC → cocher "Counter-Strike 2 Workshop Tools" (gratuit).
2. Suis le guide [CONSTRUCTION_MAP.md](CONSTRUCTION_MAP.md) pour créer la géométrie dans Hammer et brancher les scripts.
3. Compile la map (F9 dans Hammer), puis publie-la via l'outil d'upload du Workshop.
4. En jeu : `map <nom_de_ta_map>` ou invite tes amis sur la map depuis le Workshop.

## 3. Jouer avec des amis

- **Le plus simple** : publie la map sur le Workshop en public ou amis, puis crée une partie Practice sur cette map et invite via Steam.
- **Serveur dédié** : installe la map + le dossier `scripts` du côté serveur, puis partage l'IP.
- Chaque joueur tape ses commandes dans le chat (`!precision`, etc.) — les sessions sont indépendantes.

## Dépannage

| Problème | Solution |
|---|---|
| `script_execute` inconnu | Runtime VScript désactivé par le jeu — construis via les Workshop Tools ou active un patch VScript. |
| Les poulets ne meurent pas en un coup | Les cibles sont des `chicken` — toute balle les tue ; vérifie `mp_damage` / plugins serveur. |
| Les cibles apparaissent dans un mur | Le mode spawn les cibles devant toi : place-toi face à une zone dégagée de ~1100 unités (voir guide Hammer). |
| `!bots` ne fait rien | La map a besoin d'un nav mesh : tape `nav_generate` en console une fois sur la map, puis relance. |
| Rien ne s'affiche dans le chat | Recharge le script : `script_execute training_main`. |

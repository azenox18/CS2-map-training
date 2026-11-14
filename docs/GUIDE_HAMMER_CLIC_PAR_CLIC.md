# Guide Hammer clic par clic (de zéro à la map publiée)

Objectif : créer la salle d'entraînement, brancher `training_main.lua`, compiler, publier. Aucune connaissance préalable requise. Compte ~1 h la première fois.

## Étape 0 — Installer les Workshop Tools (5 min)

1. Steam → **Bibliothèque** → cherche **Counter-Strike 2** → clic droit → **Propriétés**
2. Onglet **DLC** → coche **Counter-Strike 2 Workshop Tools** → laisse Steam télécharger
3. Dans ta bibliothèque Steam, un nouveau jeu apparaît : **Counter-Strike 2 Workshop Tools**. C'est un programme séparé du jeu normal — **c'est lui qu'on utilise pour construire**.

## Étape 1 — Créer ton addon (2 min)

1. Lance **Counter-Strike 2 Workshop Tools**
2. Clique sur **Create New Addon**
3. Nom : `training_aim` → **Create**
4. Dans l'explorateur de l'addon, tu as des dossiers `content/` et `game/`

## Étape 2 — Copier les scripts (2 min)

1. Télécharge ce repo (bouton **Code → Download ZIP**) et dézip-le
2. Copie les 7 fichiers `.lua` situés dans :
   ```
   addon/game/csgo/addons/cs2_training/scripts/vscripts/
   ```
3. Colle-les dans :
   ```
   <Steam>/steamapps/common/Counter-Strike 2/content/csgo_addons/training_aim/scripts/vscripts/
   ```
   (crée les dossiers `scripts` et `vscripts` s'ils n'existent pas)

> ⚠️ Dans les Workshop Tools, le contenu source vit dans `content/csgo_addons/<ton_addon>/...`

## Étape 3 — Nouvelle map (2 min)

1. Dans les Workshop Tools : **Hammer** (l'éditeur de maps)
2. **File → New Map**
3. **File → Save As** → nomme-la `training_aim.vmap` dans le dossier maps de ton addon

## Étape 4 — Dessiner la salle (15 min)

1. Outil **Block** (raccourci **B**)
2. Dans une vue 2D (top), **clique-glisser** un grand rectangle d'environ **4096 x 4096 unités** (utilises les dimensions affichées en bas pendant le glissement)
3. Appuie sur **Entrée** → le bloc est créé (il apparaît rouge = solide)
4. Sélectionne-le (clic), puis :
   - **Ctrl+M** (transform) ou saisis-le dans une vue latérale et étire-le sur **1024 unités de haut**
5. Avec le bloc sélectionné : clic droit → **Tie to Entity** (raccourci **Ctrl+T**) → choisis **`func_brush`**... 

   **Plus simple** : garde le bloc en géométrie solide classique (world geometry) — pas besoin d'entité. Le sol = le sol du monde.

**En pratique minimaliste, fais plutôt ça :**
1. Dessine **1 gros bloc** qui sera la salle : sol + 4 murs + plafond (le bloc plein de l'étape 4 devient la salle une fois creusée — plus simple : dessine 6 blocs plats : 1 sol, 4 murs, 1 plafond)
2. Chaque bloc : outil **Block**, tu dessines, Entrée, tu positionnes
3. Dimensions conseillées :
   - Sol : 4096 x 4096 x 64 (épaisseur)
   - Murs : 4096 x 64 x 1024 (hauteur)
   - Plafond : 4096 x 4096 x 64, posé à 1024 unités du sol
4. Vérifie dans les vues 3D qu'il n'y a pas de trou (une salle fermée, sinon le compilateur râle)

## Étape 5 — Éclairage (3 min)

1. Outil **Entity** (raccourci **E**)
2. Dans le panneau de droite, classe : **`light_directional`** (lumière du soleil)
3. Clique dans une vue 3D **à l'intérieur de la salle, en hauteur** → Entrée
4. Double-clique dessus → mets **Brightness** à `300` → OK
5. Ajoute aussi un **`light_ambient`** (même méthode) avec Brightness `50` pour éviter les zones trop sombres

## Étape 6 — Les spawns (5 min)

Toujours avec l'outil **Entity** (E), place au sol (clique dans une vue 3D près du sol) :

| Classe | Combien | Où |
|---|---|---|
| `info_player_start` | 1 | centre de la salle |
| `info_player_terrorist` | 4 | répartis dans la salle |
| `info_player_counterterrorist` | 4 | répartis dans la salle |

Pour chaque : sélectionne la classe dans le panneau de droite → clic dans la map → **Entrée** pour valider la pose.

## Étape 7 — L'entité magique : `logic_script` (2 min) ⭐

C'est **l'étape la plus importante** — c'est elle qui lance tout le système d'entraînement :

1. Outil **Entity** (E)
2. Classe : **`logic_script`**
3. Clique dans la salle → **Entrée**
4. **Double-clique** sur l'entité → fenêtre Properties
5. Trouve la propriété **`vscripts`** (ou **Entity Scripts**) → clique dans son champ
6. Tape : **`training_main.lua`** → OK → ferme

> C'est tout ! Le script charge au démarrage de la map et affiche « [AIM] Map d'entrainement chargee ! » dans le chat.

## Étape 8 — Compiler et tester (10 min)

1. **F9** → fenêtre de compilation → **B** (Build) ou clique **Build**
2. Attends la fin (barre de progression)
3. **File → Play Map** (ou lance le jeu via les Tools) : la map démarre
4. Vérifications :
   - Chat : « **[AIM] Map d'entrainement chargee !** » → scripts OK
   - Tape `!aide` dans le chat → la liste des commandes apparaît
   - Tape `!precision` → 3 poulets apparaissent devant toi
5. Pour les bots : console `sv_cheats 1` puis **`nav_generate`** (une seule fois, recharge la map ensuite)

## Étape 9 — Publier sur le Workshop (5 min)

1. Dans les Workshop Tools : **Publish** (ou depuis Hammer : File → Publish)
2. Renseigne : titre (« Aim Training - Precision / Tracking / Peek »), description, tags
3. Visibilité : **Public** (ou **Private** pour tester avec tes amis d'abord)
4. **Upload** → la map apparaît sur ton profil Steam Workshop
5. Dans CS2 : **Jouer → Workshop** → ta map est là. Tu peux créer une partie Practice dessus et inviter tes amis — **ils n'ont rien à installer**.

## Dépannage

| Symptôme | Solution |
|---|---|
| Pas de message [AIM] au chargement | Vérifie l'étape 7 : le champ `vscripts` de `logic_script` doit contenir exactement `training_main.lua` |
| Erreur console mentionnant un fichier lua | Les scripts ne sont pas dans `content/csgo_addons/training_aim/scripts/vscripts/` — revoie l'étape 2 |
| Map toute noire | Ajoute/verifie les lumières (étape 5) |
| Cibles dans un mur | Place-toi face au grand espace dégagé avant de lancer un mode (les cibles spawnent à 600–1100 unités devant toi) |
| Compile échoue | Vérifie que la salle est fermée (aucun trou entre sol/murs/plafond) |

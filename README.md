# PluginQuesitonOBS
Lua scripts for OBS Studio to load questions from TXT/CSV files and synchronize text sources across different scenes.
#OBS Questions Plugin & Miroir

Un ensemble de deux scripts Lua pour OBS Studio permettant de charger facilement des questions depuis un fichier texte et de les synchroniser sur plusieurs scènes.
Ces scripts ont été créés pour être contrôlés depuis une seule fenêtre.

---

## 1 questions_plugin.lua

Ce script lit un fichier `.txt` en UTF-8 et transforme chaque ligne en une question sélectionnable via un menu déroulant. 
Il supporte correctement les accents et la ponctuation.

** Note sur les fichiers CSV :** Le script accepte les fichiers CSV, mais ce format pose souvent des plantages et ne supporte pas correctement les accents. Il est fortement recommandé d'utiliser un fichier `.txt`.

### Format du fichier TXT
Chaque ligne correspond à une question. Exemple :
> Tu t'en occupes quand de ta santé ?
> S'occuper de soi ou des autres
> Tu aimerais inventer un vaccin contre ...

### Installation et utilisation
1. Dans OBS, créez une source **Texte (GDI+)**. Donnez-lui le nom de votre choix (ex: *Source Question*).
2. Allez dans `Outils` -> `Scripts`.
3. Cliquez sur le bouton `+` et choisissez le fichier `questions_plugin.lua`.
4. Dans les paramètres du script :
   - Renseignez le **nom exact de votre source Texte** (ex: *Source Question*).
   - Cliquez sur "Parcourir" pour choisir votre fichier TXT.
   - Cliquez sur "Recharger les questions".
5. Sélectionnez la question à afficher dans le menu déroulant.
*(Si la liste ne se met pas à jour, fermez puis rouvrez la fenêtre "Scripts" ).*

**Note visuelle :** Le script ne modifie aucun paramètre visuel (police, taille, couleur, position). Vous pouvez styliser votre texte librement dans OBS.

---

## 2️ questions_miroir.lua

Ce script copie uniquement le texte d'une source dans une autre.
Parfait si vous avez besoin d'afficher la même question dans deux scènes totalement différentes.

### Installation et utilisation
1. Créez une deuxième source **Texte (GDI+)** qui servira de "miroir".
2. Allez dans `Outils` -> `Scripts`, cliquez sur `+` et ajoutez `questions_miroir.lua`.
3. Dans le premier champ, écrivez le nom de votre source originale.
4. Dans le deuxième champ, écrivez le nom de votre source miroir.

[cite_start]Le script synchronise en temps réel le texte de la source originale vers la source miroir
Tout comme le plugin principal, il ne modifie aucun paramètre visuel : les deux sources peuvent être mises en forme indépendamment.

---

 Utilisation combinée
Quand une question est sélectionnée dans `questions_plugin.lua`, le texte apparaît dans votre source principale
. En même temps, `questions_miroir.lua` détecte cette modification et copie automatiquement le texte dans votre source miroir.

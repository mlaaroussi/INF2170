TP1 - Convertisseur snake_case
-------------------------------------

L'objectif du TP est de réaliser un convertisseur CamelCase vers snake_case

##Spécification

Le programme prend en entrée une ligne de texte (une séquence de caractères terminée par un saut de ligne '\n'). Il affiche en sortie une version snake_case de cette chaîne (terminée également par un saut de ligne.)

###Quelques précisions :

Après l'affichage de la ligne, le programme se termine.
Aucun autre message ne doit être affiché (pas de message d’accueil par exemple).
Les blancs et sauts de lignes attendus doivent être respectés : ne pas en insérer, ne pas en enlever.
Les règles de transformation sont les suivantes:

**Règle 0**

En snake_case, il n'y a pas de majuscule et les mots sont séparés par des soulignés. Ainsi, toute entrée ne contenant pas de majuscule reste inchangée.

**Entrée 0**

    bonjour_le_monde

**Sortie 0**

    bonjour_le_monde

ATTENTION Ce test minimal simple conditionne l'acceptabilité de votre TP (voire la section Programme à rendre plus bas).

**Règle 1**

Les majuscules sont toujours converties en minuscules.

**Entrée 1**

    BONJOUR_le_monde

**Sortie 1**

    bonjour_le_monde

**Règle 2**

Lorsqu'une majuscule suit une minuscule, celle-ci est bien évidemment convertie en minuscule (règle 1), mais un souligné est inséré avant.

**Entrée 2**

    BonjourLeMonde

**Sortie 2**

    bonjour_le_monde

**Règle 3**

Lorsqu'une majuscule suit une majuscule et est suivi d'une minuscule, celle-ci est bien évidemment convertie en minuscule (règle 1), mais un souligné est également inséré avant.

**Entrée 3**

    BONJOURLeMonde

**Sortie 3**

    bonjour_le_monde

**Règle 4**

Les autres caractères (symboles, chiffres, blancs) sont laissés tels quels et n'interviennent pas dans les règles précédentes.

**Entrée 4**

    B0nj0urL3M0nd3!

**Sortie 4**

    b0nj0ur_l3m0nd3!

**Règle 5**

Il n'y a pas de règle 5, juste un dernier test pour la route.

**Entrée 5**

    HeadlineCNNNews_for_ThePeople

**Sortie 5**

    headline_cnn_news_for_the_people

####Réalisation
La réalisation de ce programme se fera par groupes d’au plus deux personnes. Chaque membre de l'équipe devra maîtriser tous les aspects du programme.

Le travail pratique comporte deux parties :

Le programme en Java traduisant l'algorithme. À remettre deux semaines avant la date de remise de la deuxième partie.
Le programme en assembleur Pep/8. À remettre à la date prévue.
Les programmes réalisés devront fonctionner sur la machine des tests publics (voir ci dessous).

###Partie 1 : Java
**Contraintes Java**

ATTENTION L'objectif de la partie Java est de vous aider a concevoir un algorithme qui fonctionne mais qui soit transposable en Pep/8. C'est pourquoi les contraintes particulières suivantes doivent êtres respectés :

N'utilisez pas de fonctionnalités avancés de Java (fonction de bibliothèques, programmation par objets, etc).
N'utilisez pas de multiplication, de division ou toute opération arithmétique inconnue de Pep/8.
N'utilisez pas de chaînes de caractères (String, StringBuffer, etc.) pour autre chose que de l'affichage.
N'utilisez pas l'opérateur new d’instanciation.
N'utilisez pas de tableaux, genre char[] ou int[].
Pour les entrées-sorties, vous devez utiliser la classe Pep8.java.
Votre programme doit tenir dans une seule classe.
Ne créez pas de structure de packages.
En cas de doute, demandez.

**Programme à rendre**
Listing papier du programme en Java à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Java via Oto : Remise en ligne (Manuel d'utilisation)
Nom du professeur à utiliser : privat_j
Nom de la boite oto : INF2170
Nom du fichier à soumettre : Snake.java
Vous pouvez faire autant de remises que vous voulez (seule la dernière est conservée).

**ATTENTION** L'entrée 0 est utilisée pour valider la remise du programme (compilation et exécution minimale). Si ce test ne passe pas un 0 est automatiquement attribué pour la partie du TP.

Vous pouvez tester automatiquement vos TP via oto:

Cliquez sur « vérifier un TP »
Nom de l'enseignant: mettez privat_j
Cliquez sur « Chercher »
Identifiant de l'évaluation: choisissez « INF2170 »
Fichiers à vérifier : ajoutez votre fichier Snake.java
Cliquez sur « Vérifier »

**Évaluation et barème indicatif**
50 points : Technique (conception et algorithmes)
25 points : Documentation (cartouche du programme, explication sur le fonctionnement, explication des variables, commentaires des instructions)
25 points : Fonctionnement (est-ce que le programme compile, fait les actions attendues et gère les cas limites prévus). Correspond au passage avec succès des 5 tests publics sur Oto (5 points par test).
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 26 septembre (au début du cours)

###Partie 2 : Pep/8
**Programme à rendre**
Listing papier du programme en Pep/8 à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Pep/8 via Oto : Comme en Java mais le fichier doit s'appeler snake.pep. Les règles de remises et de vérification restent les mêmes.

**Évaluation et barème indicatif**
50 points : Fonctionnement, toujours sur Oto. 5 tests publics, 5 tests privés (5 points par test réussi).
30 points : Documentation, lisibilité du code (commentaires, noms des symboles, explication des choix, indentation, entête des programmes et sous programmes...)
20 points : Qualité logicielle et programmation (choix structurels, algorithmes, simplicité, robustesse, gestion des erreurs...)
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 10 octobre (au début du cours)
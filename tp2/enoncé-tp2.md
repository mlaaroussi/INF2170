TP2 - routage dans un réseau
---------------

Les nouveaux routeurs programmables haute performance ont été enfin livrés. Malheureusement, à cause d'une erreur de typographie dans le cahier des charges, ces routeur possèdent un processeur Pep8 et ne sont programmables qu'en ce langage.

L'objectif du TP est d'implémenter un algorithme de routage en fonction d'une description de la topologie de réseau fournie en entrée.

Description d'une topologie de réseau.
Un réseau est constitué de n routeurs et de m liaisons. Chaque liaison est bi-directionnelle et relie deux routeurs.

Le programme lit une topologie en entrée. Puis lit une commande numérique (de 0 à 3).

La description d'une topologie est constituée d'une séquence de nombres ayant la forme suivante:

le nombre le routeurs n, compris entre 1 et 16. Par la suite, chaque routeur sera identifié par un numéro de 0 à n-1.
le nombre de liaisons m, positif ou nul.
pour chaque liaison, une paire de numéros de routeur. l'ordre de liaisons et des routeurs dans chaque liaison n'a pas d'importance.
Notes:

Une liaison redondante ou reliant un routeur à lui-même est ignorée.
Si l’entrée est mal formatée, une erreur est affichée et le programme se termine.

####Commande 0 -- comptage

La commande 0 affiche le nombre de routeurs et de liaisons, puis termine le programme.

**Entrée 0**

    8
    7
    
    0 1
    1 2
    2 3
    3 4
    4 5
    5 1
    6 7
    
    0

**Sortie 0**

    n=8
    m=7

**ATTENTION** Ce test minimal simple conditionne l'acceptabilité de votre TP (voir la section Programme à rendre plus bas).

####Commande 1 -- adjacence

La commande 1 affiche la matrice d'adjacence du réseau, puis termine le programme.

Une matrice d'adjacence est une grille n x n composée de 0 et de 1. Il y a un 1 à la ligne i et à la colonne j s'il y'a un lien direct entre les routeurs i et j. Sinon il y a un 0.

Attention: Chaque nombre, 0 ou 1 doit être suivi d'un espace, sauf le dernier nombre d'une ligne qui doit être suivi d'un '\n'.

**Entrée 1**

    8
    7
    
    0 1
    1 2
    2 3
    3 4
    4 5
    5 1
    6 7
    
    1

**Sortie 1**

    0 1 0 0 0 0 0 0
    1 0 1 0 0 1 0 0
    0 1 0 1 0 0 0 0
    0 0 1 0 1 0 0 0
    0 0 0 1 0 1 0 0
    0 1 0 0 1 0 0 0
    0 0 0 0 0 0 0 1
    0 0 0 0 0 0 1 0

**Implémentation:**

vu que le nombre maximal de routeurs est 16, réservez d'avance l'espace maximal avec un .BLOCK suffisamment grand pour stocker toute la matrice.
pour la partie Java, vous initialiserez vos matrices avec un new (seul cas ou c'est autorisé)

**Commande 2 -- distance**

La commande 2 affiche la matrice des distances du réseau.

Une matrice des distances est une grille n x n composée de nombres. La valeur à la ligne i et à la colonne j indique le nombre minimal de liens reliant le routeur i au routeur j. S'il n'est pas possible de rejoindre le routeur j à partir du routeur i, alors un x est affiché.

**Attention**: l'affichage respecte les mêmes règles que celles de la commande 1.

**Entrée 2**

    8
    7
    
    0 1
    1 2
    2 3
    3 4
    4 5
    5 1
    6 7
    
    2

**Sortie 2**

    0 1 2 3 3 2 x x
    1 0 1 2 2 1 x x
    2 1 0 1 2 2 x x
    3 2 1 0 1 2 x x
    3 2 2 1 0 1 x x
    2 1 2 2 1 0 x x
    x x x x x x 0 1
    x x x x x x 1 0

**Implémentation:**

Pour calculer les distances entre les routeurs, l'algorithme le plus simple à implémenter est celui de Floyd-Warshall.

**Commande 3 -- routage**

La dernière commande, 3, affiche le plus court chemin entre deux routeurs.

La commande 3 lit des paires de routeurs, et pour chacune de ces paires i j affiche le chemin à parcourir partant de i et arrivant à j.

Le programme se termine lorsque -1 est entré.

Pour chaque paire de routeurs i et j, trois configurations existent:

s'il a un chemin, alors i, chaque routeur intermédiaire, puis j sont affichés avec une flèche (->) entre chacun.
s'il n'y a pas de chemin, alors i et j sont affichés avec un flèche barrée entre les deux (-X->)
si i == j, alors le routeur est juste affiché sans rien d'autre.

**Entrée 3**

    8
    7
    
    0 1
    1 2
    2 3
    3 4
    4 5
    5 1
    6 7
    
    3
    0 1
    5 3
    3 0
    7 6
    0 6
    1 1
    -1

**Sortie 3**

    0->1
    5->4->3
    3->2->1->0
    7->6
    0-X->6
    1

**Implémentation:**

utilisez la partie Path reconstruction de la page wikipédia pour obtenir les chemins entre les routeurs.
Les deux derniers tests

**Entrée 4**

    16
    15
    0 1
    1 2
    2 3
    3 4
    4 5
    5 6
    6 7
    7 8
    8 9
    9 10
    10 11
    11 12
    12 13
    13 14
    14 15
    
    3
    0 15
    15 0
    -1

**Sortie 4**

    0->1->2->3->4->5->6->7->8->9->10->11->12->13->14->15
    15->14->13->12->11->10->9->8->7->6->5->4->3->2->1->0

**Entrée 5**

    7
    8
    2 3
    4 5
    0 1
    6 5
    2 1
    5 2
    1 3
    0 4
    
    3
    6 3
    1 6
    0 3
    -1

**Sortie 5**

    6->5->2->3
    1->2->5->6
    0->1->3

**Quelques précisions :**

Aucun autre message ne doit être affiché (pas de message d’accueil par exemple).
Les blancs et sauts de lignes attendus doivent être respectés : ne pas en insérer, ne pas en enlever.
Réalisation
La réalisation de ce programme se fera par groupes d’au plus deux personnes. Chaque membre de l'équipe devra maîtriser tous les aspects du programme.

Le travail pratique comporte deux parties :

Le programme en Java traduisant l'algorithme. À remettre deux semaines avant la date de remise de la deuxième partie.
Le programme en assembleur Pep/8. À remettre à la date prévue.
Les programmes réalisés devront fonctionner sur la machine des tests publics (voir ci dessous).

Partie 1 : Java
---------------

**Contraintes Java**

**ATTENTION** L'objectif de la partie Java est de vous aider a concevoir un algorithme qui fonctionne mais qui soit transposable en Pep/8. C'est pourquoi les contraintes particulières suivantes doivent êtres respectés :

N'utilisez pas de fonctionnalités avancés de Java (fonction de bibliothèques, programmation par objets, etc).
N'utilisez pas de chaînes de caractères (String, StringBuffer, etc.) pour autre chose que de l'affichage.
N'utilisez pas l'opérateur new d’instanciation pour les objets.
Pour les entrées-sorties, vous devez utiliser la classe Pep8.java.
Votre programme doit tenir dans une seule classe.
Ne créez pas de structure de packages.
En cas de doute, demandez.

**Différences avec le TP1:**

Vous avez droit aux opérations arithmétiques, sous réserve d'être capable de les implémenter en Pep/8.
Vous avez droit aux tableaux de types primitifs, genre char[] ou int[][].
Vous avez droit au new pour construire les tableaux de types primitifs.
Il vous est recommandé de découper votre programme en fonctions et procédures

**Programme à rendre**

Listing papier du programme en Java à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Java via Oto : Remise en ligne (Manuel d'utilisation)
Nom du professeur à utiliser : `privat_j`
Nom de la boite oto : `INF2170`
Nom du fichier à soumettre : `Routeur.java`
Vous pouvez faire autant de remises que vous voulez (seule la dernière est conservée).

**ATTENTION** L'entrée 0 est utilisée pour valider la remise du programme (compilation et exécution minimale). Si ce test ne passe pas un 0 est automatiquement attribué pour la partie du TP.

Vous pouvez tester automatiquement vos TP via oto:

Cliquez sur « vérifier un TP »
Nom de l'enseignant: mettez privat_j
Cliquez sur « Chercher »
Identifiant de l'évaluation: choisissez « INF2170 »
Fichiers à vérifier : ajoutez votre fichier Routeur.java
Cliquez sur « Vérifier »
Évaluation et barème indicatif

50 points : Technique (conception et algorithmes)
25 points : Documentation (cartouche du programme, explication sur le fonctionnement, explication des variables, commentaires des instructions)
25 points : Fonctionnement (est-ce que le programme compile, fait les actions attendues et gère les cas limites prévus). Correspond au passage avec succès des 5 tests publics sur Oto (5 points par test).
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 24 octobre (au début du cours)

Partie 2 : Pep/8
----------------

**Programme à rendre**

Listing papier du programme en Pep/8 à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Pep/8 via Oto : Comme en Java mais le fichier doit s'appeler routeur.pep. Les règles de remises et de vérification restent les mêmes.
**Évaluation et barème indicatif**

50 points : Fonctionnement, toujours sur Oto. 5 tests publics, 5 tests privés (5 points par test réussi).
30 points : Documentation, lisibilité du code (commentaires, noms des symboles, explication des choix, indentation, entête des programmes et sous programmes...)
20 points : Qualité logicielle et programmation (choix structurels, algorithmes, simplicité, robustesse, gestion des erreurs...)
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 7 novembre (au début du cours)
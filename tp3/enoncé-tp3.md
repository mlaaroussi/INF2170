TP3-Expressions arithmétiques
-----------------------------

L'objectif de ce TP est de réaliser un évaluateur d'expressions arithmétiques en notation préfixe.

Une expression arithmétique est constituée de nombres et d'opérations sur des sous-expressions arithmétiques appelées ses opérandes.

Traditionnellement, les expressions arithmétiques sont écrites en plaçant les opérateurs binaires entre les opérandes (appelée notation infixe), ce qui impose l'utilisation de règles de priorité et de parenthèses quand les expressions deviennent complexes.

**Par exemple**

    1 + 3 * (6 - 4) - 2

vaut 5 car les parenthèses ont priorité sur la multiplication qui a priorité sur l'addition.

D'autres façons d'écrire les expressions arithmétiques existent. Dans ce TP, nous allons programmer la notation préfixe (ou polonaise). Elle se caractérise par le fait que les opérateurs sont situés devant les opérandes. Ainsi, l'expression précédente s'écrirait

    - + 1 * 3 - 6 4 2

Cette notation n'est pas naturelle pour l'humain. Mais elle possède un très bon avantage: elle ne nécessite pas de règle de priorité ni de parenthèse.

En effet, il est très facile pour un ordinateur de lire et de traiter une telle notation. Par exemple, si au lieu d'opérateurs, nous utilisions des fonctions, cela revient exactement à faire:

    soustraction(addition(1, multiplication(3, soustraction(6, 4))), 2)

Toutefois, si l'objectif est de représenter et manipuler une expression arithmétique dans un programme, la représentation la plus simple consiste à fabriquer un structure arborescente (appelé simplement arbre) dans lequel un élément est soit une opération soit un nombre; et où une opération à deux éléments fils : un pour chacune de ses deux opérandes.

Ainsi, la même expression serait représentée par un arbre ayant la structure suivante:

    soustraction
    |-- addition
    |   |-- 1
    |   `-- multiplication
    |       |-- 3
    |       `-- soustraction
    |           |-- 6
    |           `-- 4
    `-- 2

**Fonctionnalités demandées**
Le programme lit une expression arithmétique en notation préfixe puis attend une séquence de commandes.

Une expression arithmétique est composée de nombres et des quatre opérateurs binaires +, -, *, et / (/ étant la division entière). Les nombres sont séparés par des espaces et des sauts de ligne (\n); autrement les espaces et sauts de lignes sont ignorés.

**Attention**, vu que les sauts de lignes valent la même chose qu'un espace, l'expression en entrée peut être sur plusieurs lignes sans que cela change quoi que ce soit.

Les commandes sont des caractères suivis d'arguments éventuels. Les commandes sont traitées les unes à la suite des autres. Les espaces et sauts de lignes sont ignorés lors de la lecture des commandes.

En cas d'expression ou de commande invalide, le programme doit afficher un message d'erreur et s'arreter.

**Les quelques précisions habituelles**

Aucun autre message que ceux demandés ne doit être affiché (pas de message d’accueil par exemple).
Les blancs et sauts de lignes attendus doivent être respectés : ne pas en insérer, ne pas en enlever.
Note additionnelle: afin de simplifier le développement, on ignorera les erreurs de débordement lors des opérations arithmétiques.

**Précisions additionnelles**

La spécification fait qu'il n'est pas possible de saisir des nombres négatifs. En effet le - est toujours interprété comme l'opérateur de soustraction, et c'est le comportement voulu.
Par contre, il est possible de calculer des valeurs négatives. Il suffit par exemple de saisir l'expression - 0 12 pour calculer -12.

###Étape 0: Commande d'arrêt .

La commande . affiche un point (.), un saut de ligne (\n) et quitte le programme.

**Entrée 0**

    5
    .

**Sortie 0**

    .

**Explication**
L'expression arithmétique, constituée seulement du nombre 5, est lue. Puis la commande . est lue et exécutée.

Ce qui fait afficher une ligne avec seulement un ..

Dans cette exemple l'expression arithmétique ne servait à rien en fait.

**ATTENTION** Ce test minimal simple conditionne l'acceptabilité de votre TP (voir la section Programme à rendre plus bas).

###Étape 1: Commande de calcul =

La commande = affiche le résultat du calcul de l'expression arithmétique, suivi d'un saut de ligne.

**Entrée 1**

    - + 2 - 6 + 3 4 1
    =
    .

**Sortie 1**

    0
    .

**Explication**
L'expression est lue et évaluée. Pour se faire, calculez l'expression lors de la lecture avec des fonctions récursives.

Vous allez remarquer que vous ne pouvez pas vraiment utiliser DECI ici. Ainsi, pour vous simplifier la vie à cette étape:

considérez que les nombres sont seulement compris entre 0 et 9.
n'implémentez que les additions et les soustractions.
gérez les espaces et sauts de lignes le plus simplement possible.
###Étape 2: Amélioration de la lecture et des opérations

Améliorez l'étape précédente en implémentant:

les nombres plus grand que 9
les opérateurs * et /
la gestion complète et robuste des espaces et sauts de lignes.
**Entrée 2**

    +01234 /
    +
    2 *3
    
       -
       60
    40   2 =.

**Sortie 2**

    1265
    .

###Étape 3: Construction d'un arbre.

Modifiez l'étape précédente en séparant la lecture et le calcul en deux fonctionnalités distinctes. Cela se fait en construisant une structure de donnée intermédiaire : notre fameux arbre.

Ici, notre arbre est constitué de deux types d'éléments: des nombres et des opérations binaires. Un nombre est un élément constitué d'un entier. Une opération binaire est un élément constitué d'un opérateur, d'une opérande gauche et d'une opérande droite.

Utilisez des structures pour représenter les éléments d'un arbre et n'oubliez pas:

de penser à pouvoir distinguer les nombres des opérations.
d'associer aux opérations leurs opérandes.
L'étape de lecture doit lire l'expression et construire un arbre. La construction de l'arbre doit se faire au fur et à mesure de la lecture. Utilisez des fonctions récursives qui allouent les éléments de l'arbre sur le tas en fonction des besoins.

L'étape de calcul se sert de l'arbre pour calculer le résultat. Utilisez également des fonctions récursives mais, cette fois-ci, qui parcourent l'arbre.

**Entrée 3**

    - + 1 * 3 - 6 4 2 ==.

**Sortie 3**

    5
    5
    .

**Explication**
Il y a deux = donc le calcul et l'affichage ont lieu deux fois (même si ça donne nécessairement le même résultat).

En fait, fonctionnellement il ne devrait y avoir aucune différence entre l'étape 2 et l'étape 3. C'est toutefois l'étape la plus technique à réaliser.

###Étape 4: Commande d'écriture infixe >

La commande > affiche l'expression arithmétique sous une représentation infixe (la représentation traditionnelle). Pour déjouer les problèmes de priorité, des paires de parenthèses sont systématiquement ajoutés autour de chaque opération binaire.

Aucun espace n'est inséré est l'expression est terminé par un saut de ligne (\n).

**Entrée 4**

    * - 30 28 / 7 3
    =
    >
    .

**Sortie 4**

    4
    ((30-28)*(7/3))
    .

**Explication**
L'expression est lue et un arbre est fabriqué.

Puis le = lance le calcul et affiche le résultat.

Puis le > lance l'affichage de l'expression sous une forme infixe.

Puis le . termine le programme.

Pour implémenter l'affichage sous une forme infixe, développez à nouveau une fonction récursive. Notez toutefois qu'il est possible d'afficher l'expression au fur et à mesure, donc qu'il n'est pas nécessaire de construire et stocker des morceaux de chaînes de caractères en mémoire.

###Étape 5: expression et variable.

À cette étape, on permet d'utiliser une variable x dans les expressions. Seul le caractère x est autorisé et correspond à un nombre dont on ignore (pour l'instant) la valeur. x peut être utilisé aucune, une ou plusieurs fois dans une même expression.

La commande x (oui, c'est bien le même caractère) permet, après coup, d'affecter une valeur à x. C'est cette valeur qui sera utilisée lors des prochaines évaluations (commande =), à moins bien sûr qu'une nouvelle valeur soit affecté à x entre temps.

Pour la commande >, la variable s'affiche toujours comme un x quelque soit la valeur qui lui est affectée.

**Entrée 5**

    + - 4 x * x 2
    x 1
    =
    x 0
    =
    >
    .

**Sortie 5**

    5
    4
    ((4-x)+(x*2))
    .

**Explication**
L'expression est lue et un arbre est fabriqué.

Puis x 1 affecte 1 à la variable.

Puis = lance le calcul sachant que x vaut 1.

Puis le x 0 affecte 0 à la variable.

Puis = lance un nouveau calcul sachant que x vaut maintenant 0.

Puis > affiche l'expression sous forme infixe.

Puis le . termine le programme.

**Réalisation**
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
Pour les entrées-sorties, vous devez utiliser la classe Pep8.java.
Votre programme doit tenir dans une seule classe.
Ne créez pas de structure de packages.
En cas de doute, demandez.

**Différences avec le TP2:**

Vous avez le droit d'utiliser des classes simples avec des champs publics pour avoir l'équivalent de structures simples
L'allocation de ces classes (avec le mot clé new)
Programme à rendre

Listing papier du programme en Java à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Java via Oto : Remise en ligne (Manuel d'utilisation)
Nom du professeur à utiliser : `privat_j`
Nom de la boite oto : `INF2170`
Nom du fichier à soumettre : `Calc.java`
Vous pouvez faire autant de remises que vous voulez (seule la dernière est conservée).

**ATTENTION** L'entrée 0 est utilisée pour valider la remise du programme (compilation et exécution minimale). Si ce test ne passe pas un 0 est automatiquement attribué pour la partie du TP.

Vous pouvez tester automatiquement vos TP via oto:

Cliquez sur « vérifier un TP »
Nom de l'enseignant: mettez privat_j
Cliquez sur « Chercher »
Identifiant de l'évaluation: choisissez « INF2170 »
Fichiers à vérifier : ajoutez votre fichier Calc.java
Cliquez sur « Vérifier »
Évaluation et barème indicatif

50 points : Technique (conception et algorithmes)
25 points : Documentation (cartouche du programme, explication sur le fonctionnement, explication des variables, commentaires des instructions)
25 points : Fonctionnement (est-ce que le programme compile, fait les actions attendues et gère les cas limites prévus). Correspond au passage avec succès des 5 tests publics sur Oto (5 points par test).
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 21 novembre (au début du cours)

Partie 2 : Pep/8
----------------

**Programme à rendre**

Listing papier du programme en Pep/8 à rendre en cours (pas d'enveloppe, agrafes uniquement)
Remise en ligne du source en Pep/8 via Oto : Comme en Java mais le fichier doit s'appeler calc.pep. Les règles de remises et de vérification restent les mêmes.

**Évaluation et barème indicatif**

50 points : Fonctionnement, toujours sur Oto. 5 tests publics, 5 tests privés (5 points par test réussi).
30 points : Documentation, lisibilité du code (commentaires, noms des symboles, explication des choix, indentation, entête des programmes et sous programmes...)
20 points : Qualité logicielle et programmation (choix structurels, algorithmes, simplicité, robustesse, gestion des erreurs...)
Note finale sur 100.
Détail de l'évaluation
Date de remise

Au plus tard le 5 décembre (au début du cours)
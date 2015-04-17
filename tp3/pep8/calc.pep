;---------------------------------------------------------------------------------------
;                                  LAAROUSSI Mohamed
;                               INF2170-TP3 2EME PARTIE
;                                      21-11-2014
;---------------------------------------------------------------------------------------
; OBJECTIF
; ========
; L'objectif de ce programme est de réaliser un évaluateur d'expressions
; arithmétiques en notation préfixe.
;
; Le programme lit une expression arithmétique en notation préfixe composée de
; nombres, des quatre opérateurs binaires +, - et /  et d'une variable x,
; puis attend une séquence de commandes:
; -> La commande d'arrêt '.'
;       affiche un point (.), un saut de ligne (\n) et quitte le programme.
; -> La commande de calcul '='
;       affiche le résultat du calcul de l'expression arithmétique, suivi d'un
;       saut de ligne.
; -> La commande d'écriture infixe '>'
;       affiche l'expression arithmétique sous une représentation infixe.
; -> La commande x
;       affecte une valeur à x qui sera utilisée lors des prochaines évaluations.
;
; IMPLÉMENTATION
; ==============
; On a choisi de représenter l'expression arithmétique avec une structure
; arborescente (arbre) dans lequel un élément est soit une opération soit un nombre,
; et où une opération à deux éléments fils : un pour chacune de ses
; deux opérandes.
; l'element de notre arbre est un entier, j'ai choisi des entiers négatifs pour
; représenter et stocker les opérateurs et x dans l'arbre pour distinguer les nombres
; des opérations et de x, et de les décoder à la phase de calcul et a la phase
; d'affichage infixe.
;
; CAS LIMITES
; ===========
; Le programme ne traite pas les expressions arithmétiques avec des entiers négatifs
; (opérateurs  unaire).
;
;------------------------------------------------------------------------------------
;
; Lecture et construction de l'arbre.
; Arbre tete = lire()
;
         SUBSP   2,i         ; Empiler  #arbre
         CALL    lire        
         LDX     0,s         ; #arbre
         ADDSP   2,i         ; Depiler  #arbre
         STX     tete,d      ; on stock l'adresse de la tete de l'arbre
;
;Lecture d'une séquence de commandes.
         LDA     0,i         
         LDBYTEA cmd,d       
loop:   CPA     '.',i       ; while (cmd != '.'){
         BREQ    arreter     
         CHARI   cmd,d       
         LDA     0,i         
         LDBYTEA cmd,d       
;
         CPA     '.',i       ; si cmd= '.' on brance sur cmdArret
         BREQ    cmdArret    
         CPA     '=',i       ; si cmd= '=' on brance sur cmdCalc
         BREQ    cmdCalc     
         CPA     '>',i       ; si cmd= '>' on brance sur cmdInfix
         BREQ    cmdInfix    
         CPA     'x',i       ; si cmd= 'x' on brance sur cmdX
         BREQ    cmdX        
; Les espaces et sauts de lignes sont ignorés.
         CPA     '\n',i      
         BREQ    loop       
         CPA     ' ',i       
         BREQ    loop       
;
         BR      cInvalid    ; sinon on brance sur cInvalid
;
;Commande d'arret (.)
cmdArret:CHARO   '.',i       
         CHARO   '\n',i      
         BR      arreter     
;
;Commande de calcul (=) .
cmdCalc: LDA     tete,d      ; On charge la tete de l'arbre cree en phase de lecutre
; dans A pour le passer comme parametre de la methode evaluer
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
;
         STA     tmp,d       ; tmp = evaluer(tete)
         DECO    tmp,d       ; print tmp
         CHARO   '\n',i      
;
         BR      loop       
;
; Commande d'écriture infixe (>)
cmdInfix:LDA     tete,d      ; On charge la tete de l'arbre cree en phase de lecutre
; dans A pour le passer comme parametre de la methode infixe
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         ; #ar
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
         CHARO   '\n',i      
;
         BR      loop       
;
; La commande x permet d'affecter une valeur à la variable x
cmdX:    DECI    x,d         
         BR      loop       
;
; Cas d'une commade invalide,On affiche un message et on arrete le programme
cInvalid:STRO    MSG_CMD,d   ;}//fin while
;
arreter: STOP                ;arreter le programme
;
;-----------------------------------------------------------------------------------
; lire:
; =====
; Fonction récursive qui lit une expression arithmetique et qui construit une arbre.
; Cette fonction fait appel a la fonction nxtToken defini au dessous pour lire un
; terme de l'expression.
;
; IN:  pas de paramètres
; OUT: "arbre" addresse vers le noeud tete de l'arbre consruite
;
;-----------------------------------------------------------------------------------
;
arbre:   .EQUATE 8           ; Resultat #2h
elt:     .EQUATE 4           ; Variable locale #2d
g:       .EQUATE 2           ; Variable locale #2h
d:       .EQUATE 0           ; Variable locale #2h
;
lire:    SUBSP   6,i         ; Empiler #elt #g #d
         CHARI   cTmp,d      
         LDA     0,i         
         LDBYTEA cTmp,d      
; On fait un appel a la fonction nextToken pour obtenir un terme de l'expression
; arithmetique.
         SUBSP   3,i         ;empiler  #nxRslt #caracLu
         STBYTEA 0,s         ;#caracLu
         CALL    nxtToken    
         LDA     1,s         ; #nxRslt
         ADDSP   3,i         ;depiler #nxRslt #caracLu
;
         STA     elt,s       ;elt = nextToken(caracLu)
;
         CPA     PLUS,i      
         BREQ    estOpr      
         CPA     MOINS,i     
         BREQ    estOpr      
         CPA     ETOILE,i    
         BREQ    estOpr      
         CPA     SLASH,i     
         BRNE    nonOpr      
; Si elt represente un opérateur arithmétique (J'ai choisi de représenter les
; opérateur avec des entier négatifs pour distinguer les nombres des opérations)
estOpr:  LDA     arTaille,i  
;On cree un nouveau noeud
         CALL    new         ; X = new Arbre(); #element #gauche #droit
         STX     arbre,s     ; On pointe l'adresse du noeud cree vers X
;
; arbre.element = elt;
         LDA     elt,s       
         STA     element,x   
;
; On fait un 1er appel recursif pour l'affecter au noeud gauche
         SUBSP   2,i         ;empiler  #arbre
         CALL    lire        
         LDA     0,s         ;#arbre
         ADDSP   2,i         ;depiler   #arbre
;
         STA     g,s         ; On stock le resultat de lire dans la variable local g
         LDX     arbre,s     ; On remet X
         STA     gauche,x    ; arbre.gauche = lire();
;
; On fait un 2eme appel recursif pour l'affecter au noeud droit
         SUBSP   2,i         ;empiler  #arbre
         CALL    lire        
         LDA     0,s         ;#arbre
         ADDSP   2,i         ;depiler   #arbre
;
         STA     d,s         ; On stock le resultat de lire dans la variable local g
         LDX     arbre,s     ; On remet X
         STA     droit,x     ; arbre.droit = lire();
;
         BR      finLire     
; Si elt ne represente pas un opérateur arithmétique(chiffre ou x)
nonOpr:  LDA     arTaille,i  
;On cree un nouveau noeud
         CALL    new         ;   X = new Arbre() #element #gauche #droit
         STX     arbre,s     ; On pointe l'adresse du noeud cree vers X
;
; arbre.element = elt;
         LDA     elt,s       
         STA     element,x   
;On pointe les adresses des noeuds gauche et droit vers 0 (adresse nulle)
         LDA     0,i         
         STA     gauche,x    ; arbre.gauche = null
         STA     droit,x     ;arbre.droit = null
;
finLire: ADDSP   6,i         ; depiler #elt #g #d
         RET0                
;-----------------------------------------------------------------------------------
; nxtToken:
; =========
; Fonction recursive qui permet d'obtenir un terme (opérateur ou opérande) d'une
; expression en fonction du caractère passé en paramètre.
; Cette fonction facilite la tache a la fonction de lecure (lire)
;
; IN:  Paramètre "caracLu"
;
; OUT: "nxRslt"  le terme (opérateur ou opérande) d'une expression sous forme
; d'entier :
;      * Si le parametre est opérateur ou x on retourne l'entier négatif qui le
;        represente.(-10 pour le signe +, -11 pour -, etc. voir les equate PLUS,
;        MOINS,ETOILE ... en bas)
;      * Si le parametre est un caractère numérique on lit le suivant et on
;        l'additionne au parametre multiplié par 10 jusqu'à la rencontre d'un
;        caractère non numérique et retourne l'entier composé par ces caractères
;        numériques lues.
;      * Sinon si le parametre est un caractère non autorisé on affiche un
;        message et on arrete le programme.
;-----------------------------------------------------------------------------------
nxRslt:  .EQUATE 5           ; Resultat #2d
caracLu: .EQUATE 4           ; Paramètre #1c
nxTmp:   .EQUATE 0           ; Variable locale #2d
;
nxtToken:SUBSP   2,i         ; Empile #nxTmp
         LDA     0,i         ; On nettoie le registre A pour recevoir un caractère
         LDBYTEA caracLu,s   
;
; Si caracLu est un caractère numérique on lit le suivant et on l'additionne au
; caracLu multiplié par 10 jusqu'à la rencontre d'un caractère non numérique
; et retourne l'entier composé par ces caractères numérique.
         CPA     '0',i       
         BRLT    siPlus      
         CPA     '9',i       
         BRGT    siPlus      
         SUBA    '0',i       
         STA     nxTmp,s     
cLoop:   CHARI   caracLu,s   
         LDA     0,i         ; On nettoie le registre A pour recevoir un caractère
         LDBYTEA caracLu,s   
         CPA     '0',i       
         BRLT    finCLoop    
         CPA     '9',i       
         BRGT    finCLoop    
;
; On fait la multiplication a l'aide de la fonction produit avec comme paramètres
; des variables globales p_param1 et p_param2 et resultat de retour p_rslt
         LDA     nxTmp,s     
         STA     p_param1,d  ; p_param1 = nxTmp
         LDA     10,i        
         STA     p_param2,d  ; p_param1 = 10
         CALL    produit     ; p_rslt = produit(nxTmp,10)
         LDA     0,i         
         LDBYTEA caracLu,s   
         SUBA    '0',i       ; pour convertir caracLu en entier (caracLu - '0')
         ADDA    p_rslt,d    
         STA     nxTmp,s     ; nxTmp = nxTmp *10 + caracLu - '0'
         BR      cLoop       
;
finCLoop:LDA     nxTmp,s     
         STA     nxRslt,s    
         BR      finNxt      
;
; Si caracLu est un opérateur arithmétique(+ ,- ,* , /)
; on retourne l'entier négatif qui le represente (-10 pour +,-11 pour - ,etc... voir
; les equates en bas PLUS,MOINS ... )
siPlus:  CPA     '+',i       ; Si caracLu =  '+'
         BRNE    siMoins     
         LDA     PLUS,i      
         STA     nxRslt,s    ; return -10
         BR      finNxt      
siMoins: CPA     '-',i       ; Si caracLu =  '-'
         BRNE    siEtoile    
         LDA     MOINS,i     
         STA     nxRslt,s    ; return -11
         BR      finNxt      
siEtoile:CPA     '*',i       ; Si caracLu =  '*'
         BRNE    siSlash     
         LDA     ETOILE,i    
         STA     nxRslt,s    ; return -12
         BR      finNxt      
siSlash: CPA     '/',i       ; Si caracLu =  '/'
         BRNE    siX         
         LDA     SLASH,i     
         STA     nxRslt,s    ; return -13
         BR      finNxt      
; Si caracLu est egale a 'x'
; on retourne l'entier négatif qui le represente (-14 ,.EQUATE X ).
siX:     CPA     'x',i       ; Si caracLu =  'x'
         BRNE    siEspace    
         LDA     X,i         
         STA     nxRslt,s    ; return -14
         BR      finNxt      
; Si caracLu est un espace ou saut de ligne on continue a lire tant que caracLu est
; un espace ou saut de ligne sinon on fait un appel recursif de la fonction
siEspace:CPA     ' ',i       ; Si caracLu =  ' ' ou caracLu =  '\n'
         BREQ    spLoop      
         CPA     '\n',i      
         BRNE    siAutre     
spLoop:  CHARI   caracLu,s   
         LDA     0,i         
         LDBYTEA caracLu,s   
         CPA     ' ',i       
         BREQ    spLoop      
         CPA     '\n',i      
         BRNE    rappl       
         BR      spLoop      
rappl:   SUBSP   3,i         ; Empiler  #nxRslt #caracLu
         STBYTEA 0,s         ; #caracLu
         CALL    nxtToken    ; appel recursif
         LDA     1,s         ; #nxRslt
         ADDSP   3,i         ; Depiler  #nxRslt #caracLu
;
         STA     nxRslt,s    ; return nxtToken(caracLu)
         BR      finNxt      
; Sinon on affiche un message d'erreur et on arrete le programme.
siAutre: STRO    MSG_EXP,d   
         BR      arreter     
finNxt:  ADDSP   2,i         ; Depiler #nxTmp
         RET0                
;
;-----------------------------------------------------------------------------------
; evaluer
; =======
; Fonction récursive qui permet d'evaluer une expression arithmetique représentée
; par une arbre.
; IN : "ar" adresse du noeud tete de l'arbre
; OUT: "expRslt" Le resultat de l'evaluation de l'expression
;-----------------------------------------------------------------------------------
expRslt: .EQUATE 4           ; Resultat #2d
ar:      .EQUATE 2           ; Paramètre #2h
;
evaluer: LDX     ar,s        ; On charge l'adresse du noeud parametre dans X
         LDA     element,x   
         CPA     PLUS,i      ;if (ar.element == PLUS)
         BRNE    eSoustr     
         LDA     gauche,x    
;Calculons evaluer(ar.gauche) + evaluer(ar.droit)
;1er appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
         STA     expRslt,s   
;
         LDX     ar,s        ; On remet la valeur de X
;
         LDA     droit,x     
;2eme appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
;
         ADDA    expRslt,s   
         STA     expRslt,s   ; expRslt = evaluer(ar.gauche) + evaluer(ar.droit)
;
         BR      finEval     ; return expRslt
;
eSoustr: CPA     MOINS,i     ; if (ar.element == MOINS)
         BRNE    eMultipl    
         LDA     gauche,x    
;Calculons evaluer(arbre.gauche) - evaluer(arbre.droit)
;1er appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
         STA     expRslt,s   
;
         LDX     ar,s        ; On remet la valeur de X
;
         LDA     droit,x     
;2eme appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
;
         STA     tmp,d       
         LDA     expRslt,s   
         SUBA    tmp,d       
         STA     expRslt,s   ; expRslt = evaluer(arbre.gauche) - evaluer(arbre.droit)
         BR      finEval     ; return expRslt
;
eMultipl:CPA     ETOILE,i    ; if (ar.element == ETOILE)
         BRNE    eDivis      
         LDA     gauche,x    
; Calculons evaluer(arbre.gauche) * evaluer(arbre.droit);
; 1er appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
         STA     expRslt,s   
;
         LDX     ar,s        ; On remet la valeur de X
;
         LDA     droit,x     
; 2eme appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
; On fait la multiplication a l'aide de la fonction produit avec comme paramètres
; des variables globales p_param1 et p_param2 et resultat de retour p_rslt
         STA     p_param1,d  
;
         LDA     expRslt,s   
         STA     p_param2,d  
;
         CALL    produit     
         LDA     p_rslt,d    
;
         STA     expRslt,s   ; expRslt = evaluer(arbre.gauche) * evaluer(arbre.droit)
         BR      finEval     ; return expRslt
;
eDivis:  CPA     SLASH,i     ; if (ar.element == SLASH)
         BRNE    evalX       
         LDA     gauche,x    
; Calculons evaluer(arbre.gauche) / evaluer(arbre.droit);
; 1er appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         
         CALL    evaluer     
         LDA     2,s         
         ADDSP   4,i         ; Depiler #expRslt #ar
         STA     dividend,d  ; pour faire la division apres
;
         LDX     ar,s        ; On remet la valeur de X
;
         LDA     droit,x     
; 2eme appel recursif
         SUBSP   4,i         ; Empiler #expRslt #ar
         STA     0,s         ; #ar
         CALL    evaluer     
         LDA     2,s         ; #expRslt
         ADDSP   4,i         ; Depiler #expRslt #ar
;
;Cas de  division par zéro
         CPA     0,i         
         BRNE    NonZero     
         STRO    MSG_ZERO,d  ; On affiche un message
         BR      arreter     ; On termine le programme
;
; On fait la division a l'aide de la fonction division avec comme paramètres
; des variables globales dividend et diviseur et resultat de retour quotient
NonZero: STA     diviseur,d  
         CALL    division    ; quotient = division (dividend,diviseur)
         LDA     quotient,d  
;
         STA     expRslt,s   ; expRslt = evaluer(arbre.gauche) / evaluer(arbre.droit)
         BR      finEval     ; return expRslt
;
evalX:   CPA     X,i         
         BRNE    eAutre      
         LDA     x,d         
         STA     expRslt,s   
         BR      finEval     
eAutre:  STA     expRslt,s   
finEval: RET0                
;
;-----------------------------------------------------------------------------------
; infixe
; ======
; Fonction récursive qui permet d'afficher l'expression arithmétique representé par
; une adresse du noeud en paramètre sous une représentation infixe
; IN : "iNoeud" adresse du noeud tete de l'arbre
; OUT: pas de valeur de retour, juste l'affichage
;-----------------------------------------------------------------------------------
iNoeud:  .EQUATE 2           ; Paramètre #2h
;
infixe:  LDX     iNoeud,s    ; On charge l'adresse du noeud en parametre dans X
         LDA     element,x   ;if (iNoeud.element == PLUS) {
         CPA     PLUS,i      
         BRNE    iSoustr     
         CHARO   '(',i       ; print '('
         LDA     gauche,x    
;
; 1er appel recursif : infixe(arbre.gauche)
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         LDX     ar,s        
         CHARO   '+',i       ; print '+'
;
; 2eme appel recursif :infixe(arbre.droit)
         LDA     droit,x     
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         CHARO   ')',i       ;print ')'
;
         BR      finInfx     
iSoustr: CPA     MOINS,i     ; Si (iNoeud.element == MOINS)
         BRNE    iMultipl    
;
         CHARO   '(',i       ;print '('
         LDA     gauche,x    
; 1er appel recursif : infixe(arbre.gauche)
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         LDX     ar,s        
         CHARO   '-',i       ;print '-'
;
; 2eme appel recursif :infixe(arbre.droit)
         LDA     droit,x     
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         CHARO   ')',i       ;print ')'
         BR      finInfx     
;
iMultipl:CPA     ETOILE,i    ; Si (iNoeud.element == ETOILE)
         BRNE    iDivis      
         CHARO   '(',i       ; print '('
         LDA     gauche,x    
; 1er appel recursif : infixe(arbre.gauche)
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         LDX     ar,s        
         CHARO   '*',i       ; print '*'
;
; 2eme appel recursif :infixe(arbre.droit)
         LDA     droit,x     
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         CHARO   ')',i       ; print ')'
         BR      finInfx     
;
iDivis:  CPA     SLASH,i     ;Si (iNoeud.element == SLASH)
         BRNE    iX          
         CHARO   '(',i       ; print '('
         LDA     gauche,x    
; 1er appel recursif : infixe(arbre.gauche)
         SUBSP   2,i         ;empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ;depiler #ar
;
         LDX     ar,s        
         CHARO   '/',i       ; print '/'
;
; 2eme appel recursif :infixe(arbre.droit)
         LDA     droit,x     
         SUBSP   2,i         ; Empiler #ar
         STA     0,s         
         CALL    infixe      
         ADDSP   2,i         ; Depiler #ar
;
         CHARO   ')',i       ; print ')'
         BR      finInfx     
;
iX:      CPA     X,i         ;Si (iNoeud.element == X)
         BRNE    iAutre      
         CHARO   'x',i       ; print 'x'
         BR      finInfx     
;
iAutre:  DECO    element,x   ; Sinon  print element
;
finInfx: RET0                
;-----------------------------------------------------------------------------------
; produit
; =======
; Sous-programme qui réalise le produit de deux nombres.
; IN : "p_param1", "p_param2" les nombres à multiplier (variables globales)
; OUT: "p_rslt", le resultat du produit deux entiers (variable globale)
;-----------------------------------------------------------------------------------
produit: LDA     0,i         
         LDX     p_param2,d  ; x = p_param2
prd_loop:CPX     0,i         
         BREQ    prd_fin     ; si x = 0 then prd_fin
         ADDA    p_param1,d  ; A = A + p_param1
         SUBX    1,i         ; x = x -1
         CPX     0,i         
         BRGT    prd_loop    ; if x > 0 then prd_loop
prd_fin: STA     p_rslt,d    ; p_rslt = A
         RET0                
;-----------------------------------------------------------------------------------------
; division
; ========
; Fonction qui calcule le quotient d'une division entiere
; IN:  "dividend" le divdende (variable globale)
;      "diviseur" le diviseur (variable globale)
; OUT: "quotient" Le quotient de la division entiere(variable globale)
;-----------------------------------------------------------------------------------------
division:LDX     0,i         ; X = 0
         LDA     dividend,d  
div_loop:CPA     diviseur,d  
         BRLT    div_fin     ; while(dividend >= diviseur) {
         SUBA    diviseur,d  ;   A = A - diviseur;
         ADDX    1,i         ;   X = X + 1;
         BR      div_loop    ; } // fin while
div_fin: STX     quotient,d  
         RET0                
;
;-----------------------------------------------------------------------------------------
; Structure qui représente notre arbre
;=====================================
; Un arbre est une structure constituée d'une chaîne de noeud.
; chaque noued contient une valeur et les deux adresses respectives du fils gauche et 
; fils droit
element: .EQUATE 0           ; #2d valeur de l'élément dans le noeud
gauche:  .EQUATE 2           ; #2h fils gauche
droit:   .EQUATE 4           ; #2h fils droit
arTaille:.EQUATE 6           ; taille d'un noeud en octets
;

; Declaration des variables et constantes globales
;=================================================
cmd:     .BYTE   '\n'        ; #1c variable globale pour recevoir la valeur d'une commande.
;                            ; initialisée à \n pour quelle soit ignoré au début.
x:       .BLOCK  2           ; #2d pour stocker la valeur du parametre de la commande x
;
tete:    .BLOCK  2           ; #2h pour stocker l'adresse du premier noeud de l'arbre
;
tmp:     .BLOCK  2           ; #2d variable globale pour echange
cTmp:    .BLOCK  1           ; #1c variable globale pour echange
;
PLUS:    .EQUATE -10         ; Constante pour representer l'opérateur d'addition +
MOINS:   .EQUATE -11         ; Constante pour representer l'opérateur de soustraction -
ETOILE:  .EQUATE -12         ; Constante pour representer l'opérateur de multiplication *
SLASH:   .EQUATE -13         ; Constante pour representer l'opérateur de division /
X:       .EQUATE -14         ; Constante pour representer le caractère x
;
MSG_CMD: .ASCII  "Commande invalide!\x00"             ; message d'erruer
MSG_EXP: .ASCII  "Expression invalide!\x00"           ; message d'erreur
MSG_ZERO:.ASCII  "Division par zéro impossible!\x00"  ; message d'erreur
;
p_param1:.BLOCK  2           ; #2d paramètre du sous-programme produit
p_param2:.BLOCK  2           ; #2d paramètre du sous-programme produit
p_rslt:  .BLOCK  2           ; #2d valeur de retour du sous-programme produit
;
diviseur:.BLOCK  2           ; #2d paramètre du sous-programme division
dividend:.BLOCK  2           ; #2d paramètre du sous-programme division
quotient:.BLOCK  2           ; #2d paramètre du sous-programme division
;-----------------------------------------------------------------------------------------
; Operateur new
; =============
; Precondition: A contains number of bytes
; Postcondition: X contains pointer to bytes
;-----------------------------------------------------------------------------------------
new:     LDX     hpPtr,d     ;returned pointer
         ADDA    hpPtr,d     ;allocate from heap
         STA     hpPtr,d     ;update hpPtr
         RET0                
hpPtr:   .ADDRSS heap        ;address of next free byte
heap:    .BLOCK  1           ;first byte in the heap
         .END                  
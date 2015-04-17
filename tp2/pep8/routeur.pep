;---------------------------------------------------------------------------------------
;                           		LAAROUSSI Mohamed
;                               INF2170-TP2 2EME PARTIE
;                                      25-10-2014
;---------------------------------------------------------------------------------------
; OBJECTIF
; ========
; Implémenter un algorithme de routage en fonction d'une description de la topologie de
; réseau fournie en entrée.
;
; Le programme lit une topologie en entrée. Puis lit une commande numérique(de 0 à 3):
; -> La commande 0 affiche le nombre de routeurs et de liaisons, puis termine
;    le programme.
; -> La commande 1 affiche la matrice d'adjacence du réseau, puis termine le
;    programme.
; -> La commande 2 affiche la matrice des distances du réseau.
; -> La commande 3 affiche le plus court chemin entre deux routeurs.
;
; DÉFINITIONS
; ===========
; Un réseau est constitué de n routeurs et de m liaisons.
; Chaque liaison est bi-directionnelle et relie deux routeurs.
; La description d'une topologie est constituée d'une séquence de nombres
; ayant la forme suivante:
; -> le nombre de routeurs n, compris entre 1 et 16. Par la suite, chaque
;    routeur sera identifié par un numéro de 0 à n-1.
; -> le nombre de liaisons m, positif ou nul.
; -> pour chaque liaison, une paire de numéros de routeur. l'ordre de liaisons
;    et des routeurs dans chaque liaison n'a pas d'importance.
; -> Une liaison redondante ou reliant un routeur à lui-même est ignorée.
;
; IMPLÉMENTATION
; ==============
; On represente une matrice carrée n*n tab[i][j] avec un tableau d'un seul
; dimmension tab[x], avec x = 2*(i*n + j) , on multiplie par 2 car chaque nomrbre
; de la matrice est codé sur 2 octets.
; On a choisi l'algorithme de Floyd-Warshall pour calculer les distances
; entre les routeurs, et floyd-Warshall With Path Reconstruction pour obtenir
; le plus court chemin entre deux routeurs.
;
; CAS LIMITES
; ===========
; Le nombre de routeurs n est compris entre 1 et 16 (indice de 0 à 15).
; Le nombre de liaisons m est positif ou nul.
; Commande numérique entre 0 et 3;
;------------------------------------------------------------------------------------
;lecture du nombre de routeurs n
         DECI    n,d         
;Lecture du nombre de liaisons m
         DECI    m,d         
;
;Lecture d'une paire de numéros de routeur pour chaque liaison, et création
; de la matrice d'adjacence du réseau
         CALL    creerAdj    
;
;Lecture d'une commande numérique (de 0 à 3), et traitement .
main:    DECI    cmd,d       
         LDX     cmd,d       
         CPX     0,i         ; switch(cmd){
         BREQ    cas0        
         CPX     1,i         
         BREQ    cas1        
         CPX     2,i         
         BREQ    cas2        
         CPX     3,i         
         BREQ    cas3        
         BR      terminer    
cas0:    CALL    cmd0        ; case 0: cmd0
         BR      terminer    ; break
cas1:    CALL    cmd1        ; case 1: cmd1
         BR      terminer    ; break
cas2:    CALL    cmd2        ; case 2: cmd2
         BR      terminer    ; break
cas3:    CALL    cmd3        ; case 3: cmd3
         BR      terminer    ; break
terminer:STOP                ; default: terminer }
;-----------------------------------------------------------------------------------
; Sous-programme qui affiche le nombre de routeurs n, et le nombre de liaisons m.
; IN : il n'a pas de parametres.
; OUT: il ne retourne aucune valeur.
;------------------------------------------------------------------------------------
cmd0:    CHARO   'n',i       
         CHARO   '=',i       
         DECO    n,d         
         CHARO   '\n',i      
         CHARO   'm',i       
         CHARO   '=',i       
         DECO    m,d         
         CHARO   '\n',i      
         RET0                
;------------------------------------------------------------------------------------
; Sous-programme qui lit des paires de liaisons et créé la matrice d'adjacence.
; IN : il n'a pas de paramètres.
; OUT: "adj", la matrice d'adjacence du réseau.(variable globale)
;------------------------------------------------------------------------------------
creerAdj:LDA     0,i         
         STA     i,d         ; initialiser i =0
; Pour chaque liaison on lit deux roteurs r1 et r2 .
lboucle: CPA     m,d         ; boucle de lecture  while(i < m)
         BRGE    lfin        
         DECI    r1,d        ; lire r1
         DECI    r2,d        ; lire r2
;
; on calcule la valeur de x on fonction de r1 et r2 soit x = 2*(r1*n + r2)
; ou  x = 2*(r2*n + r1) car l'ordre des routeurs dans chaque liaison n'a pas
; d'importance, et on met adj[x]=1
;
; On calcule 2*(r1*n + r2)
         LDA     r1,d        
         STA     p_param1,d  ;
         LDA     n,d         
         STA     p_param2,d  
         CALL    produit     ; rslt = produit (r1,n)
         LDX     rslt,d      ; x = rslt
         ADDX    r2,d        ; x = x + r2
         ASLX                ; x = 2 * x //ie: x = 2*(r1*n + r2)
         LDA     1,i         
         STA     adj,x       ; adj[x] = 1 //ie: adj[x]=1
;
; de la même façon on calcule 2*(r2*n + r1)
         LDA     n,d         
         STA     p_param1,d  
         LDA     r2,d        
         STA     p_param2,d  
         CALL    produit     ; rslt = produit (r2,n)
         LDX     rslt,d      ; x = rslt
         ADDX    r1,d        ; x = x + r1
         ASLX                ; x = 2 * x //ie: x = 2*(r2*n + r1)
         LDA     1,i         
         STA     adj,x       ; adj[x]= 1
;
; On incremente le compteur i de la boucle.
         LDA     i,d         
         ADDA    1,i         
         STA     i,d         
         BR      lboucle     
lfin:    RET0                
;-----------------------------------------------------------------------------------
; Sous-programme qui réalise le produit de deux paramètres
; IN : "p_param1", "p_param2" les nombres à multiplier (variables globales)
; OUT: "rslt", le resultat du produit deux entiers (variable globale)
;-----------------------------------------------------------------------------------
produit: LDA     0,i         
         LDX     p_param2,d  ; x = p_param2
prd_loop:CPX     0,i         
         BREQ    prd_fin     ; si x = 0 then prd_fin
         ADDA    p_param1,d  ; A = A + p_param1
         SUBX    1,i         ; x = x -1
         CPX     0,i         
         BRGT    prd_loop    ; if x > 0 then prd_loop
prd_fin: STA     rslt,d      ; rslt = A
         RET0                
;----------------------------------------------------------------------------------------
; Sous-programme qui affiche la matrice d'adjacence du réseau sous forme carrée n*n
; chaque nombre est suivi d'un espace, sauf le dernier nombre d'une ligne qui est suivi
; d'un '\n'.
; IN : "adj", la matrice d'adjacence (variable globale)
; OUT: pas de valeur retournée
;----------------------------------------------------------------------------------------
cmd1:    LDA     n,d         ;
         ASLA                ;  A = 2*n
;
; On utilise tmp2 pour stocker la longueur en octet d'une ligne de la matrice
; carrée n*n, soit tmp2=2*n
         STA     tmp2,d      ; tmp2 = 2*n
;
; On initialise i à 2*n - 2, c'est la position du dernier nombre d'une ligne
         SUBA    2,i         
         STA     i,d         ; i = 2*(n - 1)
;
; On calcule la taille de la matrice d'adjacence en octets, soit sizeAdj = 2*n*n
         LDA     n,d         
         STA     p_param1,d  
         STA     p_param2,d  
         CALL    produit     ; produit (n,n)
         LDA     rslt,d      ; A = produit (n,n)
         ASLA                ; A = A * 2
         STA     sizeAdj,d   
; On parcoure la matrice adj et à chaque fois on affiche adj[x] puis si il s'agit du
; dernier nombre d'une ligne (x est multiplicateur de 2*n) on affiche '\n' sinon on
; affiche espace
         LDX     0,i         
c1boucle:CPX     sizeAdj,d   ; c1boucle: boucle pour parcourir la matrice adj
         BRGE    finc1       ; while (x < sizeAdj) then finc1
         DECO    adj,x       ; print adj[x]
         CPX     i,d         ; if ( x == i ){
         BRNE    printsp     ; sinon on branche sur  printsp
         LDA     i,d         
         ADDA    tmp2,d      
         STA     i,d         ; i = i+  2*n
         CHARO   '\n',i      ; println
         BR      x_incr      
printsp: CHARO   ' ',i       ;print ' '
x_incr:  ADDX    2,i         ; On incrimente x de 2
         BR      c1boucle    
finc1:   RET0                
;------------------------------------------------------------------------------------
; Sous-programme qui initialise la matrice dist et la matrice next pour les utiliser
; avec l'algorithmr floyd-Warshall.
; IN : "adj", la matrice d'adjacence (variable globale)
; OUT: "dist","next" les matrices dist et next (variables globales)
; Algorithme:
; pour chaque arête (i, j)
;     si adj[i][j] == 0
;         dist[i][j] = INFINIE
;         next[i][j] = NULL
;     sinon
;         dist[i][j] = adj[i][j]
;         next[i][j] = j
; pour chaque sommet i
;     dist[i][i] = 0
;-------------------------------------------------------------------------------------
initFW:  LDA     0,i         
         STA     i,d         ; initialiser i ,i=0
iloop1:  CPA     n,d         
         BRGE    ifin        ; while ( i < n) {
         LDA     0,i         
         STA     j,d         ; initialiser j ,j=0
iloop2:  CPA     n,d         
         BRGE    iincr       ; while ( j < n) {
; On calcule l'indice x en fonction de i et j sooit x =  = 2*(n * i + j)
         LDA     n,d         
         STA     p_param1,d  ; p_param1 = n
         LDA     i,d         
         STA     p_param2,d  ; p_param2 = i
         CALL    produit     ; rslt = produit(n,i)
         LDX     rslt,d      ; x = rslt
         ADDX    j,d         ; x = x + j
         ASLX                ; x = 2*x  //ie:  x=2*(n * i + j)
; On initialise dist et next:
; Si adj[x] == 0 Alors dist[x] = INFINIE et next[x] = NULL
         LDA     adj,x       
         CPA     0,i         
         BRNE    nonNul      ; si adj[x] == 0
         LDA     INFINIE,i   
         STA     dist,x      ; dist[x] = INFINIE
         LDA     NULL,i      
         STA     next,x      ; next[x] = NULL
         BR      iDiagonl    ; On branche sur l'initialisation du diagonale iDiagonl
; Sinon si si adj[x] != 0 alors dist[x] = adj[x] et next[x] = j
nonNul:  LDA     adj,x       
         STA     dist,x      ;dist[x] = adj[x]
         LDA     j,d         
         STA     next,x      ;next[x] = j
; On initialise le diagonale(i = j) de la matrice dist à 0, dist[x] = 0 avec i=j
iDiagonl:LDA     j,d         
         CPA     i,d         
         BRNE    jincr       ; Si i == j
         LDA     0,i         
         STA     dist,x      ; dist[x] = 0
; On incremente le compteur j de la boucle iloop2
jincr:   LDA     j,d         
         ADDA    1,i         
         STA     j,d         ;j++
         BR      iloop2      ; } //fin while iloop2
; On incremente le compteur i de la boucle iloop1
iincr:   LDA     i,d         
         ADDA    1,i         
         STA     i,d         ; i++
         BR      iloop1      ; } //fin while iloop1
ifin:    RET0                
;---------------------------------------------------------------------------------------
; Sous-programme qui implémente l'algorithme de Floyd-Warshall pour calculer les
; distances entre les routeurs.
; IN : "adj", la matrice d'adjacence (variable globale)
; OUT: "dist","next" les matrices dist et next (variables globales)
;
;Algorithme:
;Initialiser dist et next
;Pour k de 0 à n
;    Pour i de 0 à n
;        Pour j de 0 à n
;            Si (dist[i][k] + dist[k][j] < dist[i][j])
;                dist[i][j] = dist[i][k] + dist[k][j]
;                next[i][j] = next[i][k]
;
;----------------------------------------------------------------------------------------
fldWrshl:CALL    initFW      ;Initialisation des matrices dist et next
         LDA     0,i         
         STA     k,d         ;initialiser k=0
k_boucle:CPA     n,d         ; 1ere boucle avec indice k
         BRGE    finFW       
         LDA     0,i         
         STA     i,d         ;initialiser i=0
i_boucle:CPA     n,d         ; 2eme boucle avec indice i
         BRGE    k_incr      
         LDA     0,i         
         STA     j,d         ;initialiser j=0
j_boucle:CPA     n,d         ; 3eme boucle avec indice k
         BRGE    i_incr      
;
; On calcule l'indice x_ij en fonction de i et j, soit x_ij= 2*(n * i + j)
         LDA     n,d         
         STA     p_param1,d  
         LDA     i,d         
         STA     p_param2,d  
         CALL    produit     
         LDA     rslt,d      
         ADDA    j,d         
         ASLA                
         STA     x_ij,d      ;x_ij = 2*(n * i + j)
;
; On calcule l'indice x_ik en fonction de i et k, soit x_ik = 2*(n * i + k)
         LDA     n,d         
         STA     p_param1,d  
         LDA     i,d         
         STA     p_param2,d  
         CALL    produit     
         LDA     rslt,d      
         ADDA    k,d         
         ASLA                
         STA     x_ik,d      ;x_ik = 2*(n * i + k)
;
; On calcule l'indice x_kj en fonction de j et k, soit x_kj = 2*(n * k + j)
         LDA     n,d         
         STA     p_param1,d  
         LDA     k,d         
         STA     p_param2,d  
         CALL    produit     
         LDA     rslt,d      
         ADDA    j,d         
         ASLA                
         STA     x_kj,d      ;x_kj = 2*(n * k + j)
;
; On calcule dist[x_ij] et dist[x_ik] + dist[x_kj]
         LDX     x_ij,d      
         LDA     dist,x      
         STA     tmp1,d      ; tmp1=  dist[x_ij]
         LDX     x_ik,d      
         LDA     dist,x      
         STA     tmp2,d      ; tmp2=  dist[x_ik]
         LDX     x_kj,d      
         LDA     dist,x      
         ADDA    tmp2,d      ; A = dist[x_ik] + dist[x_kj]
;
;Si dist[x_ik] + dist[x_kj] < dist[x_ij]
;Alors dist[x_ij] = dist[x_ik] + dist[x_kj] et next[x_ij] = next[x_ik]
         CPA     tmp1,d      
         BRGE    j_incr      ;if (dist[x_ik] + dist[x_kj] < dist[x_ij]) {
         LDX     x_ij,d      
         STA     dist,x      ;dist[x_ij] = A;
         LDX     x_ik,d      
         LDA     next,x      ;A = next[x_ik]
         LDX     x_ij,d      
         STA     next,x      ; next[x_ij] = A
; On incremente le compteur j
j_incr:  LDA     j,d         
         ADDA    1,i         
         STA     j,d         
         BR      j_boucle    ; fin j_boucle
; On incremente le compteur i
i_incr:  LDA     i,d         
         ADDA    1,i         
         STA     i,d         
         BR      i_boucle    ; fin i_boucle
; On incremente le compteur k
k_incr:  LDA     k,d         
         ADDA    1,i         
         STA     k,d         
         BR      k_boucle    ; fin k_boucle
finFW:   RET0                
;--------------------------------------------------------------------------------
; Sous-programme qui affiche la matrice de distances du réseau sous forme
; carrée n*n, chaque nombre est suivi d'un espace, sauf le dernier nombre d'une
; ligne qui est suivi d'un '\n', et si le nombre est egal INFINIE, x est affiché
; à la place.
; IN : "dist", la matrice d'adjacence (variable globale)
; OUT: pas de valeur retournée
;---------------------------------------------------------------------------------
cmd2:    CALL    fldWrshl    ; On calcule la matrice de distance
;
; On utilise tmp2 pour stocker la longueur en octet d'une ligne de la matrice
; caree n*n, soit tmp2 = 2*n
         LDA     n,d         
         ASLA                ;  A = 2*n
         STA     tmp2,d      ; tmp2 = 2*n
;
; On initialise i à 2*n - 2, c'est la position du dernier nombre d'une ligne
         SUBA    2,i         
         STA     i,d         ; i = 2*(n - 1)
;
; On calcule la taille de la matrice d'adjacence en octets, soit sizeAdj = 2*n*n
         LDA     n,d         
         STA     p_param1,d  
         STA     p_param2,d  
         CALL    produit     ; produit (n,n)
         LDA     rslt,d      ; A = produit (n,n)
         ASLA                ; A = A * 2
         STA     sizeAdj,d   
         LDX     0,i         
;
; On parcoure la matrice dist et à chaque fois si dist[x] != INFINIE on l'affiche
; sinon on affiche 'x', puis si il s'agit du dernier nombre d'une ligne (si x est
; un multiplicateur de 2*n) on affiche '\n' sinon on affiche un espace ' '.
c2boucle:CPX     sizeAdj,d   ; c2boucle: boucle pour parcourir la matrice dist
         BRGE    finc2       ; while (x < sizeAdj)
         LDA     dist,x      
         CPA     INFINIE,i   ; if (dist[x] == INFINIE ){
         BRNE    noninfi     
         CHARO   'x',i       ; print 'x'
         BR      ifLast      ; }// fin if(dist[x] == INFINIE )
noninfi: DECO    dist,x      ; else {print dist[x] }
ifLast:  CPX     i,d         ; if ( x == 2*n ){//
         BRNE    printEsp    
         LDA     i,d         
         ADDA    tmp2,d      ; A += 2*n
         STA     i,d         ; i = A
         CHARO   '\n',i      ; print '\n'
         BR      xc2_incr    ;} else {
printEsp:CHARO   ' ',i       ; print ' ' }
xc2_incr:ADDX    2,i         ; x = x+2
         BR      c2boucle    ;} //fin while
finc2:   RET0                
;--------------------------------------------------------------------------------------
; Sous-programme qui implémente l'algorithme de Floyd?Warshall avec Path reconstruction
; pour calculer le chemin le plus court entre deux routeurs r1 et r2.
; IN : "r1","r2" routeur numero r1 routeur numero r2 (variable globale)
; OUT: "path" tableau qui contient les neuds du chemin le plus court entre r1 et r2.
;      "sizePth" taille du tableau path
; Algorithme:
; si next[r1][r2] = NULL
;       retourner [0]
;   path = [r1]
;   Tant que r1 != r2
;      r1 = next[r1][r2]
;      path.ajouter(r1)
;   retourner path
;---------------------------------------------------------------------------------------
chemin:  CALL    fldWrshl    ; On calcule la matrice next
;
; On calcule l'indice x en fonction de r1 et r2 soit x = 2*(n * r1  + r2)
         LDA     n,d         
         STA     p_param1,d  
         LDA     r1,d        
         STA     p_param2,d  
         CALL    produit     ; rslt = produit(n,r1)
         LDX     rslt,d      ; x = rslt
         ADDX    r2,d        ; x = x + j
         ASLX                ; x = 2*x //ie x = 2*(n *  r1  + r2)
;
; Si next[x] == NULL Alors path = [0]
         LDA     next,x      
         CPA     NULL,i      
         BRNE    initpath    
         LDX     0,i         
         STX     path,x      ;path = [0]
;
; On recuperer la taille du tableau path
         LDA     2,i         
         STA     sizePth,d   
         BR      chmFin      
;
; On initialise le tableau path = {r1} ;
initpath:LDA     r1,d        
         LDX     0,i         
         STA     path,x      
         LDX     2,i         
         STX     sizePth,d   ; taille tableau
chboucle:CPA     r2,d        
         BREQ    chmFin      
;
; On calcule l'indice x en fonction de r1 et r2 soit x = 2*(n * r1  + r2)
         LDA     n,d         
         STA     p_param1,d  
         LDA     r1,d        
         STA     p_param2,d  
         CALL    produit     ; rslt = produit(n,r1)
         LDX     rslt,d      ; x = rslt
         ADDX    r2,d        ; x = x + j
         ASLX                ; x = 2*x //ie x = 2*(n *  r1  + r2)
         LDA     next,x      
         STA     r1,d        ;r1 = next[x];
         LDX     sizePth,d   ;x = sizePth
         LDA     r1,d        
         STA     path,x      ;path[sizePth]=r1
;
;incrementer sizePth
         LDA     sizePth,d   
         ADDA    2,i         
         STA     sizePth,d   
         LDA     r1,d        
         BR      chboucle    
chmFin:  RET0                
;---------------------------------------------------------------------------------------
; Sous-programme qui affiche le chemin le plus court entre deux routeurs en paramètres.
; IN : "r1","r2" routeur numero r1, routeur numero r2,
;      "path"  tableau contenant les neuds du chemin le plus court entre r1 et r2
; OUT: il ne reourne pas de valeur
;----------------------------------------------------------------------------------------
printPth:LDA     r1,d        
         CPA     r2,d        
;Si r1 == r2 On affiche r1 et on quitte le sous programme
         BRNE    diff        ; if( r1 == r2) {
         DECO    r1,d        ;
         BR      println     
;
;Sinon ( r1 != r2)
diff:    CALL    chemin      ; On calcule le tableau path
         LDX     0,i         
         LDA     sizePth,d   
         SUBA    2,i         
         STA     sizePth,d   ; sizePth - 2
;
;Si sizePth - 2 <= 0 Alors il n'y a pas de chemins entre r1 et r2,On affiche r1-x->r2
         CPA     0,i         ; if (sizePth - 2 <= 0){
         BRGT    pboucle     
         DECO    r1,d        ; print r1
         CHARO   '-',i       ; print '-'
         CHARO   'X',i       ; print 'X'
         CHARO   '-',i       ; print '-'
         CHARO   '>',i       ;  print '>'
         DECO    r2,d        ; print r2
         BR      println     ; }//fin if
;
;Sinon (sizePth - 2 > 0), Alors on affiche les routeurs itermédiaires avec des fleches.
pboucle: CPX     sizePth,d   ; while (x < sizePth - 2){
         BRGE    pfin        
         DECO    path,x      ; print path[x]
         CHARO   '-',i       ; print '-'
         CHARO   '>',i       ; print '>'
         ADDX    2,i         ; x += 2
         BR      pboucle     ; }//fin while
pfin:    DECO    path,x      ; print path[x]
println: CHARO   '\n',i      ; print '\n'
         RET0                
;----------------------------------------------------------------------------------------
; Sous-programme qui lit des paires de routeurs, et pour chacune de ces paires r1, r2
; affiche le chemin à parcourir partant de r1 et arrivant à r2.
; Le sous-programme se termine lorsque -1 est entré.
; IN : "path"  tableau contenant les neuds du chemin le plus court entre r1 et r2
; OUT: il ne reourne pas de valeur
;----------------------------------------------------------------------------------------
cmd3:    LDA     0,i         
c3boucle:CPA     -1,i        ; while (r1 != -1) {
         BREQ    c3fin       
         DECI    r1,d        ; lire r1
         LDA     r1,d        
         CPA     -1,i        ; if( r1 != -1 ){
         BREQ    c3fin       
         DECI    r2,d        ;    lire r2 } // fin if
         CALL    printPth    ;    printPth() // afficher chemin
         BR      c3boucle    ; }//fin while
c3fin:   RET0                
;-----------------------------------------------------------------------------------------
n:       .BLOCK  2           ;#2d le nombre de routeurs
m:       .BLOCK  2           ;#2d le nombre de liaisons
cmd:     .BLOCK  2           ; pour lire la commande numérique
;
r1:      .BLOCK  2           ;#2d pour lire le routeur no 1
r2:      .BLOCK  2           ;#2d pour lire le routeur no 2
;
tmp:     .BLOCK  2           ;#2d variable temporaire pour échange
tmp1:    .BLOCK  2           ;#2d variable temporaire pour échange
tmp2:    .BLOCK  2           ;#2d variable temporaire pour échange
;
adj:     .BLOCK  512         ; matrice d'adjacence du réseau de 256 entiers
dist:    .BLOCK  512         ; matrice des distances du réseau de 256 entiers
next:    .BLOCK  512         ; matrice next dans l'algorithme floyd-Warshall With Path
                             ; Reconstruction de 256 entiers
path:    .BLOCK  512         ; tableau du chemin le plus court de 256 entiers
;
sizeAdj: .BLOCK  2           ;#2d taille de la d'adjacence en octet
sizePth: .BLOCK  2           ;#2d taille du tableau path en octet
;
i:       .BLOCK  2           ;#2d itérateur utilisé dans des boucles
j:       .BLOCK  2           ;#2d itérateur utilisé dans des boucles
k:       .BLOCK  2           ;#2d itérateur utilisé dans des boucles
;
p_param1:.BLOCK  2           ;#2d paramètre du sous-programme produit
p_param2:.BLOCK  2           ;#2d paramètre du sous-programme produit
rslt:    .BLOCK  2           ;#2d valeur de retour du sous-programme produit
;
x_ij:    .BLOCK  2           ;#2d pour stocker l'indice x de dist[i][j] et de next[i][j]
x_ik:    .BLOCK  2           ;#2d pour stocker l'indice x de dist[i][k] et de next[i][k]
x_kj:    .BLOCK  2           ;#2d pour stocker l'indice x de dist[k][j] et de next[k][j]
;
NULL:    .EQUATE -1          ; Constante pour representer une valeur nul (NULL VALUE)
INFINIE: .EQUATE 1000        ; Constante pour representer l'infini !
         .END                  
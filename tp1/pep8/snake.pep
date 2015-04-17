;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 		     LAAROUSSI Mohamed
; 		     INF2170-TP1 2EME PARTIE
; 		     3-10-2014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ce programme réalise un convertisseur CamelCase vers snake_case.
;
; CamelCase est une convention typographique qui consiste à mettre en majuscule
; les premières lettres de chaque mot, quant au snake_case il consiste à écrire
; des mots en minuscules en les séparant par des soulignés.
;
; Le programme prend en entrée une ligne de texte (une séquence de caractères
; terminée par un retour chariot '\n'). Il affiche en sortie une version
; snake_case de cette ligne de texte.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;On mémorise la valeur précédente et avant précédente du caractère saisie(cc)
boucle:  LDBYTEA cp,d        ;do {
         STBYTEA cap,d       ;    cap = cp;
         LDBYTEA tmp,d       
         STBYTEA cp,d        ;    cp = tmp;

;Et on saisie d'une nouvelle valeur de cc.
         CHARI   cc,d        ;    cc = chari();
         LDBYTEA cap,d       
         CPA     0,i         
         BREQ    mem         ;    if(cap != 0) { //si caractère non nule
         
         CPA     'A',i       
         BRLT    cap_Nmaj    
         CPA     'Z',i       
         BRGT    cap_Nmaj    ;        if(cap>='A' && cap<='Z') {
         
         LDBYTEA cp,d        
         CPA     'A',i       
         BRLT    cp_Nmaj1    
         CPA     'Z',i       
         BRGT    cp_Nmaj1    ;            if(cp>='A' && cp<='Z') {
         
         LDBYTEA cc,d        
         CPA     'a',i       
         BRLT    cc_Nmin     
         CPA     'z',i       
         BRGT    cc_Nmin     ;                if(cc>='a' && cc<='z') {
         
         LDBYTEA cap,d       
         ADDA    'a',i       
         SUBA    'A',i       ;                    //transformer en minuscule
         STBYTEA cap,d       ;                    cap = (char) (cap + 'a' - 'A');
         CHARO   cap,d       ;                    print(cap);
         CHARO   '_',i       ;                    print("_");
         BR      mem         ;                } else {
                             ;                    cap = (char) (cap + 'a' - 'A');
cc_Nmin: NOP0                ;                }

cp_Nmaj1:LDBYTEA cap,d       ;            } else {
         ADDA    'a',i       
         SUBA    'A',i       
         STBYTEA cap,d       ;                cap = (char) (cap + 'a' - 'A');
         CHARO   cap,d       ;                print(cap);
         BR      mem         ;            }

cap_Nmaj:LDBYTEA cap,d       
         CPA     'a',i       ;
         BRLT    cap_Nmin    
         CPA     'z',i       
         BRGT    cap_Nmin    ;        } else if (cap >= 'a' && cap <= 'z') {
         LDBYTEA cp,d        
         CPA     'A',i       
         BRLT    cp_Nmaj2    ;
         CPA     'Z',i       
         BRGT    cp_Nmaj2    ;            if(cp>='A' && cp<='Z') {
         CHARO   cap,d       ;                print(cap);
         CHARO   '_',i       ;                print("_");
         BR      mem         
                             ;            } else {
cp_Nmaj2:CHARO   cap,d       ;                print(cap);
         BR      mem         ;            }
                             ;        } else {
cap_Nmin:CHARO   cap,d       ;                print(cap); }

;Mémorisation de la valeur du caractère saisie(cc)
mem:     LDBYTEA cc,d        
         STBYTEA tmp,d       ;        tmp = cc;
                             ;    }//fin if cc != 0
         CPA     '\n',i      
         BRNE    boucle      ;    if (cc == '\n') {
         
         LDBYTEA cp,d        
         CPA     'A',i       
         BRLT    cp_Nmaj3    
         CPA     'Z',i       
         BRGT    cp_Nmaj3    ;        if(cp>='A' && cp<='Z') {
         
         ADDA    'a',i       
         SUBA    'A',i       ;            //transformer en minuscule
         STBYTEA cp,d        ;            cp = (char) (cp + 'a' - 'A');

cp_Nmaj3:CHARO   cp,d        ;            print(cp);
         CHARO   cc,d        ;            print(cc); }
                             ;    }} while( c! = '\n' )
         STOP                

cc:      .BLOCK  1           ; #1c pour mémoriser la valeur courante du caractère Saisi
cp:      .BLOCK  1           ; #1c pour mémoriser la valeur précédente du caractère Saisi
cap:     .BLOCK  1           ; #1c pour mémoriser la valeur avant précédente du caractère Saisi
tmp:     .BLOCK  1           ; #1c valeur temporaire aidant à la mémorisation
         .END                  
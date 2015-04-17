/******************************************************************************
 * 		LAAROUSSI Mohamed 
 * 		INF2170-TP2 1ERE PARTIE 
 * 		13-10-2014
 ******************************************************************************/

/**
 * OBJECTIF
 * ========
 * Implémenter un algorithme de routage en fonction d'une description de la
 * topologie de réseau fournie en entrée.
 * 
 * Le programme lit une topologie en entrée. Puis lit une commande numérique 
 * (de 0 à 3):
 * -> La commande 0 affiche le nombre de routeurs et de liaisons, puis termine
 *    le programme.
 * -> La commande 1 affiche la matrice d'adjacence du réseau, puis termine le
 *    programme.
 * -> La commande 2 affiche la matrice des distances du réseau.
 * -> La commande 3 affiche le plus court chemin entre deux routeurs.
 * 
 * DÉFINITIONS
 * ===========
 * Un réseau est constitué de n routeurs et de m liaisons. 
 * Chaque liaison est bi-directionnelle et relie deux routeurs.
 * La description d'une topologie est constituée d'une séquence de nombres 
 * ayant la forme suivante:
 * -> le nombre de routeurs n, compris entre 1 et 16. Par la suite, chaque
 * 	  routeur sera identifié par un numéro de 0 à n-1.
 * -> le nombre de liaisons m, positif ou nul.
 * -> pour chaque liaison, une paire de numéros de routeur. l'ordre de liaisons
 *    et des routeurs dans chaque liaison n'a pas d'importance.
 * -> Une liaison redondante ou reliant un routeur à lui-même est ignorée.
 * 
 * IMPLIMENTATION
 * ==============
 * On a choisi l'algorithme de Floyd-Warshall pour calculer les distances 
 * entre les routeurs, et floyd-Warshall With Path Reconstruction pour obtenir
 * le plus court chemin entre deux routeurs.
 * 
 * CAS LIMITES
 * ===========
 * Le nombre de routeurs n est compris entre 1 et 16 (indice de 0 à 15).
 * Le nombre de liaisons m est positif ou nul.
 * Commande numérique entre 0 et 3;
 * 
 * @author Mohamed LAAROUSSI
 * @version 13-10-2014
 */

public class Routeur {
	
	//constantes
	static final int PLUS_L_INFINIE = 1000;
	static final int NULL = -1;
	
	public static void main(String[] args) {
		
		/**
		 * Lecture
		 */
		int n = Pep8.deci();
		int m = Pep8.deci();
		
		int [][] liaisons = new int [m][2];

		for(int i = 0; i < m; i++) {
			liaisons[i][0] = Pep8.deci();	
			liaisons[i][1] = Pep8.deci();
		}
		
		int commande = Pep8.deci();
				
		/**
		 * Traitement
		 */
		switch (commande) {
		case 0:
			comptage(n,m);
			break;
		case 1:
			adjacence(n,liaisons);
			break;
		case 2:
			distance(n,liaisons);
			break;
		case 3:
			routage(n,liaisons); 
			break;
		default:
			break;
		}		
	}
	
	/**
	 *  Methode qui permet d'afficher le nombre de routeurs et de liaisons.
	 * @param n Nombre de routeurs
	 * @param m Le nombre de liaisons, positif ou nul
	 */
	public static void comptage(int n,int m) {
		
		Pep8.charo('n');
		Pep8.charo('=');
		Pep8.deco(n);
		Pep8.charo('\n');

		Pep8.charo('m');
		Pep8.charo('=');
		Pep8.deco(m);
		Pep8.charo('\n');
	}
	
	/**
	 *  Methode qui permet d'afficher la matrice d'adjacence du réseau.
	 * @param n Nombre de routeurs
	 * @param liaisons Table de liaisons
	 */
	public static void adjacence(int n,int [][] liaisons) {		
		afficherMatrice(obtenirMatriceAdjacence(n,liaisons));		
	}
	
	/**
	 * Methode qui permet d'afficher la matrice des distances du réseau.
	 * @param n Nombre de routeurs
	 * @param liaisons Table de liaisons
	 */
	public static void distance (int n,int [][] liaisons) {				
		afficherMatrice(floydwarshall(obtenirMatriceAdjacence(n,liaisons)));		
	}

	/**
	 * Methode qui permet d'afficher le plus court chemin entre deux routeurs
	 * @param n Nombre de routeurs
	 * @param liaisons Table de liaisons
	 */
	public static void routage (int n,int [][] liaisons) {		
		
		int entree1 = 0 ;
		int entree2 = 0 ;
						 
		int [][] next = floydWarshallWPR(obtenirMatriceAdjacence(n,liaisons));				
		
		//lecture des paires de routeurs et affichage de des chemins
		while(entree1 != -1 ) {			
			entree1 = Pep8.deci();
			if(entree1 != -1) {	
				entree2 = Pep8.deci();				
				 int [] chemin= path(entree1,entree2, next) ;
				 afficherPath(entree1,entree2,chemin) ;
			}
		 }
	}
	
	/**
	 * Methode qui permet d'afficher une matrice dans un format plus lisible.
	 * @param adjacence une matrice 
	 */
	public static void afficherMatrice(int [][] matrice) {

		for(int i = 0; i < matrice.length; i++) {			
			for(int j = 0; j < matrice.length; j++) {
				if(matrice[i][j] == PLUS_L_INFINIE){
					Pep8.charo('x');
				} else {
					Pep8.deco(matrice[i][j]);
				}
				
				if(j !=  matrice.length - 1 ){
					Pep8.charo(' ');
				}
			}			
			Pep8.charo('\n');			
		}				
	}
		
	/**
	 * Methode qui permet de formater le chemin entre deux routers
	 * @param u routeur numero u
	 * @param v routeur numero v
	 * @param path tableau de chemin 
	 */
	public static void afficherPath(int u,int v,int [] path) {
		
		if(path.length > 1) {//s'il a un chemin
			
			for(int i=0 ; i < path.length -1; i++) {
				Pep8.deco(path[i]);
				Pep8.charo('-');
				Pep8.charo('>');
			}
			Pep8.deco(path[path.length-1]);
			Pep8.charo('\n');
			
		} else if(path.length == 1) {
			
			Pep8.deco(path[0]);
			Pep8.charo('\n');
			
		} else if(path.length == 0) { // il n a pas de chemins
			
			Pep8.deco(u);
			Pep8.charo('-');
			Pep8.charo('X');
			Pep8.charo('-');
			Pep8.charo('>');
			Pep8.deco(v);
			Pep8.charo('\n');
			
		}		
	}
	
	/**
	 * Methode qui permet de calculer la matrice d'adjacence du réseau.
	 * @param n Nombre de routeurs
	 * @param liaisons Table de liaisons
	 * @return La matrice d'adjacence du réseau
	 */
	public static int [][] obtenirMatriceAdjacence(int n, int [][] liaisons){
		
		int [][] rslt = new int[n][n];
		
		for(int i = 0; i < n; i++) {
			for(int j = 0; j < n; j++) {
				if( existLiaison(i,j,liaisons) ){
					rslt [i][j] = 1;
				} else {
					rslt [i][j] = 0;
				}
			}
		}
		return rslt;	
	}
	
	/**
	 * Méthode qui vérifie s'il ya une liaison entre 2 routeurs u et v 
	 * @param u routeur numero u
	 * @param v routeur numero v
	 * @param liaisons table de liaisons
	 * @return
	 */
	public static boolean existLiaison(int u,int v,int [][] liaisons){
		
		for(int i = 0; i < liaisons.length; i++) {
			
			if((u==liaisons[i][0] && v==liaisons[i][1]) 
					|| (v==liaisons[i][0] && u==liaisons[i][1])){
	
				return true;
			} 			
		}
		return false;
	}
		
	/**
	 * Methode qui implémente l'algorithme de Floyd-Warshall pour calculer les 
	 * distances entre les routeurs.
	 * @param adj La matrice d'adjacence du réseau
	 * @return La matrice des distances du réseau
	 */
	public static  int [][] floydwarshall(int [][] adj) {
		
		int [][] dist = new int [adj.length][adj.length];

		//initialisation de la matrice
		for(int i=0;i<adj.length;i++) {
			for(int j=0;j<adj.length;j++) {

				if(adj[i][j] == 0) {
					dist[i][j] = PLUS_L_INFINIE;
				} else {
					dist[i][j] = adj[i][j];
				}
				dist[i][i] = 0;
            }
        }
		
	    for(int k=0;k<dist.length;k++) {
	    	for(int i=0;i<dist.length;i++) {
	    		for(int j=0;j<dist.length;j++) {
	    			
	    			if (dist[i][j] > dist[i][k] + dist[k][j]) {
	    				dist[i][j] = dist[i][k] + dist[k][j];	        		 
	    			}
	    		}
	    	}
	    }
	    return dist;
	}
	
	/**
	 * floyd-Warshall With Path Reconstruction pour calculer le chemin 
	 * entre deux routeurs
	 * @param adj
	 * @return
	 */
	public static  int [][] floydWarshallWPR(int [][] adj) {
		int [][] dist = new int [adj.length][adj.length];
		int [][] next = new int [adj.length][adj.length];
				
		//initialisation des matrices
		for(int i=0;i<adj.length;i++) {
			for(int j=0;j<adj.length;j++) {

				if(adj[i][j] == 0) {
					dist[i][j] = PLUS_L_INFINIE;
					next[i][j] = NULL;
				} else {
					dist[i][j] = adj[i][j];
					next[i][j] = j;
				}
            }
        }
		
	    for(int k=0;k<dist.length;k++) {
	    	for(int i=0;i<dist.length;i++) {
	    		for(int j=0;j<dist.length;j++) {
	        	 
	    			if (dist[i][k] + dist[k][j] < dist[i][j]) {	    				
	    				dist[i][j] = dist[i][k] + dist[k][j];
	    				next[i][j] = next[i][k];	        		 
	    			}
	    		}
	    	}
	    }

	    return next;
	}
	
	/**
	 * méthode qui calcule le chemin le plus court entre deux routeurs 
	 * @param u routeur numero u
	 * @param v routeur numero v
	 * @param next matrice next dans l'algorithme floyd-Warshall With 
	 * 				Path Reconstruction 
	 * @return tableau du chemin le plus court entre les deux routeurs
	 */
	public static  int [] path(int u, int v, int [][] next) {		
	    
	    if (next[u][v] == NULL) {
	    	return new int [0];
	    }
		int [] path = {u} ;
	    
	    while (u != v) {
	    	u = next[u][v];
	    	path = append(u, path);
	    }
	    
	    return path;
	}
	
	/**
	 * Méthode qui permet d'augmenter la taille d'un tableau 
	 * et en ajouter une valeur à la fin  
	 * @param u valeur à ajouter
	 * @param tab tableau à modifier
	 * @return tableau augmenté
	 */	
	public static int [] append(int u, int [] tab){
		
		int [] rslt = new int[tab.length + 1] ;
		
		for(int i=0; i < tab.length; i++){
			rslt[i] =tab[i]; 	
		}		
		rslt[tab.length] = u;
		
		return rslt;
	}

}

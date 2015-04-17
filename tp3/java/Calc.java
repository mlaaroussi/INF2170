/**
 * OBJECTIF
 * ========
 * L'objectif de ce programme est de réaliser un évaluateur d'expressions
 * arithmétiques en notation préfixe.
 * 
 * Le programme lit une expression arithmétique en notation préfixe composée de
 * nombres, des quatre opérateurs binaires +, -, *, et /  et d'une variable x, 
 * puis attend une séquence de commandes:
 * -> La commande d'arrêt '.' 
 * 	  affiche un point (.), un saut de ligne (\n) et quitte le programme.
 * -> La commande de calcul '='
 * 	  affiche le résultat du calcul de l'expression arithmétique, suivi d'un
 * 	  saut de ligne.
 * -> La commande d'écriture infixe '>'
 *    affiche l'expression arithmétique sous une représentation infixe.
 * -> La commande x
 * 	  affecte une valeur à x qui sera utilisée lors des prochaines évaluations.
 *
 * IMPLÉMENTATION
 * ==============
 * On a choisi de représenter l'expression arithmétique avec une structure
 * arborescente (arbre) dans lequel un élément est soit une opération soit un
 * nombre, et où une opération à deux éléments fils : un pour chacune de ses 
 * deux opérandes.
 * l'element de notre arbre est de type int, j'ai choisi des entiers négatifs 
 * pour représenter et stocker les opérateurs et x dans l'arbre, et de les
 * décoder à la phase de calcul et d'affichage infixe.
 *
 * @author LAAROUSSI Mohamed
 * @version 09-11-2014
 */

public class Calc {

	/**
	 * Classe qui represente notre arbre.	 
	 */
	public class Arbre {
		
		public int element;
		
		public Arbre gauche;
		
		public Arbre droit;

	}

	/**
	 * Constantes pour encoder les opérateurs arithmétiques, j'ai choisi de
	 * représenter les opérateurs avec des nombres négatifs au hasard. pour les
	 * stocker dans notre arbre. 
	 */
	static final int ADDITION = -10;
	static final int SOUSTRACTION = -11;
	static final int MULTIPLICATION = -12;
	static final int DIVISION = -13;
	
	/**
	 * Constante pour encoder le caractère x.
	 */
	static final int X = -14 ;	
	
	/**
	 * Constante pour represnter la commande d'arrêt .
	 */
	static final char CMD_ARRET = '.';

	/**
	 * Constantes pour representer les actions utilisées dans les methodes 
	 * lireEtEvaluerEtape1 et lireEtEvaluerEtape2, elles sont choisit au hazard
	 * aussi.
	 */
	static final char EST_UN_CHIFFRE = 'C';
	static final char LIRE = 'L';
	
	/**
	 * variable globale pour recevoir la valeur de l'inconnue x.
	 */
	static int x = 0;
	
	/**
	 * variable globale pour recevoir la valeur d'une commande. 
	 * initialisé a \n pour quelle soit ignoré au début.
	 */
	static char commande = '\n';
	
	
	

	public static void main(String[] args) {

		/**
		 * lecture et construction de l'arbre.
		 */
		
		System.out.println("leval:"+lireEval(LIRE, 0, 0));
		
		//Arbre arbre = lire();

		/**
		 * lecture d'une séquence de commandes.
		 */
		
		while (commande != CMD_ARRET) {
			
			commande = Pep8.chari();
			
			switch (commande) {
			
			case CMD_ARRET: //Commande d'arrêt
				Pep8.charo('.');
				Pep8.charo('\n');
				break;
			
			case '=': //Commande de calcul =				
				//Pep8.deco(evaluer(arbre));
				Pep8.charo('\n');
				break;
			
			case '>': //Commande d'écriture infixe >
				//afficherInfixe(arbre);
				Pep8.charo('\n');
				break;	
			
			case 'x': //La commande x permet d'affecter une valeur à x
				x = Pep8.deci();				
				break;
			
			//Les espaces et sauts de lignes sont ignorés.	
			case '\n': 			
			case '\r':			
			case ' ':	
				break;
						
			default: //En cas de commande invalide.
				Pep8.stro("Commande invalide!");
				commande = CMD_ARRET;
				break;
			}
		}

	}

	/**	
	 * Methode récursive de l'étape 1 qui lie et evalue une
	 * expression arithmetique constitué de nombres compris entre 0 et 9 et
	 * seulement avec les opérations d'additions et de soustractions
	 * 
	 * @param action l'action a faire
	 * @param gauche Opérande de gauche
	 * @param droit Opérande de droite
	 * @return resultat de l'expression
	 */
	public static int lireEtEvaluerEtape1(char action, int gauche, int droit) {

		char caracLu;

		if (action == EST_UN_CHIFFRE) {
			return gauche;
		} else if (action == LIRE) {
			caracLu = Pep8.chari();
		} else {
			caracLu = action;
			if (caracLu == '+') {
				return gauche + droit;
			}
			if (caracLu == '-') {
				return gauche - droit;
			}
		}

		if (estOperateur(caracLu)) {
			return lireEtEvaluerEtape1(caracLu, lireEtEvaluerEtape1(LIRE, 0, 0), lireEtEvaluerEtape1(LIRE, 0, 0));

		} else if (estEspacesOuSautDeligne(caracLu)) {
			return lireEtEvaluerEtape1(LIRE, 0, 0);

		} else {
			return lireEtEvaluerEtape1(EST_UN_CHIFFRE, valeurEntiere(caracLu), 0);
		}

	}

	/**
	 * Étape 2: Amélioration de la lecture et des opérations par rapport à la
	 * méthode etape1: 
	 * -> traitement des nombres plus grand que 9 
	 * -> ajout des opérateurs * et / 
	 * -> la gestion complète et robuste des espaces et sauts
	 * de lignes.
	 * 
	 * @param action l'action a faire
	 * @param gauche Opérande de gauche
	 * @param droit Opérande de droite
	 * @return resultat de l'expression
	 */
	public static int lireEtEvaluerEtape2(char action, int gauche, int droit) {

		char caracLu;

		if (action == EST_UN_CHIFFRE) {

			do {
				caracLu = Pep8.chari();
				if (!estEspacesOuSautDeligne(caracLu)) {
					gauche = gauche * 10 + valeurEntiere(caracLu);
				}
			} while (!estEspacesOuSautDeligne(caracLu));

			return gauche;

		} else if (action == LIRE) {
			do {
				caracLu = Pep8.chari();

			} while (estEspacesOuSautDeligne(caracLu));

		} else {
			caracLu = action;
			if (caracLu == '+') {
				return gauche + droit;
			}
			if (caracLu == '-') {
				return gauche - droit;
			}
			if (caracLu == '*') {
				return gauche * droit;
			}
			if (caracLu == '/') {
				return gauche / droit;
			}
		}

		if (estOperateur(caracLu)) {
			return lireEtEvaluerEtape2(caracLu, lireEtEvaluerEtape2(LIRE, 0, 0), lireEtEvaluerEtape2(LIRE, 0, 0));

		} else {
			return lireEtEvaluerEtape2(EST_UN_CHIFFRE, valeurEntiere(caracLu), 0);
		}

	}

	/**
	 * Étape 3: Construction d'un arbre. On sépare la lecture et le calcul en
	 * deux fonctionnalités distinctes, On crée donc deux methodes : lire() et
	 * evaluer()
	 */

	/**
	 * Methode récursive qui lit une expression arithmetique et qui construit
	 * une arbre.
	 * 
	 * @return arbre l'arbre consruite.
	 */
	public static Arbre lire() {

		Calc calc = new Calc();
		
		char caracLu = Pep8.chari();
		
		int suivant = termeSuivant(caracLu);

		if (estOperateurEncode(suivant)) {

			Arbre arbre = calc.new Arbre();
			arbre.element = suivant;
			arbre.gauche = lire();
			arbre.droit = lire();

			return arbre;

		} else {
			Arbre arbre = calc.new Arbre();
			arbre.element = suivant;

			return arbre;
		}

	}
	static int  exp [] ={MULTIPLICATION,SOUSTRACTION,30,28,DIVISION,7,3};
	//* - 30 28 / 7 3
	static int  indice =0;
	public static int lireEval(int action,int gauche,int droit) {
		
		
		//int suivant = exp [indice];
	
		int suivant = termeSuivant( Pep8.chari());
		//System.out.println("indice: "+indice);
		
		if (action == -99) {
			//System.out.print(gauche);
			return gauche;
			
		} else if (action == -98) {
			//indice ++;
			//suivant = exp [indice];
			suivant = termeSuivant( Pep8.chari());
		} else {
			
			if (action == ADDITION) {
				System.out.print(gauche+"+"+ droit);
				return gauche + droit;
			}
			if (action == SOUSTRACTION) {
				System.out.print(gauche+"-"+ droit);
				return gauche - droit;
			}
			if (action == MULTIPLICATION) {
				System.out.print(gauche+"*"+ droit);
				return gauche * droit;
			}
			if (action == DIVISION) {
				System.out.print(gauche+"/"+ droit);
				return gauche / droit;
			}
		}
		
		//System.out.println("suivant2: "+suivant);

		if (estOperateurEncode(suivant)) {

			System.out.print("(");
			int r= lireEval(suivant, lireEval(-98, 0, 0), lireEval(-98, 0, 0));
			System.out.print(")");
			return r;
		
		} else {
			
			 
			return lireEval(-99,suivant, 0);
		}

	}
	
	/**
	 * Methode recursive qui permet d'obtenir un terme (opérateur ou opérande)
	 * d'une expression en fonction du caractère passé en paramètre. 	 
	 * 
	 * @param caracLu
	 * @return le terme (opérateur ou opérande) d'une expression sous forme
	 * d'entier:
	 *	* Si le parametre est opérateur on retourne l'entier négatif qui le
	 *	  represente (voir les constantes declarees en haut ADDITION ...). 
	 * 	* Si le parametre est egale a 'x' on retourne l'entier négatif qui
	 * 	  le represente (-14 ,representé avec la constante X  ).
	 *  * Si le parametre est egale à un caractère numérique on lie le suivant
	 *    jusqu'à la rencontre d'un espace ou saut de ligne et retourne le nombre
	 *    contenant ces caractères numérique.
	 *  * Sinon si le parametre est un caractère non autorisé on affiche un 
	 *    message et on arrete le programme.
	 *  
	 */
	public static int termeSuivant(char caracLu) {

		int rslt;

		if (estChiffre(caracLu)) {
			rslt = valeurEntiere(caracLu);
			while (estChiffre(caracLu)) {
				caracLu = Pep8.chari();
				if (estChiffre(caracLu)) {
					rslt = rslt * 10 + valeurEntiere(caracLu);
				}
			}

		} else if (estOperateur(caracLu)) {
			rslt = coderOperateur(caracLu);

		} else if (caracLu == 'x') {
			rslt = X;

		} else if(estEspacesOuSautDeligne(caracLu)) {

			while (estEspacesOuSautDeligne(caracLu)) {
				caracLu = Pep8.chari();
			}

			rslt = termeSuivant(caracLu);

		} else {//cas caractère invalide.				
			rslt = 0;
			Pep8.stro("Expression invalide!");
			commande = CMD_ARRET; //pour arreter le programme.			
		}
		
		return rslt;
	}

	/**
	 * Methode récursive qui permet d'evalue une expression arithmetique à 
	 * partir d'une arbre passée en paramètre.
	 * 
	 * @param arbre
	 * @return Le resultat de l'expression
	 */
	public static int evaluer(Arbre arbre) {
		
		if (arbre.element == ADDITION) {
			return evaluer(arbre.gauche) + evaluer(arbre.droit);
		}
		if (arbre.element == SOUSTRACTION) {
			return evaluer(arbre.gauche) - evaluer(arbre.droit);
		}
		if (arbre.element == MULTIPLICATION) {
			return evaluer(arbre.gauche) * evaluer(arbre.droit);
		}
		if (arbre.element == DIVISION) {
			return evaluer(arbre.gauche) / evaluer(arbre.droit);
		}			
		if(arbre.element == X){			
			return x;
		}			
		
		return arbre.element;	
		
	}
	
	/**	 
	 * Methode récursive qui permet d'afficher l'expression arithmétique sous
	 * une représentation infixe.
	 * @param arbre
	 */
	public static void afficherInfixe(Arbre arbre) {
		
		if (arbre.element == ADDITION) {
			Pep8.charo('(');
			afficherInfixe(arbre.gauche);
			Pep8.charo('+');
			afficherInfixe(arbre.droit);
			Pep8.charo(')');
			
		} else if (arbre.element == SOUSTRACTION) {
			Pep8.charo('(');
			afficherInfixe(arbre.gauche);
			Pep8.charo('-');
			afficherInfixe(arbre.droit);
			Pep8.charo(')');
			
		} else if (arbre.element == MULTIPLICATION) {
			Pep8.charo('(');
			afficherInfixe(arbre.gauche);
			Pep8.charo('*');
			afficherInfixe(arbre.droit);
			Pep8.charo(')');
			
		} else if (arbre.element == DIVISION) {
			Pep8.charo('(');
			afficherInfixe(arbre.gauche);
			Pep8.charo('/');
			afficherInfixe(arbre.droit);
			Pep8.charo(')');
			
		} else {
			if (arbre.element == X) {
				Pep8.charo('x');;
			} else {
				Pep8.deco(arbre.element );
			}			
		}		
	}

	/**
	 * Methode qui indique si un caractère est un opérateur arithmetique.
	 * 
	 * @param c caractère à vérifier
	 * @return true si opérateur arithmetique, false sinon
	 */
	public static boolean estOperateur(char c) {

		return c == '+' || c == '-' || c == '*' || c == '/';
	}

	/**
	 * Methode qui indique si un caractère est un chiffre de 0 à 9.
	 * 
	 * @param c caractère à vérifier
	 * @return true si chiffre, false sinon
	 */
	public static boolean estChiffre(char c) {

		return c >= '0' && c <= '9';
	}

	/**
	 * Methode qui indique si un caractère est un espace ou saut de ligne.
	 * 
	 * @param c caractère à vérifier
	 * @return true si espace ou saut de ligne, false sinon
	 */
	public static boolean estEspacesOuSautDeligne(char c) {

		return c == ' ' || c == '\n' || c == '\r';
	}

	/**
	 * Methode qui permet d'obtenir la valeur entiere d'un caractère numerique
	 * un caractère en entier.
	 * 
	 * @param c caractère a convertir
	 * @return valeur entiere du caractère
	 */
	public static int valeurEntiere(char c) {

		return c - '0';
	}

	/**
	 * Methode qui permet d'attribuer une valeur numerique pour coder les
	 * opérateurs arithmétiques 
	 * 
	 * @param c
	 * @return
	 */

	public static int coderOperateur(char c) {

		if (c == '+') {
			return ADDITION;
		}
		if (c == '-') {
			return SOUSTRACTION;
		}
		if (c == '*') {
			return MULTIPLICATION;
		}
		if (c == '/') {
			return DIVISION;
		}
		return -1;
	}

	/**
	 * Methode qui permet de vérifier si un entier représente un opérateur arithmétique.
	 * @param e entier a vérifier
	 * @return true si il s'agit d'une code d'un opérateur, false sinon
	 */
	public static boolean estOperateurEncode(int e) {

		return e == ADDITION || e == SOUSTRACTION || e == MULTIPLICATION
				|| e == DIVISION;
	}
}

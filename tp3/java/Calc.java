/**
 * OBJECTIF
 * ========
 * L'objectif de ce programme est de r�aliser un �valuateur d'expressions
 * arithm�tiques en notation pr�fixe.
 * 
 * Le programme lit une expression arithm�tique en notation pr�fixe compos�e de
 * nombres, des quatre op�rateurs binaires +, -, *, et /  et d'une variable x, 
 * puis attend une s�quence de commandes:
 * -> La commande d'arr�t '.' 
 * 	  affiche un point (.), un saut de ligne (\n) et quitte le programme.
 * -> La commande de calcul '='
 * 	  affiche le r�sultat du calcul de l'expression arithm�tique, suivi d'un
 * 	  saut de ligne.
 * -> La commande d'�criture infixe '>'
 *    affiche l'expression arithm�tique sous une repr�sentation infixe.
 * -> La commande x
 * 	  affecte une valeur � x qui sera utilis�e lors des prochaines �valuations.
 *
 * IMPL�MENTATION
 * ==============
 * On a choisi de repr�senter l'expression arithm�tique avec une structure
 * arborescente (arbre) dans lequel un �l�ment est soit une op�ration soit un
 * nombre, et o� une op�ration � deux �l�ments fils : un pour chacune de ses 
 * deux op�randes.
 * l'element de notre arbre est de type int, j'ai choisi des entiers n�gatifs 
 * pour repr�senter et stocker les op�rateurs et x dans l'arbre, et de les
 * d�coder � la phase de calcul et d'affichage infixe.
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
	 * Constantes pour encoder les op�rateurs arithm�tiques, j'ai choisi de
	 * repr�senter les op�rateurs avec des nombres n�gatifs au hasard. pour les
	 * stocker dans notre arbre. 
	 */
	static final int ADDITION = -10;
	static final int SOUSTRACTION = -11;
	static final int MULTIPLICATION = -12;
	static final int DIVISION = -13;
	
	/**
	 * Constante pour encoder le caract�re x.
	 */
	static final int X = -14 ;	
	
	/**
	 * Constante pour represnter la commande d'arr�t .
	 */
	static final char CMD_ARRET = '.';

	/**
	 * Constantes pour representer les actions utilis�es dans les methodes 
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
	 * initialis� a \n pour quelle soit ignor� au d�but.
	 */
	static char commande = '\n';
	
	
	

	public static void main(String[] args) {

		/**
		 * lecture et construction de l'arbre.
		 */
		
		System.out.println("leval:"+lireEval(LIRE, 0, 0));
		
		//Arbre arbre = lire();

		/**
		 * lecture d'une s�quence de commandes.
		 */
		
		while (commande != CMD_ARRET) {
			
			commande = Pep8.chari();
			
			switch (commande) {
			
			case CMD_ARRET: //Commande d'arr�t
				Pep8.charo('.');
				Pep8.charo('\n');
				break;
			
			case '=': //Commande de calcul =				
				//Pep8.deco(evaluer(arbre));
				Pep8.charo('\n');
				break;
			
			case '>': //Commande d'�criture infixe >
				//afficherInfixe(arbre);
				Pep8.charo('\n');
				break;	
			
			case 'x': //La commande x permet d'affecter une valeur � x
				x = Pep8.deci();				
				break;
			
			//Les espaces et sauts de lignes sont ignor�s.	
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
	 * Methode r�cursive de l'�tape 1 qui lie et evalue une
	 * expression arithmetique constitu� de nombres compris entre 0 et 9 et
	 * seulement avec les op�rations d'additions et de soustractions
	 * 
	 * @param action l'action a faire
	 * @param gauche Op�rande de gauche
	 * @param droit Op�rande de droite
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
	 * �tape 2: Am�lioration de la lecture et des op�rations par rapport � la
	 * m�thode etape1: 
	 * -> traitement des nombres plus grand que 9 
	 * -> ajout des op�rateurs * et / 
	 * -> la gestion compl�te et robuste des espaces et sauts
	 * de lignes.
	 * 
	 * @param action l'action a faire
	 * @param gauche Op�rande de gauche
	 * @param droit Op�rande de droite
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
	 * �tape 3: Construction d'un arbre. On s�pare la lecture et le calcul en
	 * deux fonctionnalit�s distinctes, On cr�e donc deux methodes : lire() et
	 * evaluer()
	 */

	/**
	 * Methode r�cursive qui lit une expression arithmetique et qui construit
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
	 * Methode recursive qui permet d'obtenir un terme (op�rateur ou op�rande)
	 * d'une expression en fonction du caract�re pass� en param�tre. 	 
	 * 
	 * @param caracLu
	 * @return le terme (op�rateur ou op�rande) d'une expression sous forme
	 * d'entier:
	 *	* Si le parametre est op�rateur on retourne l'entier n�gatif qui le
	 *	  represente (voir les constantes declarees en haut ADDITION ...). 
	 * 	* Si le parametre est egale a 'x' on retourne l'entier n�gatif qui
	 * 	  le represente (-14 ,represent� avec la constante X  ).
	 *  * Si le parametre est egale � un caract�re num�rique on lie le suivant
	 *    jusqu'� la rencontre d'un espace ou saut de ligne et retourne le nombre
	 *    contenant ces caract�res num�rique.
	 *  * Sinon si le parametre est un caract�re non autoris� on affiche un 
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

		} else {//cas caract�re invalide.				
			rslt = 0;
			Pep8.stro("Expression invalide!");
			commande = CMD_ARRET; //pour arreter le programme.			
		}
		
		return rslt;
	}

	/**
	 * Methode r�cursive qui permet d'evalue une expression arithmetique � 
	 * partir d'une arbre pass�e en param�tre.
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
	 * Methode r�cursive qui permet d'afficher l'expression arithm�tique sous
	 * une repr�sentation infixe.
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
	 * Methode qui indique si un caract�re est un op�rateur arithmetique.
	 * 
	 * @param c caract�re � v�rifier
	 * @return true si op�rateur arithmetique, false sinon
	 */
	public static boolean estOperateur(char c) {

		return c == '+' || c == '-' || c == '*' || c == '/';
	}

	/**
	 * Methode qui indique si un caract�re est un chiffre de 0 � 9.
	 * 
	 * @param c caract�re � v�rifier
	 * @return true si chiffre, false sinon
	 */
	public static boolean estChiffre(char c) {

		return c >= '0' && c <= '9';
	}

	/**
	 * Methode qui indique si un caract�re est un espace ou saut de ligne.
	 * 
	 * @param c caract�re � v�rifier
	 * @return true si espace ou saut de ligne, false sinon
	 */
	public static boolean estEspacesOuSautDeligne(char c) {

		return c == ' ' || c == '\n' || c == '\r';
	}

	/**
	 * Methode qui permet d'obtenir la valeur entiere d'un caract�re numerique
	 * un caract�re en entier.
	 * 
	 * @param c caract�re a convertir
	 * @return valeur entiere du caract�re
	 */
	public static int valeurEntiere(char c) {

		return c - '0';
	}

	/**
	 * Methode qui permet d'attribuer une valeur numerique pour coder les
	 * op�rateurs arithm�tiques 
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
	 * Methode qui permet de v�rifier si un entier repr�sente un op�rateur arithm�tique.
	 * @param e entier a v�rifier
	 * @return true si il s'agit d'une code d'un op�rateur, false sinon
	 */
	public static boolean estOperateurEncode(int e) {

		return e == ADDITION || e == SOUSTRACTION || e == MULTIPLICATION
				|| e == DIVISION;
	}
}

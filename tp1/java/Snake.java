/***************************************************************
 * 		LAAROUSSI Mohamed 
 * 		INF2170-TP1 1ERE PARTIE 
 * 		17-10-2014
 ***************************************************************/

/**
 * Ce programme r�alise un convertisseur CamelCase vers snake_case.
 * 
 * CamelCase est une convention typographique qui consiste � mettre en majuscule
 * les premi�res lettres de chaque mot, quant au snake_case il consiste � �crire
 * des mots en minuscules en les s�parant par des soulign�s.
 * 
 * Le programme prend en entr�e une ligne de texte (une s�quence de caract�res
 * termin�e par un retour chariot '\n'). Il affiche en sortie une version
 * snake_case de cette ligne de texte.
 * 
 * 
 * @author Mohamed LAAROUSSI
 *
 */

public class Snake {

	public static void main(String[] args) {

		/**
		 * Variable pour m�moriser la valeur saisie au clavier, initialis�e � 0
		 * (caract�re NULL).
		 */
		char caracSaisie = 0;

		/**
		 * Variable pour m�moriser la valeur pr�c�dente de caracSaisie,
		 * initialis�e � 0 (caract�re NULL).
		 */
		char caracPrecedent = 0;

		/**
		 * Variable pour m�moriser la valeur pr�c�dente de caracPrecedent,
		 * initialis�e � 0 (caract�re NULL).
		 */
		char caracAvantPrecedent = 0;

		/**
		 * Variable d'aide pour recuperer la valeur de caracAvantPrecedent,
		 * initialis�e � 0 (caract�re NULL).
		 */
		char tmp = 0;

		do {

			/**
			 * on m�morise la valeur pr�c�dente et avant pr�c�dente du caract�re
			 * saisie (caractereCourant).
			 */
			tmp = caracPrecedent;
			caracPrecedent = caracSaisie;
			caracAvantPrecedent = tmp;

			/** et on saisie une nouvelle valeur */
			caracSaisie = Pep8.chari();

			if (estLettreMajuscule(caracAvantPrecedent)) {

				if (estLettreMajuscule(caracPrecedent)) {

					if (estLettreMinuscule(caracSaisie)) {

						Pep8.charo(transformerEnMinuscule(caracAvantPrecedent));
						Pep8.charo('_');

					} else {

						Pep8.charo(transformerEnMinuscule(caracAvantPrecedent));
					}

				} else {

					Pep8.charo(transformerEnMinuscule(caracAvantPrecedent));

				}

			} else if (estLettreMinuscule(caracAvantPrecedent)) {

				if (estLettreMajuscule(caracPrecedent)) {

					Pep8.charo(caracAvantPrecedent);
					Pep8.charo('_');

				} else {

					Pep8.charo(caracAvantPrecedent);

				}

			} else if (caracAvantPrecedent != 0) {

				Pep8.charo(caracAvantPrecedent);
			}

			if (caracSaisie == '\n') {

				Pep8.charo(caracPrecedent);
				Pep8.charo(caracSaisie);
			}

		} while (caracSaisie != '\n');

	}

	/**
	 * M�thode qui retourne true si son param�tre est une lettre majuscule, elle
	 * retourne false dans les autres cas.
	 */
	public static boolean estLettreMajuscule(char c) {

		boolean rslt = false;

		if (c >= 'A' && c <= 'Z') {
			rslt = true;
		}
		return rslt;
	}

	/**
	 * M�thode qui retourne true si son param�tre est une lettre miniscule, elle
	 * retourne false dans les autres cas.
	 */
	public static boolean estLettreMinuscule(char c) {

		boolean rslt = false;

		if (c >= 'a' && c <= 'z') {
			rslt = true;
		}
		return rslt;
	}

	/**
	 * M�thode qui prend en param�tre un caract�re et il retourne une lettre
	 * minuscule si son param�tre est est une lettre majuscule, elle retourne le
	 * meme caractre dans les autres cas.
	 */
	public static char transformerEnMinuscule(char c) {

		if (c >= 'A' && c <= 'Z') {

			/**
			 * ('a'-'A') est la difference entre les lettres minuscules et les
			 * majuscules pour n'import quel lettre de l'alphabet(a-z).
			 */
			c = (char) (c + 'a' - 'A');

		}

		return c;
	}

}

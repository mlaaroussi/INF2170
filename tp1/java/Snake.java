/***************************************************************
 * 		LAAROUSSI Mohamed 
 * 		INF2170-TP1 1ERE PARTIE 
 * 		17-10-2014
 ***************************************************************/

/**
 * Ce programme réalise un convertisseur CamelCase vers snake_case.
 * 
 * CamelCase est une convention typographique qui consiste à mettre en majuscule
 * les premières lettres de chaque mot, quant au snake_case il consiste à écrire
 * des mots en minuscules en les séparant par des soulignés.
 * 
 * Le programme prend en entrée une ligne de texte (une séquence de caractères
 * terminée par un retour chariot '\n'). Il affiche en sortie une version
 * snake_case de cette ligne de texte.
 * 
 * 
 * @author Mohamed LAAROUSSI
 *
 */

public class Snake {

	public static void main(String[] args) {

		/**
		 * Variable pour mémoriser la valeur saisie au clavier, initialisée à 0
		 * (caractère NULL).
		 */
		char caracSaisie = 0;

		/**
		 * Variable pour mémoriser la valeur précédente de caracSaisie,
		 * initialisée à 0 (caractère NULL).
		 */
		char caracPrecedent = 0;

		/**
		 * Variable pour mémoriser la valeur précédente de caracPrecedent,
		 * initialisée à 0 (caractère NULL).
		 */
		char caracAvantPrecedent = 0;

		/**
		 * Variable d'aide pour recuperer la valeur de caracAvantPrecedent,
		 * initialisée à 0 (caractère NULL).
		 */
		char tmp = 0;

		do {

			/**
			 * on mémorise la valeur précédente et avant précédente du caractère
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
	 * Méthode qui retourne true si son paramètre est une lettre majuscule, elle
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
	 * Méthode qui retourne true si son paramètre est une lettre miniscule, elle
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
	 * Méthode qui prend en paramètre un caractère et il retourne une lettre
	 * minuscule si son paramètre est est une lettre majuscule, elle retourne le
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

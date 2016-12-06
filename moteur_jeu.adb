package body Moteur_jeu is

	--Choisit le coup à jouer en fonction de l'état du jeu
	function Choix_Coup(E : Etat) return Coup is
		-- On récupère la liste des coups_possibles et on crée un itérateur pour parcourir la liste
		L : Liste_Coups.Liste := Coups_Possibles(E, JoueurMoteur);
		It : Liste_Coups.Iterateur := Liste_Coups.Creer_Iterateur(L);
		C : Coup;
		-- Le coup que l'on va renvoyer
		Meilleur_Coup : Coup;
		Eval,I : Integer;
	begin
		-- On initialise les variables avec le premier coup de la liste
		Meilleur_Coup := Liste_Coups.Element_Courant(It);
		Eval := Eval_Min_Max(E, P, Meilleur_Coup, JoueurMoteur);
		-- On boucle sur tout les coups possibles
		while Liste_Coups.A_Suivant(It) loop
			Liste_Coups.Suivant(It);
			C := Liste_Coups.Element_Courant(It);
			I := Eval_Min_Max(E, P, C, JoueurMoteur);
			Put(I);
			Affiche_Coup(C);
			-- On garde le coup avec la meilleure évaluation
			if I>Eval then
				Meilleur_Coup := C;
				Eval := I;
			end if;
		end loop;
		return Meilleur_Coup;
	end Choix_Coup;

	-- Evalue le coup C joué à l'Etat E par le joueur J à une profondeur P
	function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
		-- L'état après que le coup soit appliqué
		EtatSuivant : Etat := Etat_Suivant(E, C);
		L : Liste_Coups.Liste;
		It : Liste_Coups.Iterateur;
		Courant : Coup;
		Meilleur_Coup : Coup;
		Eva,I : Integer;
		Advers : Joueur := Adversaire(J);
	begin
		--si le coup est gagnant on renvoie 100 (plus grande évaluation possible)
		if Est_Gagnant(EtatSuivant, JoueurMoteur) then
			return 100;
		end if;
		
		--s'il est nul on renvoie 0
		if Est_Nul(EtatSuivant) then
			return 0;
		end if;
		
		--s'il est perdant, on renvoie -100 (plus petite évaluation possible)
		if Est_Gagnant(EtatSuivant, Adversaire(JoueurMoteur)) then
			return -100;
		end if;
		
		--Si la profondeur est atteinte (P=0), on utilise l'évaluation statique
		if P = 0 then
			Eva := Eval(EtatSuivant, JoueurMoteur) - Eval(EtatSuivant, Adversaire(JoueurMoteur));
		
		--Si elle n'est pas atteinte, on teste tout les coups possible à partir de cet état
		else
			-- même principe que dans la fonction Choix_Coup
			L := Coups_Possibles(EtatSuivant, Advers);
			It := Liste_Coups.Creer_Iterateur(L);
			Meilleur_Coup := Liste_Coups.Element_Courant(It);
			Eva := Eval_Min_Max(EtatSuivant, P-1, Meilleur_Coup, Advers);
			while Liste_Coups.A_Suivant(It) loop
				Liste_Coups.Suivant(It);
				Courant := Liste_Coups.Element_Courant(It);
				-- l'évaluation s'effectue à une profondeur P-1
				I := Eval_Min_Max(EtatSuivant, P-1, Courant, Advers);
				-- on remonte le coup avec la meilleur evaluation (Max)
				if J = Adversaire(JoueurMoteur) then
					if I>Eva then
						Meilleur_Coup := Courant;
						Eva := I;
					end if;
				-- On remonte le coup avec la moins bonne evaluation (Min)
				else
					if I<Eva then
						Meilleur_Coup := Courant;
						Eva := I;
					end if;
				end if;
			end loop;
		end if;
		return Eva;
	end Eval_Min_Max;

end Moteur_jeu;

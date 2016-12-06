package body Moteur_jeu is

	function Choix_Coup(E : Etat) return Coup is
		L : Liste_Coups.Liste := Coups_Possibles(E, JoueurMoteur);
		It : Liste_Coups.Iterateur := Liste_Coups.Creer_Iterateur(L);
		C : Coup;
		Meilleur_Coup : Coup;
		Eval,I : Integer;
	begin
		Meilleur_Coup := Liste_Coups.Element_Courant(It);
		Eval := Eval_Min_Max(E, P, Meilleur_Coup, JoueurMoteur);
		while Liste_Coups.A_Suivant(It) loop
			Liste_Coups.Suivant(It);
			C := Liste_Coups.Element_Courant(It);
			I := Eval_Min_Max(E, P, C, JoueurMoteur);
			if I>Eval then
				Meilleur_Coup := C;
				Eval := I;
			end if;
		end loop;
		return Meilleur_Coup;
	end Choix_Coup;

	function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur) return Integer is
		EtatSuivant : Etat := Etat_Suivant(E, C);
		L : Liste_Coups.Liste;
		It : Liste_Coups.Iterateur;
		Courant : Coup;
		Meilleur_Coup : Coup;
		Eva,I : Integer;
		Advers : Joueur := Adversaire(J);
	begin
		if Est_Gagnant(EtatSuivant, J) then
			return 100;
		end if;
		if Est_Nul(EtatSuivant) then
			return 0;
		end if;
		if Est_Gagnant(EtatSuivant, Advers) then
			return -100;
		end if;
		if P = 0 then
			Eva := Eval(EtatSuivant);
		else
			if J = Joueur1 then
				L := Coups_Possibles(EtatSuivant, Advers);
				It := Liste_Coups.Creer_Iterateur(L);
				Meilleur_Coup := Liste_Coups.Element_Courant(It);
				Eva := Eval_Min_Max(EtatSuivant, P-1, Meilleur_Coup, Advers);
				while Liste_Coups.A_Suivant(It) loop
					Liste_Coups.Suivant(It);
					Courant := Liste_Coups.Element_Courant(It);
					I := Eval_Min_Max(EtatSuivant, P-1, Courant, Advers);
					if I>Eva then
						Meilleur_Coup := Courant;
						Eva := I;
					end if;
				end loop;
			else
				L := Coups_Possibles(EtatSuivant, Advers);
				It := Liste_Coups.Creer_Iterateur(L);
				Meilleur_Coup := Liste_Coups.Element_Courant(It);
				Eva := Eval_Min_Max(EtatSuivant, P-1, Meilleur_Coup, Advers);
				while Liste_Coups.A_Suivant(It) loop
					Liste_Coups.Suivant(It);
					Courant := Liste_Coups.Element_Courant(It);
					I := Eval_Min_Max(EtatSuivant, P-1, Courant, Advers);
					if I<Eva then
						Meilleur_Coup := Courant;
						Eva := I;
					end if;
				end loop;
			end if;
		end if;
		return Eva;
	end Eval_Min_Max;

end Moteur_jeu;

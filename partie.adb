package body Partie is
	procedure Joue_Partie (E : in out Etat; J : in Joueur) is
		Coup_suivant : Coup;
		FinPartie : Boolean := false;
		Joueur_courant : Joueur := J;
	begin
		Affiche_Jeu(E);
		while not(FinPartie) loop
			if Joueur_Courant = Joueur1 then
				-- Joueur 1 joue
				Coup_suivant := Coup_Joueur1(E);
				Affiche_Coup(Coup_suivant);
				E := Etat_Suivant(E, Coup_suivant);
				New_Line;
				New_Line;
				Affiche_Jeu(E);
				if Est_Gagnant(E, Joueur1) then
					Put(Nom_Joueur1 & " a gagné");
					New_line;
					FinPartie := true;
				elsif Est_Nul(E) then
						Put("Match nul");
						New_Line;
						FinPartie := true;
				end if;
				Joueur_Courant := Joueur2;
			else
				-- Joueur 2 joue
				Coup_suivant := Coup_Joueur2(E);
				Affiche_Coup(Coup_suivant);
				E := Etat_Suivant(E, Coup_suivant);
				New_Line;
				New_Line;
				Affiche_Jeu(E);
				if Est_Gagnant(E, Joueur2) then
					Put(Nom_Joueur2 & " a gagné");
					New_Line;
					FinPartie := true;
				elsif Est_Nul(E) then
						Put("Match nul");
						New_Line;
						FinPartie := true;
				end if;
				Joueur_Courant := Joueur1;
			end if;
		end loop;
	end Joue_Partie;

end Partie;

package body Partie is
	procedure Joue_Partie (E : in out Etat; J : in Joueur) is
		Coup_suivant : Coup;
	begin
		for I in 1..10 loop
			Coup_suivant := Coup_Joueur1(E);
			Affiche_Coup(Coup_suivant);
			Etat_Suivant(E, Coup_suivant);
			Affiche_Jeu(E);
			if Est_Gagnant(E, J) then
				put("Le joueur 1 a gagné");
			else
				if Est_Nul(E) then
					put("Match nul");
				end if;
			end if;
			Coup_suivant := Coup_Joueur2(E);
			Affiche_Coup(Coup_suivant);
			Etat_Suivant(E, Coup_suivant);
			Affiche_Jeu(E);
			if Est_Gagnant(E, Joueur2) then
				put("Le joueur 1 a gagné");
			else
				if Est_Nul(E) then
					put("Match nul");
				end if;
			end if;
		end loop;
	end Joue_Partie;
	
end Partie;

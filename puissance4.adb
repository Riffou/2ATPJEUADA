package body Puissance4 is

	procedure Initialiser(etat_initial : in out Etat) is
	begin
		for i in 1..Hauteur loop
			for j in 1..Largeur loop
			   etat_initial(i,j) := 0;
			end loop;
		end loop;
	end Initialiser;

    -- Calcule l'etat suivant en appliquant le coup
  function Jouer(E : Etat; C : Coup) return Etat is
		I : Integer := 1;
		F : Etat := E;
	begin
		while I <= Hauteur and F(Hauteur + 1 - I,C.Colonne) /= 0 loop
				I := I + 1;
		end loop;
		if C.J = Joueur1 then
			F(Hauteur + 1 - I,C.Colonne) := 1;
		else
			F(Hauteur + 1 - I,C.Colonne) := 2;
		end if;
		return F;
	end Jouer;

    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean is
		NbAligneHorizontal : Integer := 0;
		NbAligneVertical : Integer := 0;
		NbAligneDiagonal : Integer := 0;
		NbAligneDiagonalInverse : Integer := 0;
		Diagonal : Integer := 0;
		NumeroJoueur : Integer;
		Compteur : Integer := 0;
	begin
		if J = Joueur1 then
			NumeroJoueur := 1;
		else
			NumeroJoueur := 2;
		end if;

		-- Alignement horizontal
		for I in 1..Hauteur loop
			for J in 1..Largeur loop
				-- Alignement Horizontal
				if E(I, J) = NumeroJoueur then
					NbAligneHorizontal := NbAligneHorizontal + 1;
				else
					NbAligneHorizontal := 0;
				end if;

				-- Si le nombre de jetons alignés horizontalement est bon
				if NbAligneHorizontal = NombreAligne then
					return true;
				end if;
			end loop;
			NbAligneHorizontal := 0;
		end loop;

		-- Alignement vertical
		for I in 1..Largeur loop
			for J in 1..Hauteur loop
				if E(J, I) = NumeroJoueur then
					NbAligneVertical := NbAligneVertical + 1;
				else
					NbAligneVertical := 0;
				end if;

				-- Si le nombre de jetons alignés verticalement est bon
				if NbAligneVertical = NombreAligne then
					return true;
				end if;
			end loop;
			NbAligneVertical := 0;
		end loop;

		-- Alignement diagonal
		Diagonal := Integer'Max(Hauteur, Largeur);
		for I in 0..(Diagonal - NombreAligne) loop
			for J in 1..(Diagonal - I) loop

				if E(J, J + I) = NumeroJoueur then
					NbAligneDiagonal := NbAligneDiagonal + 1;
				else
					NbAligneDiagonal := 0;
				end if;
				if NbAligneDiagonal = NombreAligne then
					return true;
				end if;
			end loop;
			NbAligneDiagonal := 0;
		end loop;
		Compteur := 0;



		-- Alignement diagonal inversé
		for I in 0..(Diagonal - NombreAligne) loop
			for J in 1..(Diagonal - I) loop
				if E(Diagonal - I - J + 1, J) = NumeroJoueur then
					NbAligneDiagonalInverse := NbAligneDiagonalInverse + 1;
				else
					NbAligneDiagonalInverse := 0;
				end if;
				if NbAligneDiagonalInverse = NombreAligne then
					return true;
				end if;
			end loop;
			NbAligneDiagonalInverse := 0;
		end loop;

		return false;
	end Est_Gagnant;

    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean is
		GrilleRemplie : Boolean := true;
	begin
		for I in 1..Hauteur loop
			for J in 1..Largeur loop
				if E(I, J) = 0 then
					GrilleRemplie := false;
				end if;
			end loop;
		end loop;
		if not(Est_Gagnant(E, Joueur1)) AND not(Est_Gagnant(E,Joueur2)) AND GrilleRemplie then
			return true;
		end if;
		return false;
	end Est_Nul;

    -- Fonction d'affichage de l'etat courant du jeu
    procedure Afficher(E : Etat) is
	begin
		-- Affichage des numéros de colonne
		Put(" ");
		for I in 1..Largeur loop
			Put (Integer'Image(I) & "  ");
		end loop;
		New_Line;
		-- Affichage des pions et de la grille
		for I in 1..Hauteur loop
			for J in 1..Largeur loop
				Put("| ");
				if E(I, J) = 1 then
					Put("X ");
				elsif E(I, J) = 2 then
					Put("O ");
				else
					Put("  ");
				end if;
			end loop;
			Put("|");
			New_Line;
		end loop;
		New_line;
		Put("-------------");
		New_Line;
		New_Line;
	end Afficher;

    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup) is
	begin
		if C.J = Joueur1 then
			Put("Joueur 1 joue : " & Integer'Image(C.Colonne));
			New_Line;
		else
			Put("Joueur 2 joue : " & Integer'Image(C.Colonne));
			New_Line;
		end if;
		New_line;
	end Affiche_Coup;

    -- Retourne le prochain coup joue par le joueur1
    function Demande_Coup_Joueur1(E : Etat) return Coup is
		ColonneJ : Integer;
		I : Integer := 1;
		CoupValable : Boolean := false;
		CoupJoueur1 : Coup;
		Break : Boolean := false;
	begin
		while CoupValable = false loop
			Put_Line("Que voulez-vous jouer Paul ?");
			Get(ColonneJ);
			-- Vérifier que la demande de coup est possible
			while I <= Hauteur and not(break) loop
				if E(I, ColonneJ) /= 0 then
					I := I + 1;
				else
					break := true;
				end if;
			end loop;
			if I > Hauteur then
				Put("Coup Impossible");
				New_Line;
			else
				CoupValable := true;
			end if;
			I := 1;
		end loop;
		CoupJoueur1.J := Joueur1;
		CoupJoueur1.Colonne := ColonneJ;
		return CoupJoueur1;
	end Demande_Coup_Joueur1;

    -- Retourne le prochain coup joue par le joueur2
    function Demande_Coup_Joueur2(E : Etat) return Coup is
		ColonneJ : Integer;
		I : Integer := 1;
		CoupValable : Boolean := false;
		CoupJoueur2 : Coup;
		Break : Boolean := false;
	begin
		while CoupValable = false loop
			Put_Line("Que voulez-vous jouer Pierre ?");
			Get(ColonneJ);
			-- Vérifier que la demande de coup est possible
			while I <= Hauteur and not(break) loop
				if E(I, ColonneJ) /= 0 then
					I := I + 1;
				else
					break := true;
				end if;
			end loop;
			if I > Hauteur then
				Put("Coup Impossible");
				New_Line;
			else
				CoupValable := true;
			end if;
			I := 1;
		end loop;
		CoupJoueur2.J := Joueur2;
		CoupJoueur2.Colonne := ColonneJ;
		return CoupJoueur2;
	end Demande_Coup_Joueur2;

	function Coups_Possibles(E : Etat; J : Joueur) return Liste_Coups.Liste is
		I : Integer := 1;
		break : Boolean := false;
		L : Liste_Coups.Liste := Liste_Coups.Creer_Liste;
		CoupValable : Boolean := false;
		C : Coup;
	begin
		C.J := J;
		for ColonneJ in 1..Largeur loop
			while CoupValable = false loop
				while I <= Hauteur and not(break) loop
					if E(I, ColonneJ) /= 0 then
						I := I + 1;
					else
						break := true;
					end if;
				end loop;
				if I < Hauteur then
					C.Colonne := ColonneJ;
					Liste_Coups.Insere_Tete(C, L);
					CoupValable := true;
				end if;
				I := 1;
			end loop;
		end loop;
		return L;
	end Coups_Possibles;

	function Eval(E : Etat) return Integer is
	begin
		return 1;
	end Eval;

end Puissance4;

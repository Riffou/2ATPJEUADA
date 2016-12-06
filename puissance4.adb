package body Puissance4 is

	procedure Initialiser(etat_initial : in out Etat) is
	begin
		-- Initialisation du tableau d'état, on met toutes les cases à 0
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
		-- Dans cette fonction on ne vérifie pas si le coup est possible, cette vérification est déjà faite dans la fonction demande_coup
		-- On regarde la hauteur des pions déjà alignés dans la colonne où le joueur veut jouer
		while I < Hauteur and then F(Hauteur + 1 - I,C.Colonne) /= 0 loop
				I := I + 1;
		end loop;
		-- On place le pion à la bonne hauteur
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
		for I in 1..(Hauteur - NombreAligne + 1) loop
			for J in 1..(Largeur - NombreAligne + 1) loop
				for K in 0..(NombreAligne - 1) loop
					if E(I + K, J + K) = NumeroJoueur then
						NbAligneDiagonal := NbAligneDiagonal + 1;
					else
						NbAligneDiagonal := 0;
					end if;
					-- Si le nombre de jetons alignés diagonalement est bon
					if NbAligneDiagonal = NombreAligne then
						return true;
					end if;
				end loop;
				NbAligneDiagonal := 0;
			end loop;
		end loop;
		Compteur := 0;


		-- Alignement diagonal inversé
		for I in 1..(Hauteur - NombreAligne + 1) loop
			for J in 1..(Largeur - NombreAligne + 1) loop
				for K in 0..(NombreAligne-1) loop
					if E(I + (3-K), J + K) = NumeroJoueur then
						NbAligneDiagonalInverse := NbAligneDiagonalInverse + 1;
					else
						NbAligneDiagonalInverse := 0;
					end if;
					-- Si le nombre de jetons alignés diagonalement inversé est bon
					if NbAligneDiagonalInverse = NombreAligne then
						return true;
					end if;
				end loop;
				NbAligneDiagonalInverse := 0;
			end loop;
		end loop;

		return false;
	end Est_Gagnant;

    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean is
		GrilleRemplie : Boolean := true;
	begin
		-- On regarde si la grille est remplie
		for I in 1..Hauteur loop
			for J in 1..Largeur loop
				if E(I, J) = 0 then
					GrilleRemplie := false;
				end if;
			end loop;
		end loop;
		-- Si la grille est remplie et que les deux joueurs n'ont pas gagné, alors match nul
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
			Put_Line("Que voulez-vous jouer Joueur 1 ?");
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
			Put_Line("Que voulez-vous jouer Joueur 2 ?");
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
	
	-- Fonctions utilisée pour le moteur de jeu 

	-- retourne la liste des coups possibles sous la forme d'une liste
	function Coups_Possibles(E : Etat; J : Joueur) return Liste_Coups.Liste is
		I : Integer := 1;
		break : Boolean := false;
		L : Liste_Coups.Liste := Liste_Coups.Creer_Liste;
		CoupValable : Boolean := false;
		C : Coup;
	begin
		C.J := J;
		for ColonneJ in 1..Largeur loop
			while I <= Hauteur and not(break) loop
				if E(I, ColonneJ) /= 0 then
					I := I + 1;
				else
					break := true;
				end if;
			end loop;
			break := false;
			if I < Hauteur then
				C.Colonne := ColonneJ;
				Liste_Coups.Insere_Tete(C, L);
			end if;
			I := 1;
		end loop;
		return L;
	end Coups_Possibles;

	-- On évalue l'état statique
	function Eval(E : Etat; J : Joueur) return Integer is
		NbAligneHorizontal : Integer := 0;
		NbAligneVertical : Integer := 0;
		NbAligneDiagonal : Integer := 0;
		NbAligneDiagonalInverse : Integer := 0;
		NumeroJoueur : Integer := 0;
		Compteur : Integer := 0;
		Eva : Integer := 0;
	begin
		
		If J = Joueur1 then
			NumeroJoueur := 1;
		else
			NumeroJoueur := 2;
		end if;
		
		-- Attribution des points sur l'alignement horizontal
		for I in 1..Hauteur loop
			for J in 1..Largeur loop
				if E(I, J) = NumeroJoueur then
					NbAligneHorizontal := NbAligneHorizontal + 1;
				else
					NbAligneHorizontal := 0;
				end if;
				-- Si le coup nous permet d'avoir 3 pions alignés, on attribue +10
				if NbAligneHorizontal = NombreAligne-1 then
					Eva := Eva + 10;
				-- Si le coup nous permet d'avoir 2 pions alignés, on attribue +5
				elsif NbAligneHorizontal = NombreAligne-2 then
					Eva := Eva + 5;
				end if;
			end loop;
			NbAligneHorizontal := 0;
		end loop;

		-- Attribution des points sur l'alignement vertical
		for I in 1..Largeur loop
			for J in 1..Hauteur loop
				if E(J, I) = NumeroJoueur then
					NbAligneVertical := NbAligneVertical + 1;
				else
					NbAligneVertical := 0;
				end if;
				-- Si le coup nous permet d'avoir 3 pions alignés, on attribue +10
				if NbAligneVertical = NombreAligne-1 then
					Eva := Eva + 10;
				-- Si le coup nous permet d'avoir 2 pions alignés, on attribue +5
				elsif NbAligneVertical = NombreAligne-2 then
					Eva := Eva + 5;
				end if;
			end loop;
			NbAligneVertical := 0;
		end loop;

		-- Attribution des points sur l'alignement diagonal
		for I in 1..(Hauteur - NombreAligne + 1) loop
			for J in 1..(Largeur - NombreAligne + 1) loop
				for K in 0..(NombreAligne - 1) loop
					if E(I + K, J + K) = NumeroJoueur then
						NbAligneDiagonal := NbAligneDiagonal + 1;
					else
						NbAligneDiagonal := 0;
					end if;
					-- Si le coup nous permet d'avoir 3 pions alignés, on attribue +10
					if NbAligneDiagonal = NombreAligne-1 then
						Eva := Eva + 10;
					-- Si le coup nous permet d'avoir 2 pions alignés, on attribue +5
					elsif NbAligneDiagonal = NombreAligne-2 then
						Eva := Eva + 5;
					end if;
				end loop;
				NbAligneDiagonal := 0;
			end loop;
		end loop;
		Compteur := 0;

		-- Attribution des points sur l'alignement diagonal inversé
		for I in 1..(Hauteur - NombreAligne + 1) loop
			for J in 1..(Largeur - NombreAligne + 1) loop
				for K in 0..(NombreAligne-1) loop
					if E(I + (3-K), J + K) = NumeroJoueur then
						NbAligneDiagonalInverse := NbAligneDiagonalInverse + 1;
					else
						NbAligneDiagonalInverse := 0;
					end if;
					-- Si le coup nous permet d'avoir 3 pions alignés, on attribue +10
					if NbAligneDiagonalInverse = NombreAligne-1 then
						Eva := Eva +10;
					-- Si le coup nous permet d'avoir 2 pions alignés, on attribue +5
					elsif NbAligneDiagonalInverse = NombreAligne-2 then
						Eva := Eva + 5;
					end if;
				end loop;
				NbAligneDiagonalInverse := 0;
			end loop;
		end loop;
		return Eva;
	end Eval;

end Puissance4;

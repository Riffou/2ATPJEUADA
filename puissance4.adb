package body Puissance4 is

    -- Calcule l'etat suivant en appliquant le coup
    function Etat_Suivant(E : Etat; C : Coup) return Etat is
		I : Integer :=1;
	begin
		while I < Hauteur+1 and E(I,C.Colonne) = 0 loop
				I := I + 1;
		end loop;
		if I > Hauteur then
			put("Coup Impossible");
		else
			if C.J = Joueur1 then
				E(I,C.Colonne) = 1;
			else
				E(I,C.Colonne) = 2;
			end if;
		end if;
	end Etat_Suivant;

    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean; 
    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean; 
    -- Fonction d'affichage de l'etat courant du jeu
    procedure Affiche_Jeu(E : Etat);
    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup);   
    -- Retourne le prochaine coup joue par le joueur1
    function Coup_Joueur1(E : Etat) return Coup;
    -- Retourne le prochaine coup joue par le joueur2   
    function Coup_Joueur2(E : Etat) return Coup;  

end Puissance4;

generic
	Largeur : Integer;
	Hauteur : Integer;
	NombreAligne : Integer;

package Puissance4 is

	type Etat is array(1..Hauteur,1..Largeur) of Integer;
	for i in 1..Hauteur loop
	   for j in 1..Largeur loop
	      T(i,j) := 0 ; 
	   end loop ; 
	end loop ;

	type Coup is 
	record
		J : Joueur;
		Colonne : Integer; 
	end record ;


    -- Calcule l'etat suivant en appliquant le coup
    function Etat_Suivant(E : Etat; C : Coup) return Etat;
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

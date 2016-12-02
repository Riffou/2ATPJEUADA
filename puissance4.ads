with Ada.Text_IO; 
with Ada.Integer_Text_IO;
with Participant;
use Ada.Text_IO; 
use Ada.Integer_Text_IO;
use Participant;

generic
	Largeur : Integer;
	Hauteur : Integer;
	NombreAligne : Integer;

package Puissance4 is

	type Etat is array(1..Hauteur, 1..Largeur) of Integer;
	
	type Coup is record
		J : Joueur;
		Colonne : Integer;
	end record;
	
    -- Calcule l'etat suivant en appliquant le coup
    function Jouer(E : Etat; C : Coup) return Etat;
    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean; 
    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean; 
    -- Fonction d'affichage de l'etat courant du jeu
    procedure Afficher(E : Etat);
    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup);   
    -- Retourne le prochaine coup joue par le joueur1
    function Demande_Coup_Joueur1(E : Etat) return Coup;
    -- Retourne le prochaine coup joue par le joueur2   
    function Demande_Coup_Joueur2(E : Etat) return Coup;   

	procedure Initialiser (etat_initial : in out Etat);
	
end Puissance4;

-- liste_generique.adb
---------------------------------------------------------------

with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body liste_generique is

--===> GENERICITE: en fait il y en a ici: on instancie la deallocation
--                 avec les types adequats
	procedure Libere is new Ada.Unchecked_Deallocation (Cellule, Liste);
	procedure LibereIt is new Ada.Unchecked_Deallocation (Iterateur_Interne, Iterateur);


	function Creer_Liste return Liste is
	begin
	   return null;
	end Creer_Liste;


	procedure Libere_Liste(L : in out Liste) is
		Tmp : Liste;
	begin
		while L /= null loop
			Tmp := L;
			L := L.Suiv;
			Libere(Tmp);
		end loop;
	end Libere_Liste;


	procedure Affiche_Liste (L: in Liste) is
		Cour : Liste := L;
	begin
		while Cour /= null loop
--===> GENERICITE: utilise la procedure "Put" generique!
			Put(Cour.E);
			Put(" ");
			Cour := Cour.Suiv;
		end loop;
		New_Line;
	end Affiche_Liste;


	-- Insertion d'un element V en tete de liste
--===> GENERICITE: V de type "Element" generique
	procedure Insere_Tete (V: in Element; L: in out Liste) is
	begin
		L := new Cellule'(V, L);
	end Insere_Tete;

	-- Cree un nouvel iterateur
	function Creer_Iterateur (L : Liste) return Iterateur is
		It : Iterateur;
	begin
		if L = null then
			return null;
		else
			It.E := L.E;
			It.Next := L.Suiv;
			return It;
		end if;
	end Creer_Iterateur;

	-- Liberation d'un iterateur
	procedure Libere_Iterateur(It : in out Iterateur) is
	begin
		LibereIt(It);
	end Libere_Iterateur;

	-- Avance d'une case dans la liste
	procedure Suivant(It : in out Iterateur) is
	begin
		It.E := It.Next.E;
		It.Next := It.Next.Suiv;
	end Suivant;

	-- Retourne l'element courant
	function Element_Courant(It : Iterateur) return Element is
	begin
		return It.E;
	end Element_Courant;

	-- Verifie s'il reste un element a parcourir
	function A_Suivant(It : Iterateur) return Boolean is
	begin
		if It.Next = null then
			return false;
		else
			return true;
		end if;
	end A_Suivant;

end liste_generique;

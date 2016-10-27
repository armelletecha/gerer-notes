require 'csv'

module GestionDeNotes
require 'csv'
class Etudiant
	attr_reader :code
	attr_reader :nom
	attr_reader :prenom
	attr_accessor :notes
	attr_accessor :moyenne
	attr_accessor :cote

<<<<<<< HEAD
	def initialize(code, nom, prenom)
		@code = code
		@nom = nom
		@prenom = prenom
		@notes = {}
		@moyenne = 0
		@cote = 0
		
	end

	
	def enregistrer_note(code,id_devoir,note,tableau_etudiants,tableau_travaux)

#verifier que l id_devoir specifie existe
		tableau_travaux.each do |travail|
			existe_travail = true if travail.id === id_devoir
			existe_travail = false
		end

#inserer la note dans le tableau
		tableau_etudiants.each do |etudiant|
			etudiant.note[:id_devoir] = note if etudiant.code === code
			return " note enregistree "
		end
	end
=======
	def initialize (code, nom, prenom)
		@code = code
		@nom = nom
		@prenom = prenom 
		@notes = {}
		@moyenne = 0
		@cote = 0
	end

#Lecture du fichier CSV
	def lecture_csv(fichier)
	etudiants = Array.new  
	CSV.foreach(fichier) do |ligne|
	e = Etudiant.new(ligne[0], ligne[1], ligne[2])
	etudiants.push(e)
	puts e.nom
	end
	end	

#Fonctions pour enregistrer une note 
	def enregistrer_notes (code, note)
		end
>>>>>>> 448471eef4e79c2a249afb316060069176e8c56a

	def afficher 
		puts "code : " + @code.to_s + "Nom : " + @nom.to_s + "\nPrenom : " + @prenom.to_s + "\nNotes : " + @notes.to_s + "\nMoyenne :" + @moyenne.to_s + " \nCote : " + @cote.to_s + "\nRang centile : " + @rang_centile.to_s
	end
end


<<<<<<< HEAD



=======
a = Etudiant.new(22, "MAMA", "president")
a.lecture_csv('liste_etudiants_defaut.csv')
# a.afficher
end
>>>>>>> 448471eef4e79c2a249afb316060069176e8c56a

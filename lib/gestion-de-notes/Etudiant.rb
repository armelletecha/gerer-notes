require 'csv'

module GestionDeNotes

class Etudiant
	attr_reader :code
	attr_reader :nom
	attr_reader :prenom
	attr_accessor :notes
	attr_accessor :moyenne
	attr_accessor :cote

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

	def afficher 
		puts "code : " + @code.to_s + "Nom : " + @nom.to_s + "\nPrenom : " + @prenom.to_s + "\nNotes : " + @notes.to_s + "\nMoyenne :" + @moyenne.to_s + " \nCote : " + @cote.to_s + "\nRang centile : " + @rang_centile.to_s
	end
end


a = Etudiant.new(22, "MAMA", "president")
a.lecture_csv('liste_etudiants_defaut.csv')
# a.afficher
end
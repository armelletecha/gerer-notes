module GestionDeNotes
require 'csv'


  VERSION = '0.0.1'

class Etudiant
	attr_reader :code
	attr_reader :nom
	attr_reader :prenom
	attr_accessor :notes
	attr_accessor :moyenne
	attr_accessor :cote

	def initialize(code, nom, prenom)
		@code = code
		@nom = nom
		@prenom = prenom
		@notes = {}
		@moyenne = 0
		@cote = 0
		
	end
end

class Travail
	attr_reader :id_devoir
	attr_reader :nom_devoir
	attr_reader :ponderation
	attr_reader :corrige_sur
	

	def initialize( id,nom,ponderation,corrige_sur )
		@id_devoir = id
		@nom_devoir = nom
		@ponderation = ponderation
		@corrige_sur = corrige_sur
		
	end
end

#methode pour lire le fichier de description des etudiants

	def self.lecture_fichier(fichier)
		tableau_etudiants = Array.new
		CSV.foreach(fichier) do |ligne|
			etudiant = Etudiant.new(ligne[0],ligne[1],
                                             ligne[2])
			tableau_etudiants.push(etudiant)
		end
		return tableau_etudiants

	end

#methode pour lire le fichiers de description des travaux
	def self.lecture_fichier_cours(fichier)
		informations_cours = Array.new
		CSV.foreach(fichier) do |ligne|
			travail = Travail.new(ligne[0],ligne[1],
                                            ligne[2])
			informations_cours.push(travail)
		end
		return informations_cours
	end




#methode pour enregistrer la note d'un etudiant	
	def self.enregistrer_note( *args )
		tableau_etudiants = lecture_fichier('liste_etudiants_defaut_test.csv')
		tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')

#verifier que l id_devoir specifie existe
		tableau_travaux.each do |travail|
			existe_travail = true if travail.id_devoir === args[1]
			existe_travail = false
		end

#inserer la note dans le tableau
		tableau_etudiants.each do |etudiant|
			if existe_travail === true and etudiant.code === args[0] then
				etudiant.note[:args[1]] = args[2] 
				CSV.open('liste_etudiants_defaut_test.csv') do |csv_object|
					csv_object << args[2]
				end
				return " note enregistree "
			end
		end
			
	end

end


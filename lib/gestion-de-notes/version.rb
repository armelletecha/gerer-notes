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

	def initialize(code, nom, prenom, note, moyenne, cote)		
		
		@code = code
		@nom = nom
		@prenom = prenom
		@notes = {note.keys => note.values }
		@moyenne = moyenne
		@cote = cote
		
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
			puts ligne.inspect
			etudiant = Etudiant.new(ligne[0],ligne[1],
                                             ligne[2],ligne[3],ligne[4],ligne[5])
			tableau_etudiants.push(etudiant)
			#puts etudiant.inspect
		end
		return tableau_etudiants

	end

#methode pour lire le fichiers de description des travaux
	def self.lecture_fichier_cours(fichier)
		informations_cours = Array.new
		CSV.foreach(fichier) do |ligne|
			travail = Travail.new(ligne[0],ligne[1],
                                            ligne[2],ligne[3])
			informations_cours.push(travail)
		end
		return informations_cours
	end


#methode pour enregistrer la note d'un etudiant	
	def self.enregistrer_note( *args )
		existe = 0
		succes = 0
		fichier_Delete = 0
		nom_devoir = ''
		etud = Array.new
		tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
		tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')


	#verifier que l id_devoir specifie existe
		tableau_travaux.each do |travail|
			if travail.id_devoir == args[1] and travail.ponderation >= args[2] then
				existe = 1 
				nom_devoir = travail.nom_devoir
			end
		end
		

	#inserer la note dans le tableau
		tableau_etudiants.each do |etudiant|
			if existe == 1 and etudiant.code == args[0] then
				etudiant.notes[nom_devoir] = args[2] 
				succes = 1
			end
		
		end
		
		if succes == 1 then
			tableau_etudiants.each do |etudiant|
	#supprimer tout le contenu du fichier
				line_arr = CSV.readlines('liste_etudiants_defaut.csv')
				line_arr.delete(etudiant)
			end
			fichier_delete = 1
		end

		if fichier_delete == 1 then
			csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
			tableau_etudiants.each do |etudiant|

	#recreer le fichier avec la nouvelle valeur
				csv_object << [etudiant.code, etudiant.nom, etudiant.prenom, etudiant.notes,etudiant.moyenne,etudiant.cote]
			end
			csv_object.close
			
			return " note enregistree "
		else return "un probleme est survenu"
		end
			
	end

end

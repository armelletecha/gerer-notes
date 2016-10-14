module GestionNotes

class Etudiant
	attr_reader :code
	attr_reader :nom
	attr_reader :prenom
	attr_accessor :projet1
	attr_accessor :projet2
	attr_accessor :examen
	attr_accessor :moyenne
	attr_accessor :rang
	attr_accessor :cote

	etudiant = Array.new

	def initialize(code, nom, prenom, projet1, projet2, examen, moyenne, rang, cote)
		@code = code
		@nom = nom
		@prenom = prenom
		@projet1 = projet1
		@projet2 = projet2
		@examen = examen
		@moyenne = moyenne
		@rang = rang
		@cote = cote
	end


	def lecture_fichier1
		#definir un tableau pour contenir les informations de chaque etudiants

		

		#ouvrir le fichier csv
		CSV.foreach("BD_simplifiee-liste_etudiants.csv",{:headers => :first_row}) do |row|
			fields = row.split(',')
			e = Etudiant.new
			e.code = fields[0]
			e.nom = fields[1]
			e.prenom = fields[2]
			e.projet1 = fields[3]
			e.projet2 = fields[4]
			e.examen = fields[5]
			e.moyenne = fields[6]
			e.rang = fields[7]
			e.cote = fields[8]
			
		etudiant.push(e)
		end
		
	end


	
end

tableau = array.new
tableau.foreach do |x|
	x = 


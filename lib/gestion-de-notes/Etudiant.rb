module GestionDeNotes

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
end
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

	def self.enregistrer_note(code,idDevoir,note)
	#code = code permanent de l etudiant 
	#idDevoir = code du devoir
	#note = note de l etudiant
		etudiant = Array.new
		etudiant.each do |x|
			if x[0][j] === code do
				x[3][j] = note if x[3][0] === idDevoir
				x[4][j] = note if x[4][0] === idDevoir
				x[5][j] = note if x[5][0] === idDevoir
			end
		end
	t = "enregistre"
	return t
	end

end
end


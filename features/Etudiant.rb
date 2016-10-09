class Etudiant
	attr_reader :code
	attr_reader :nom
	attr_reader :prenom
	attr_reader :projet1
	attr_reader :projet2
	attr_reader :examen
	attr_reader :moyenne
	attr_reader :rang
	attr_reader :cote


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

	def enregistrer_note(code,idDevoir,note)
	#code = code permanent de l etudiant 
	#idDevoir = code du devoir
	#note = note de l etudiant
	end

	def moyenne
	end

	def calculer_cote
	end

	def calculer_rang
	end


	def afficher_informations
	end

end

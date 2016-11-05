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
		@notes = note
		@moyenne = moyenne
		@cote = cote
		
	end
end






module GestionDeNotes
require 'csv'
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
end





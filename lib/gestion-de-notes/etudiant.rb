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

	
	def self.enregistrer_note(code,id_devoir,note,tableau_etudiants,tableau_travaux)

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

end
end






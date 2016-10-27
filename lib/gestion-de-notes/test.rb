require 'csv'

#def lecture_fichier(fichier)
		tableau = Array.new
		CSV.foreach('liste_etudiants_defaut.csv') do |ligne|
			
			etudiant = Array.new
			etudiant.push(ligne[0])
			etudiant.push(ligne[1])
			etudiant.push(ligne[2])
			tableau.push(etudiant)
		end
		puts tableau
		
	#end

#lecture_fichier('liste_etudiants_defaut.csv')


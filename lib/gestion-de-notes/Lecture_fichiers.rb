module GestionDeNotes

#methode pour lire le fichier de description des etudiants
	def lecture_fichier(fichier)
		tableau_etudiants = Array.new
		tableau_etudiants2 = Array.new
		CSV.foreach(fichier) do |ligne|
			etudiant = Etudiant.new(ligne[0],ligne[1],ligne[2])
			tableau_etudiants2.push(etudiant) if fichier != 'liste_etudiants_defaut.csv'
			tableau_etudiants.push(etudiant)
		end
		return tableau_etudiants2 if fichier != 'liste_etudiants_defaut.csv'
		return tableau_etudiants

	end

#methode pour lire le fichiers de description des travaux
		def lecture_fichier_cours(fichier)
			informations_cours = Travail.new
			informations_cours2 = Travail.new
			CSV.foreach(fichier) do |ligne|
				travail = Array.new(ligne[0],ligne[1],ligne[2])
				informations_cours2.push(etudiant) if fichier != 'informations_cours_defaut.csv'
				informations_cours.push(etudiant)
			end
			return informations_cours2 if fichier != 'liste_etudiants_defaut.csv'
			return informations_cours

	end

end

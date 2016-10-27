module GestionDeNotes

#methode pour lire le fichier de description des etudiants
	def self.lecture_fichier(fichier)
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
		def self.lecture_fichier_cours(fichier)
			informations_cours = Array.new
			informations_cours2 = Array.new
			CSV.foreach(fichier) do |ligne|
				#travail = Travail.new (ligne[0],ligne[1],ligne[2],ligne[3])
				informations_cours2.push(travail) if fichier != 'informations_cours_defaut.csv'
				informations_cours.push(travail)
			end
			return informations_cours2 if fichier != 'informations_cours_defaut.csv'
			return informations_cours

	end

end

module GestionDeNotes
require 'csv'

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

#methode pour enregistrer la note d'un etudiant 
  def self.enregistrer_note( *args )
    existe = 0
    succes = 0
    fichier_Delete = 0
    nom_devoir = ''
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut.csv')

  #verifier que l id_devoir specifie existe
    tableau_travaux.each do |travail|
      if travail.id_devoir == args[1] and travail.note_max >= args[2] then
        existe = 1 
        nom_devoir = travail.nom_devoir
      end
    end

    puts "Le devoir n\'existe pas ou la note de l\'etudiant est superieur a la note maximum " if existe == 0

  #inserer la note dans le tableau des etudiants
    tableau_etudiants.each do |etudiant|
      if existe == 1 and etudiant.code == args[0] then
        etudiant.notes[nom_devoir] = args[2] 
        succes = 1
        puts "l\'etudiant " + etudiant.nom + " " + etudiant.prenom + 
            " de matricule " + args[0] + 
            " a obtenu la note de " + args[2] + 
            " pour " + nom_devoir
      end
    end
    
  #supprimer tout le contenu du fichier si on a insere la note dans le tableau
    if succes == 1 then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end

  #Remplir le fichier avec le nouveau tableau_etudiants qui a été précédemment modifié 
      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
      csv_object << ["code_permanent","nom","prenom","notes,moyenne","cote"]
      tableau_etudiants.each do |etudiant|
        csv_object << [etudiant.code, 
                      etudiant.nom, 
                      etudiant.prenom, 
                      etudiant.notes,
                      etudiant.moyenne,
                      etudiant.cote]
      end
      
      return " Note enregistree avec succes"
    else 
      return "Un probleme est survenu"
    end
  end

#Calculer la moyenne de chaque étudiant de la classe
  def self.moyenne_etudiants
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut.csv')
    i = 0
  #calculer la moyenne de chaque etudiant
    tableau_etudiants.each do |etudiant|
      somme_ponderation = 0
      note_ponderee = 0
      tableau_notes = etudiant.notes
      tableau_notes.each do |key, value|
        tableau_travaux.each do |travail|
          if key == travail.nom_devoir then
            note_ponderee = note_ponderee + value.to_f * 100 * travail.ponderation.to_f / travail.note_max.to_f
            somme_ponderation = somme_ponderation + travail.ponderation.to_f
          end
        end
      end

      puts "oups!! une erreur est survenue" if somme_ponderation == 0
      etudiant.moyenne = note_ponderee / somme_ponderation
      i+=1
      puts "L\'etudiant " +etudiant.code+ 
            " a obtenu une moyenne finale de " +etudiant.moyenne    
    end

  #modifier le fichier CSV pour inserer la moyenne de chaque etudiant
    if tableau_etudiants.length == i then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end
      #Remplir le fichier après l'avoir ouvert avec les nouvelles valeurs du tableau_etudiants 
      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
        csv_object << ["code_permanent","nom","prenom","notes,moyenne","cote"]
        tableau_etudiants.each do |etudiant|
          csv_object << [etudiant.code, 
                        etudiant.nom, 
                        etudiant.prenom, 
                        etudiant.notes,
                        etudiant.moyenne,
                        etudiant.cote]
        end
      
      return "Les moyennes ont ete calculees avec succes!"
    else 
      return "Oups!! Une erreur s'est produite !!"
    end
  end

#fonction pour attribuer les cotes
  def self.attribuer_cote
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    moyenne_de_la_classe = GestionDeNotes.moyenne_classe
    succes = 0
    tableau_etudiants.each do |etudiant|
      succes = 0 if etudiant.moyenne.to_f <= 0.0 and etudiant.moyenne.to_f >= 100.0
      etudiant.cote = "A" if etudiant.moyenne.to_f <= 100.0 and etudiant.moyenne.to_f >= 85.0
      etudiant.cote = "A-" if etudiant.moyenne.to_f <= 84.0 and etudiant.moyenne.to_f >= 80.0
      etudiant.cote = "B+" if etudiant.moyenne.to_f <= 79.0 and etudiant.moyenne.to_f >= 75.0
      etudiant.cote = "B" if etudiant.moyenne.to_f <= 74.0 and etudiant.moyenne.to_f >= 70.0
      etudiant.cote = "E" if etudiant.moyenne.to_f < 70.0
      succes = 1
      puts "L\'etudiant " +etudiant.code+ " a obtenu la cote " +etudiant.cote
    end

  #modifier le fichier pour inserer les cotes de chaque etudiant
    if succes == 1 then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end

      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
        csv_object << ["code_permanent","nom","prenom","notes,moyenne","cote"]
        tableau_etudiants.each do |etudiant|
          csv_object << [etudiant.code, etudiant.nom, etudiant.prenom, etudiant.notes,etudiant.moyenne,etudiant.cote]
        end
      return "Cote enregistree"
    else 
      return "Erreur"
    end
  end


end




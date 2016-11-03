module GestionDeNotes

require 'csv'

  VERSION = '0.0.1'

#Classe Etudiant qui  modelise les etudiants de la classe
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

#Classe travail qui modelise les travaux d evaluation des etuidants
class Travail
  attr_reader :id_devoir
  attr_reader :nom_devoir
  attr_reader :ponderation
  attr_reader :note_max
  
  def initialize( id,nom,ponderation,note_max )
    @id_devoir = id
    @nom_devoir = nom
    @ponderation = ponderation
    @note_max = note_max
  end
end

#Convertir un string en hash
  def self.convert_to_hash(var_string)
    tableau = Array.new
    tableau = var_string.split("\"")
    tableau = tableau.join
    tableau = tableau.split("{")
    tableau = tableau[1].split("}")
    tableau = tableau[0].split(",")
    tableau.shift if tableau[0] == "=>nil"
    tableau = tableau.join
    var_hash = Hash[tableau.split(" ").map{|str| str.split("=>")}]
    return var_hash
  end

#Lecture du fichier description de cours 
  def self.lecture_fichier(fichier)
    first = true
    tableau_etudiants = Array.new
    CSV.foreach(fichier) do |ligne|
      if first then
        first = false
      else
        ligne[3] = "{} " if ligne[3] == "{}"
        inconnu = convert_to_hash(ligne[3])
        etudiant = Etudiant.new(ligne[0],
                                ligne[1],
                                ligne[2],
                                inconnu,
                                ligne[4],
                                ligne[5])

        tableau_etudiants.push(etudiant)
      end   
    end
    return tableau_etudiants
  end

#Lecture du fichier description des travaux
  def self.lecture_fichier_cours(fichier)
    informations_cours = Array.new
    csv_contents = CSV.read(fichier)
    csv_contents.shift
    csv_contents.shift
    csv_contents.shift
    csv_contents.shift
    csv_contents.shift

    csv_contents.each do |ligne|
      travail = Travail.new(ligne[0],
                            ligne[1],
                            ligne[2],
                            ligne[3])
      informations_cours.push(travail)

    end
    return informations_cours
  end


#Enregistrer la note d'un etudiant 
  def self.enregistrer_note( *args )
    existe = 0
    succes = 0
    fichier_Delete = 0
    nom_devoir = ''
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')

  #Verifier que l identifiant du devoir existe
    tableau_travaux.each do |travail|
      if travail.id_devoir == args[1] and travail.note_max >= args[2] then
        existe = 1 
        nom_devoir = travail.nom_devoir
      else 
        puts "Le devoir n\'existe pas ou la note de l\'etudiant est superieur a la note maximum "
      end
    end

  #Inserer la note dans le tableau des etudiants
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

  #Si la note a été inséré dans le tableau, supprimer le tableau
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
  #Lecture des fichiers par défaut
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')
    i = 0
  #Calculer la moyenne
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
  #Modifier le fichier CSV pour inserer la moyenne de chaque etudiant
  #Supprimer le contenu du fichier
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

#Calculer la moyenne de la classe
#a refaire, on doit utiliser reduce
  def self.moyenne_classe
    #Lecture du fichier liste etudiants 
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    #Faire la somme de la moyenne des etudiants de la classe
    somme = 0
    compteur = 0  
    succes = 0
    tableau_etudiants.each do |etudiant|
      somme  += etudiant.moyenne.to_f
      compteur+=1
      succes = 1
    end
    #Diviser la somme par le nombre d'etudiants
    moyenne = somme / compteur
    puts "la moyenne de la classe est "

    if succes == 1 then
      tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')
      tableau_travaux.each do |travail|
        line_arr = CSV.readlines('informations_cours_defaut_test.csv')
        line_arr.delete(travail)
      end
      csv_object = CSV.open('informations_cours_defaut_test.csv', "r+")
      csv_object << ["sigle du cours","MGL7460"]
      csv_object << ["nom du professeur","Guy Tremblay"]
      csv_object << ["numero du groupe","1"]
      csv_object << ["",""]
      csv_object << ["moyenne",moyenne]

      tableau_travaux.each do |travail|
        csv_object << [travail.id_devoir, 
                      travail.nom_devoir, 
                      travail.ponderation, 
                      travail.note_max]
      end
      return moyenne
    else 
      return "Oups!! erreur quelque part"
    end  
  end

#fonction pour attribuer les cotes
  def self.attribuer_cote
    #Ouverture du fichier contenant les informations des etudiants 
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    #Récupération de la moyenne de la classe 
    moyenne_de_la_classe = GestionDeNotes.moyenne_classe
    succes = 0
    #Definition et attribution des cotes
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

  #Modifier le fichier pour inserer les cotes de chaque etudiant
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

  #afficher les informations de la classe
  def self.afficher
    CSV.foreach('informations_cours_defaut.csv') do |ligne|
      puts ligne.inspect
    end

    CSV.foreach('liste_etudiants_defaut.csv') do |ligne|
      puts ligne.inspect
    end   
  end

end
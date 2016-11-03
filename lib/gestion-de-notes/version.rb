module GestionDeNotes
require 'csv'
  VERSION = '0.0.1'
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
#methode pour lire le fichier de description des etudiants
  def self.lecture_fichier(fichier)
    tableau_etudiants = Array.new
    CSV.foreach(fichier) do |ligne|
      ligne[3] = "{} " if ligne[3] == "{}"
      inconnu = convert_to_hash(ligne[3])
      etudiant = Etudiant.new(ligne[0],ligne[1],ligne[2],
            inconnu,ligne[4],ligne[5])
      tableau_etudiants.push(etudiant)
      
    end
    return tableau_etudiants
  end
#methode pour lire le fichiers de description des travaux
  def self.lecture_fichier_cours(fichier)
    informations_cours = Array.new
    CSV.foreach(fichier) do |ligne|
      travail = Travail.new(ligne[0],ligne[1],
                                            ligne[2],ligne[3])
      informations_cours.push(travail)
    end
    return informations_cours
  end
#methode pour ecrire dans un fichier
  def self.ecriture_fichier(fichier)
    #lire le fichier
    tableau_fichier = lecture_fichier(fichier)
    #supprimer tout le contenu du fichier
    tableau_fichier.each do |element|
      line_arr = CSV.readlines(fichier)
      line_arr.delete(element)
    end
    #ouvrir et ecrire dans le fichier
    csv_object = CSV.open(fichier, "r+")
    tableau_fichier.each do |element|
      csv_object << element
    end
    csv_object.close
  end
#methode pour enregistrer la note d'un etudiant 
  def self.enregistrer_note( *args )
    existe = 0
    succes = 0
    fichier_Delete = 0
    nom_devoir = ''
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')
  #verifier que l id_devoir specifie existe
    tableau_travaux.each do |travail|
      if travail.id_devoir == args[1] and travail.note_max >= args[2] then
        existe = 1 
        nom_devoir = travail.nom_devoir
      end
    end
  #inserer la note dans le tableau des etudiants
    tableau_etudiants.each do |etudiant|
      if existe == 1 and etudiant.code == args[0] then
        etudiant.notes[nom_devoir] = args[2] 
        succes = 1
        puts "l\'etudiant " + etudiant.nom + " " + etudiant.prenom + " de matricule " + args[0] + " a obtenu la note de " + args[2] + " pour " + nom_devoir
      end
    
    end
  #supprimer tout le contenu du fichier si on a insere la note dans le tableau
    if succes == 1 then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end
  #ecrire dans le fichier
      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
      tableau_etudiants.each do |etudiant|
        csv_object << [etudiant.code, etudiant.nom, etudiant.prenom, etudiant.notes,etudiant.moyenne,etudiant.cote]
      end
      
      return " note enregistree avec succes"
    else return "un probleme est survenu"
    end
      
  end
  def self.moyenne_etudiants
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')
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
      etudiant.moyenne = note_ponderee / somme_ponderation
      i+=1
      puts "l\'etudiant " +etudiant.code+ " a obtenu une moyenne finale de " +etudiant.moyenne    
    end
  #modifier le fichier CSV pour inserer la moyenne de chaque etudiant
    if tableau_etudiants.length == i then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end
      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
        tableau_etudiants.each do |etudiant|
          csv_object << [etudiant.code, etudiant.nom, etudiant.prenom, etudiant.notes,etudiant.moyenne,etudiant.cote]
        end
      
      return "moyennes calculees avec succes!"
    else return "oups!! erreur quelque part"
    end
  end
#calculer la moyenne de la classe
#a refaire, on doit utiliser reduce
  def self.moyenne_classe
    tableau_etudiants = lecture_fichier('liste_etudiants_defaut.csv')
    somme = 0
    compteur = 0  
    succes = 0
    tableau_etudiants.each do |etudiant|
      somme  += etudiant.moyenne.to_f
      compteur+=1
      succes = 1
    end
    moyenne = somme / compteur
    puts "la moyenne de la classe est "
#a remplacer par la fonction d'ecriture
    if succes == 1 then
      tableau_travaux = lecture_fichier_cours('informations_cours_defaut_test.csv')
      tableau_travaux.each do |travail|
        line_arr = CSV.readlines('informations_cours_defaut_test.csv')
        line_arr.delete(travail)
      end
      csv_object = CSV.open('informations_cours_defaut_test.csv', "r+")
      tableau_travaux.each do |travail|
        csv_object << [travail.id_devoir, travail.nom_devoir, travail.ponderation, travail.note_max]
      end
      csv_object << ["",""]
      csv_object << ["moyenne",moyenne]
      
      return moyenne
    else return "oups!! erreur quelque part"
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
      puts "l\'etudiant " +etudiant.code+ " a obtenu la cote " +etudiant.cote
    end
  #modifier le fichier pour inserer les cotes de chaque etudiant
    if succes == 1 then
      tableau_etudiants.each do |etudiant|
        line_arr = CSV.readlines('liste_etudiants_defaut.csv')
        line_arr.delete(etudiant)
      end
      csv_object = CSV.open('liste_etudiants_defaut.csv', "r+")
        tableau_etudiants.each do |etudiant|
          csv_object << [etudiant.code, etudiant.nom, etudiant.prenom, etudiant.notes,etudiant.moyenne,etudiant.cote]
        end
      return "cote calculee et enregistree avec succes"
    else return "error"
    end
  end
end
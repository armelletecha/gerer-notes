module GestionDeNotes
require 'csv'

class << self
    attr_accessor :fichier_etudiants
    attr_accessor :fichier_cours
    attr_accessor :seuil_cote
  end

#*********methode pour enregistrer la note d'un etudiant**********

#****************************************************************


  def self.enregistrer_note( *args )

    #initialisation des variables
    existe = 0
    succes = 0
    fichier_Delete = 0
    nom_devoir = ''
    tableau_sortie = Array.new

    #lecture du fichier
     tableau_etudiants = LectureEcriture.lecture_fichier(fichier_etudiants)
    tableau_travaux = LectureEcriture.lecture_fichier_cours(fichier_cours)

  #traitement
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
      	succes = 1
        etudiant.notes[nom_devoir] = args[2]
        tableau_sortie.push(etudiant) 
        
      end
    end

    tableau_sortie.push(nom_devoir)
    tableau_sortie.push(succes)
#ecrire dans le fichier
    LectureEcriture.ecriture_fichier(tableau_etudiants,
           fichier_etudiants) if succes == 1
    return tableau_sortie
  end


#***************Calculer la moyenne de chaque étudiant de la classe*******

#*************************************************************************

  def self.moyenne_etudiants

#initialisation des variables
    i = 0
    reponse = 0
    etudiants_moyenne_pas_calculee = Array.new
    etudiants_moyenne_calculee = Array.new
    tableau_sortie = Array.new

  #lecture des fichiers
    tableau_etudiants = LectureEcriture.lecture_fichier(fichier_etudiants)
    tableau_travaux = LectureEcriture.lecture_fichier_cours(fichier_cours)
    
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

      if somme_ponderation == 0 || somme_ponderation != 100 then
        etudiants_moyenne_pas_calculee.push(etudiant)
      else
      	etudiant.moyenne = note_ponderee / somme_ponderation
        etudiants_moyenne_calculee.push(etudiant)
      	i+=1
        LectureEcriture.ecriture_fichier(tableau_etudiants,
           fichier_etudiants)
      end  
    end

    reponse = 1 if tableau_etudiants.length == i
    tableau_sortie << reponse
    tableau_sortie.push(etudiants_moyenne_pas_calculee)
    tableau_sortie.push(etudiants_moyenne_calculee)
    return tableau_sortie
  end
  

#******************fonction pour attribuer les cotes**************************************

#******************************************************************************************

  def self.attribuer_cote
    
    #initialisation
    tableau_sortie1 = Array.new
    value = 1
    tableau_cote = seuil_cote.split(',')

    #lecture fichier
    tableau_etudiants = LectureEcriture.lecture_fichier(fichier_etudiants)

    #verifier que tableau_cote contient 04 valeurs
    value = 0 unless tableau_cote.length == 4

    #verifier que les valeurs de tableau_cote sont rangees en ordre croissant
    indice = tableau_cote.length - 1
    tableau_cote.each_index do |i|
      value = 0 if tableau_cote[i].to_f < tableau_cote[i+1].to_f and i < indice
    end

    #traitement
    if value == 0 then
      tableau_sortie1.push(0)
    else
      tableau_etudiants.each do |etudiant|
        etudiant.cote = "A" if etudiant.moyenne.to_f <= 100.0 and etudiant.moyenne.to_f >= tableau_cote[0].to_f
        etudiant.cote = "A-" if etudiant.moyenne.to_f <= tableau_cote[0].to_f and etudiant.moyenne.to_f >= tableau_cote[1].to_f
        etudiant.cote = "B+" if etudiant.moyenne.to_f <= tableau_cote[1].to_f and etudiant.moyenne.to_f >= tableau_cote[2].to_f
        etudiant.cote = "B" if etudiant.moyenne.to_f <= tableau_cote[2].to_f and etudiant.moyenne.to_f >= tableau_cote[3].to_f
        etudiant.cote = "E" if etudiant.moyenne.to_f < tableau_cote[3].to_f and etudiant.moyenne.to_f >= 0.0
        tableau_sortie1.push(etudiant)
      end
    end
    LectureEcriture.ecriture_fichier(tableau_etudiants,
                                     fichier_etudiants)
    return tableau_sortie1

  end

#************************calculer la moyenne de la classe**********************************

#********************************************************************************************
def self.moyenne_classe
    tableau_etudiants = LectureEcriture.lecture_fichier(fichier_etudiants)
    somme = 0
    compteur = 0  
    tableau_etudiants.each do |etudiant|
      somme  += etudiant.moyenne.to_f
      compteur+=1
    end

    #Diviser la somme par le nombre d'etudiants
    moyenne = somme / compteur
    tableau_travaux = LectureEcriture.lecture_fichier_cours(fichier_cours)
    LectureEcriture.ecriture_fichier_cours(tableau_travaux,moyenne,fichier_cours)
    return moyenne
  end



  #********************************afficher les informations de la classe*************************************

  #**********************************************************************************************************
def self.afficher
    tab1 = Array.new
    CSV.foreach(fichier_cours) do |ligne|
      tab1.push(ligne)
    end

    CSV.foreach(fichier_etudiants) do |ligne|
      tab1.push(ligne)
    end 
    return tab1  
  end

end

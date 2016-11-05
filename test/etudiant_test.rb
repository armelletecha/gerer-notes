require 'test_helper'
require File.join(File.expand_path(File.dirname(__FILE__)), 'fonctionnalites.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), 'etudiant.rb')

class TestGestionDeNotes < Minitest::Test

  def setup
    etudiant = Etudiant.new("TENA27589002","Tenekeu","Armelle",{"projet1" => "30"},0,0)
    @tableau2 = Array.new(etudiant,"projet1",1)
  end

  describe "#enregistrer_note" do
    it "enregistre la note d un etudiant pour un devoir et retourne un tableau contenant les informations de l etudiant et le nom du devoir et 1" do
      GestionDeNotes.enregistrer_note("TENA27589002",1,30).must_equal @tableau2
    end
  end

end


=begin
describe Etudiant do
  let tableau1 = Array.new("TENA27589002","Tenekeu","Armelle",{"projet1" => "30"},0,0)
  let tableau2 = Array.new(tableau1,"projet1",1)


  describe "initialiser un etudiant" do
    it "retourne un tableau quand la note a ete enregistre" do
      GestionDeNotes.enregistrer_note("TENA27589002",1,30).nom.must_equal tableau2
    end
  end
end
=end


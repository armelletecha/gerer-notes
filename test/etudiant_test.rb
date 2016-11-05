require 'test_helper'
=begin
require_relative 'enregistrer_note'

describe "enregistrer_note" do
  it "retourne le message Note enregistree avec succes quand la note a ete enregistre" do
    enregistrer_note("TENA27589002",1,30).must_equal "Note enregistree avec succes"
  end
end
=end
class GestionDeNotesTest < Test::Unit::TestCase

def test_enregistrer_note 
	etudiant_test = Etudiant.new("TENA27589002", "Tenekeu", "Armelle",0,0,0)
	assert_equal(etudiant_test.code,"TENA27589002")
end
end

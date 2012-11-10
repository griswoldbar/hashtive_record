require 'spec_helper'

describe "HashtiveRecord::Reflection" do
  let(:reflection) { HashtiveRecord::Reflection.new }
  
  describe ".new" do
    it "initializes various readers" do
      reflection.columns.should == []
      reflection.has_manys.should == {}
      reflection.belongs_tos.should == {}
    end
  end
  
  describe "#add_columns" do
    it "adds the column names to its columns attribute" do
      reflection.add_columns(:plop, :wibble)
      reflection.columns.should == [:plop, :wibble]
      reflection.add_columns(:arf)
      reflection.columns.should == [:plop, :wibble, :arf]
    end
  end
  
  describe "add_belongs_to" do
    it "adds the belongs_to names to its belongs_tos attribute" do
      reflection.add_belongs_to(:thing)
      reflection.belongs_tos.should == { thing: {id: :thing_id, polymorphic: false} }
      reflection.add_belongs_to(:person, as: :owner)
      reflection.belongs_tos.should == { thing: {id: :thing_id, polymorphic: false},
                                         person: {id: :owner_id, polymorphic: false}}
      reflection.add_belongs_to(:place, as: :home, polymorphic: true)
      reflection.belongs_tos.should == { thing:  {id: :thing_id, polymorphic: false},
                                         person: {id: :owner_id, polymorphic: false},
                                         place:  {id: :home_id, polymorphic: true}}
    end
  end
  

end
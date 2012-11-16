require 'spec_helper'

describe "HashtiveRecord::Reflection" do
  let(:klass) { mock 'klass' }
  let(:reflection) { HashtiveRecord::Reflection.new(klass) }
  
  before(:each) do
    klass.stub(:to_s).and_return("Wibble")
  end
  
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
  
  describe "#add_belongs_to" do
    it "adds the belongs_to names to its belongs_tos attribute" do
      reflection.add_belongs_to(:thing)
      reflection.belongs_tos.should == { thing: {id: :thing_id, class_name: :thing,  polymorphic: false} }
      reflection.add_belongs_to(:owner, class_name: :person)
      reflection.belongs_tos.should == { thing: {id: :thing_id, class_name: :thing,  polymorphic: false},
                                         owner: {id: :owner_id, class_name: :person, polymorphic: false}}
      reflection.add_belongs_to(:home, polymorphic: true)
      reflection.belongs_tos.should == { thing: {id: :thing_id, class_name: :thing,  polymorphic: false},
                                         owner: {id: :owner_id, class_name: :person, polymorphic: false},
                                         home:  {id: :home_id,  class_name: :home,   polymorphic: true}}
    end
  end
  
  describe "#adds_has_many" do
    it "adds the has_many" do
      reflection.add_has_many(:flakes)
      reflection.has_manys.should == { flakes: {foreign_key: :wibble_id, class_name: :flake }}
      reflection.add_has_many(:shapes, foreign_key: :blah_id)
      reflection.has_manys.should == { flakes: {foreign_key: :wibble_id, class_name: :flake},
                                      shapes: {foreign_key: :blah_id, class_name: :shape} }
      reflection.add_has_many(:slaves, class_name: :minion, foreign_key: :master_id)
      reflection.has_manys.should == { flakes: {foreign_key: :wibble_id, class_name: :flake},
                                      shapes: {foreign_key: :blah_id, class_name: :shape},
                                      slaves: {foreign_key: :master_id, class_name: :minion} }                              
    end
  end
  
  describe "#accessors" do
    before(:each) do
      reflection.add_columns(:plop, :wibble)
      reflection.add_belongs_to(:thing)
      reflection.add_belongs_to(:owner, class_name: :person)
      reflection.add_belongs_to(:home, polymorphic: true)
      reflection.add_has_many(:flakes)
      reflection.add_has_many(:shapes, foreign_key: :blah_id)
      reflection.add_has_many(:slaves, class_name: :minion, foreign_key: :master_id)
    end
    
    it "returns all the methods it allows" do
      reflection.accessors.should =~ [:plop, :plop=,
                                      :wibble, :wibble=,
                                      :thing_id, :thing_id=,
                                      :owner_id, :owner_id=,
                                      :home_id, :home_id=,:home_type, :home_type=,
                                      :flakes,
                                      :shapes,
                                      :slaves
                                      ]
    end
  end
  

end
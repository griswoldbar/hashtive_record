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
      reflection.belongs_tos.should == { thing: {id: :thing_id, polymorphic: false} }
      reflection.add_belongs_to(:person, as: :owner)
      reflection.belongs_tos.should == { thing: {id: :thing_id, polymorphic: false},
                                         person: {id: :owner_id, polymorphic: false}}
      reflection.add_belongs_to(:home, polymorphic: true)
      reflection.belongs_tos.should == { thing:  {id: :thing_id, polymorphic: false},
                                         person: {id: :owner_id, polymorphic: false},
                                         home:  {id: :home_id, polymorphic: true}}
    end
  end
  
  describe "#adds_has_many" do
    it "adds the has_many" do
      reflection.add_has_many(:flakes)
      reflection.has_manys.should == { flakes: {id: :wibble_id }}
      reflection.add_has_many(:shapes, as: :blah)
      reflection.has_manys.should == { flakes: {id: :wibble_id},
                                       shapes: {id: :blah_id} }
    end
  end
  
  describe "#accessors" do
    before(:each) do
      reflection.add_columns(:plop, :wibble)
      reflection.add_belongs_to(:thing)
      reflection.add_belongs_to(:person, as: :owner)
      reflection.add_belongs_to(:home, polymorphic: true)
      reflection.add_has_many(:flakes)
      reflection.add_has_many(:shapes, as: :blah)
    end
    
    it "returns all the methods it allows" do
      reflection.accessors.should =~ [:plop, :plop=,
                                      :wibble, :wibble=,
                                      :thing_id, :thing_id=,
                                      :owner_id, :owner_id=,
                                      :home_id, :home_id=,:home_type, :home_type=,
                                      :flakes,
                                      :shapes
                                      ]
    end
  end
  

end
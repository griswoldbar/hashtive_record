require 'spec_helper'
require 'support/test_classes'

describe "HashtiveRecord::Base" do
  let(:hash)     { {:wibble => { name: "Billy", age: 12}}  }
  let(:record)   { build(:record, hash: hash )  }
  let(:pet_record) { build(:record, hash: { jekyll: {name: "Jekyll"}})}
  let(:people)   { build(:table, id: :people, records: [record]) }
  let(:animals)  { build(:table, id: :animals) }
  let(:database) { build(:database, tables: [people, animals]) }
  let(:person)   { Person.instantiate(record) }
  let(:pet)      { Pet.instantiate(pet_record) }
  
  before(:each) do    
    HashtiveRecord::Base.database = database
  end
  
  describe "class methods" do
    describe ".database" do
      it "inherits its database" do
        Person.database.should == database
      end
    end

    describe ".table" do
      it "dynamically sets its tablename and table if not explicitly set" do
        Person.table_name.should == :people
        Person.table.should == people
      end
    end

    describe ".instantiate" do
      it "instantiates based on a record" do
        person.record.should == record
      end
      
      it "extends the instance if it has modifiers" do
        module Slappable;end
        Person.any_instance.stub(:modifier_modules).and_return [:slappable]
        p = Person.instantiate(record)
        p.singleton_class.included_modules.should include Slappable
      end
    end
    
    describe ".build" do
      before { Person.stub(:accessors).and_return([:name, :age])}
      it "creates a new instance with its own record and removes bad accessors" do
        person = Person.build(:elvis, name: "Elvis", age: 55, fave_colour: "blue")
        person.name.should == "Elvis"
        person.age.should == 55
        person.should_not respond_to :fave_colour
        person = Person.find(:elvis)
        person.name.should == "Elvis"
        person.age.should == 55
      end
    end

    describe ".find" do
      it "finds the relevant object from the table" do
        Person.stub(:accessors).and_return([:name])
        Person.find(record.id).name.should == "Billy"
      end

      it "returns nil if nothing is found" do
        Person.find(:bibbleblob).should == nil
      end
    end

    describe ".find_by" do
      it "finds by the given attribute" do
        Person.stub(:accessors).and_return([:name])
        Person.find_by(name: "Billy").each {|person| person.name.should == "Billy" }
      end
    end
    
    describe ".method_missing" do
      it "searches for a record with that name" do
        Person.wibble.instance_variables.should == person.instance_variables
      end
    end

    describe ".all" do
      let(:person2) { build(:record, hash: {dork: { name: "Dorkus"}}) }
      before { people << person2 }

      it "returns an array of all instances" do
        pop = Person.all
        pop.count.should == 2
        pop.each {|person| person.should be_a Person}
      end
    end
    
    describe ".belongs_to" do    
      it "establishes a belongs to relationship" do
        Pet.belongs_to(:person)
        pet.should respond_to :person
        pet.should respond_to :person=
      end
    end
    
    describe ".has_many" do    
      it "establishes a has_many to relationship" do
        Person.has_many(:pets)
        person.should respond_to :pets
      end
    end
    
    
    describe ".columns" do
      it "adds them to its reflection" do
        Pet.reflection.should_receive(:add_columns).with(:favourite_food, :name)
        Pet.columns :favourite_food, :name
      end
    end
    
    describe ".reflection" do
      before do
        class Wonker < HashtiveRecord::Base;end
      end
      it "has one" do
        Wonker.reflection.should be_a HashtiveRecord::Reflection
      end
      
      it "knows who owns it" do
        Wonker.reflection.owner_type.should == :wonker
      end
    end
    
    describe ".accessors" do
      it "gets them from the reflection" do
        Pet.reflection.should_receive(:accessors).and_return([:poop, :plop])
        Pet.accessors.should == [:poop, :plop]
      end
    end
    
  end
  
  describe "instance methods" do
    
    describe "#add_modifier" do
      before(:each) do
        module Wibblable; end
      end
      
      it "adds the extension to its modifiers if not already present" do
        person.add_modifier(:wibblable)
        person.record.modifiers.marshal_dump.keys.should include(:wibblable)
        person.singleton_class.included_modules.should include(Wibblable)
      end
    end
    describe "#method_missing" do
      
      it "does not delegate to the record if the attribute is not recognised" do
        person.record.should_not_receive(:cack)
        expect {person.cack}.to raise_error
      end
      
      it "does delegate if the attribute is recognised" do
        Person.stub(:accessors).and_return([:cack])
        person.record.should_receive(:cack)
        person.cack
      end
      
    end
  end  
  
  describe "#==" do
    it "returns true when objects have the same id" do
      pet2 = Pet.instantiate(pet_record)
      pet.should == pet2
    end
  end
end
require 'spec_helper'
require 'support/test_classes'

describe "HashtiveRecord::Base" do
  let(:hash)     { {:wibble => { name: "Billy", age: 12}}  }
  let(:record)   { build(:record, hash: hash )  }
  let(:pet_record) { build(:record, hash: { jekyll: {name: "Jekyll"}})}
  let(:people)   { build(:table, id: :people, records: [record]) }
  let(:animals)  { build(:table, id: :animals) }
  let(:database) { build(:database, tables: [people, animals]) }
  let(:person)   { Person.new(record) }
  let(:pet)      { Pet.new(pet_record) }
  
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

    describe ".new" do
      it "instantiates based on a record" do
        person.record.should == record
      end
    end

    describe ".find" do
      it "finds the relevant object from the table" do
        Person.find(record.id).name.should == "Billy"
      end

      it "returns nil if nothing is found" do
        Person.find(:bibbleblob).should == nil
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
        pet.should_not respond_to :person
        Pet.belongs_to(:person)
        pet.should respond_to :person
        pet.should respond_to :person=
      end
    end
    
  end
  
  describe "instance methods" do
    describe "#method_missing" do
      it "delegates to the record" do
        p = Person.find :wibble
        p.name.should == "Billy"
        p.age.should == 12
        p.id.should == :wibble
      end
    end
  end
  
  


  
end
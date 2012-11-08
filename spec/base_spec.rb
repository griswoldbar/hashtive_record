require 'spec_helper'

describe "HashtiveRecord::Base" do
  let(:record)   { build(:record) }
  let(:people)   { build(:table, id: :people, records: [record]) }
  let(:animals)  { build(:table, id: :animals) }
  let(:database) { build(:database, tables: [people, animals]) }
  let(:person)   { Person.new(record) }
  
  before(:each) do    
    HashtiveRecord::Base.database = database
    class Person < HashtiveRecord::Base
    
    end
  end
  
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
      Person.find(record.id).instance_variables == person.instance_variables
    end
  end
  
  
end
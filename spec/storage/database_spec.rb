require 'spec_helper'

describe "HashtiveRecord::Storage::Database" do
  let(:database) { build(:database) }
  let(:table1)   { build(:table, id: :blah) }
  let(:table2)   { build(:table, id: :plop) }
  
  describe ".new" do
    it "initializes an array" do
      database.tables.should == []
    end
  end
  
  describe "#find" do
    it "finds the table with that id" do
      database.tables = [table1,table2]
      database.find(:plop).should == table2
      database.find(:blah).should == table1
    end
  end
  
  it "delegates missing methods to its set of tables" do
    database.tables.should_receive(:poop)
    database.poop
  end
  
  it "further delegates methods to its own find method" do
    database.tables = [table1,table2]
    database.plop.should == table2
    database.blah.should == table1
  end

end
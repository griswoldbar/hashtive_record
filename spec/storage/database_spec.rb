require 'spec_helper'

describe "HashtiveRecord::Storage::Database" do
  let!(:klass) { HashtiveRecord::Storage::Database }
  let(:database) { klass.new }
  let(:table1) { mock 'table' }
  let(:table2) { mock 'table' }
  
  before(:each) do
    table1.stub(:id).and_return(:blah)
    table2.stub(:id).and_return(:plop)
  end
  
  describe ".new" do
    it "initializes an array" do
      database.tables.should == []
    end
  end
  
  describe "#find" do
    it "finds the table with that id" do
      database.stub(:tables).and_return([table1,table2])
      database.find(:plop).should == table2
      database.find(:blah).should == table1
    end
  end
  
  it "delegates missing methods to its set of tables" do
    database.tables.should_receive(:poop)
    database.poop
  end
  
  it "further delegates methods to its own find method" do
    database.stub(:tables).and_return([table1,table2])
    database.plop.should == table2
    database.blah.should == table1
  end

end
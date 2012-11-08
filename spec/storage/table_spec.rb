require 'spec_helper'

describe "HashtiveRecord::Storage::Table" do
  let!(:klass) { HashtiveRecord::Storage::Table }
  let(:table) { klass.new(:things) }
  let(:record1) { mock 'record' }
  let(:record2) { mock 'record' }
  
  before(:each) do
    record1.stub(:id).and_return(:blah)
    record2.stub(:id).and_return(:plop)
  end
  
  describe ".new" do
    it "takes in an id and initializes an array" do
      table.id.should == :things
      table.records.should == [ ]
    end
  end
  
  describe "#find" do
    it "finds the record with that id" do
      table.stub(:records).and_return([record1,record2])
      table.find(:plop).should == record2
      table.find(:blah).should == record1
    end
  end
  
  it "delegates missing methods to its set of records" do
    table.records.should_receive(:poop)
    table.poop
  end
  
  it "further delegates methods to its own find method" do
    table.stub(:records).and_return([record1,record2])
    table.plop.should == record2
    table.blah.should == record1
  end
end
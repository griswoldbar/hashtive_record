require 'spec_helper'

describe "HashtiveRecord::Storage::Table" do
  let(:table)   { build(:table, id: :things) }
  let(:record1) { build(:record, hash: {blah: {}}) }
  let(:record2) { build(:record, hash: {plop: {}}) }
  
  describe ".new" do
    it "takes in an id and initializes an array" do
      table.id.should == :things
      table.records.should == [ ]
    end
  end
  
  describe "#find" do
    it "finds the record with that id" do
      table.records = [record1,record2]
      table.find(:plop).should == record2
      table.find(:blah).should == record1
    end
  end
  
  it "delegates missing methods to its set of records" do
    table.records.should_receive(:poop)
    table.poop
  end
  
  it "further delegates methods to its own find method" do
    table.records = [record1,record2]
    table.plop.should == record2
    table.blah.should == record1
  end
end
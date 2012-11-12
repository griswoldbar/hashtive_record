require 'spec_helper'
require 'support/shared_examples_for_container'

describe "HashtiveRecord::Storage::Table" do
  let(:table)   { build(:table, id: :things) }
  let(:record1) { build(:record, hash: {blah: {name: "Blah", age: 13}}) }
  let(:record2) { build(:record, hash: {plop: {name: "Blah", age: 12}}) }
  let(:record3) { build(:record, hash: {cack: {name: "Wibble", age: 12}}) }
  
  
  describe ".new" do
    it "takes in an id and initializes an array" do
      table.id.should == :things
      table.records.should == [ ]
    end
  end
  
  describe "#find_by" do
    before { table.collection = [record1,record2,record3] }
    
    it "finds the things with the given attributes" do
      table.find_by(name: "Blah").should =~ [record1,record2]
    end
    
    it "finds thing with multiple attributes" do
      table.find_by(name: "Blah", age: 12).should == [record2]
    end
  end

  
  it_behaves_like "container" do
    let(:container) { table }
    let(:thing1) { build(:record, hash: {blah: {name: "Plop"}}) }
    let(:thing2) { build(:record, hash: {plop: {name: "Wibble"}}) }    
  end

end
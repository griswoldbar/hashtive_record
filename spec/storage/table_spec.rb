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
  
  it_behaves_like "container" do
    let(:container) { table }
    let(:thing1) { build(:record, hash: {blah: {}}) }
    let(:thing2) { build(:record, hash: {plop: {}}) }
  end

end
require 'spec_helper'

describe "HashtiveRecord::Storage::Record" do
  let!(:klass) { HashtiveRecord::Storage::Record }
  let(:hash)   { {:wibble => { stats: {name: "Billy", age: 12}}} }
  let(:record) { klass.new(hash) }
  
  describe ".new" do
    it "wraps arguments in a struct" do
      record.hash.should == hash[:wibble].to_ostruct
    end
    
    it "raises an exception if there is more than one key at the top of the hash" do
      bad_hash = { wibble: "poop", cack: "poop"}
      expect { klass.new(bad_hash) }.to raise_error(HashtiveRecord::RecordError, "multiple ids found on record")
    end
  end
  
  describe "id" do
    it "returns the leading key" do
      record.id.should == hash.keys.first
    end
  end
  
  describe "an unrecognised method call" do
    it "is delegated to the hash in the first instance" do
      record.hash.should_receive(:poop)
      record.poop
    end
  end
  
  describe "a getter method" do
    it "accesses the relevant hash key" do
      record.stats.should == hash[:wibble][:stats].to_ostruct
    end
    
    it "accesses nested hash keys when necessary" do
      record.stats.name.should == hash[:wibble][:stats][:name]    
    end
  end
  
  describe "a setter method" do
    it "sets the relevant attribute" do
      record.favourite_food = "chips"
      record.favourite_food.should == "chips"
    end
  end
  

end
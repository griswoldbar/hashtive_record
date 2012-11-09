require 'spec_helper'

describe HashtiveRecord::AssociationProxies::ParentProxy do
  let(:person)  { build(:person) }
  let(:pet)     { build(:pet) }
  let(:proxy)   { described_class.build(:person, :jim)  }
  
  describe ".build" do
    it "returns an object of the required type" do
      Person.should_receive(:find).with(:jim).and_return(person)
      proxy
    end
    
    it "stores its accepted class" do
      Person.stub(:find)
      proxy.association_klass.should == Person
    end
  end

  describe "#method_missing" do
    it "delegates to its association" do
      Person.stub(:find).with(:jim).and_return(person)
      person.should_receive(:wibble)
      proxy.wibble
    end
  end

  describe "#valid_klass?" do
    it "returns true when the class is correct and false when it isn't" do

      Person.stub(:find)
      proxy.valid_klass?(person).should be_true
      proxy.valid_klass?(pet).should be_false
    end
  end
  
end
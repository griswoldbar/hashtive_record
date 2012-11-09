require 'spec_helper'

describe HashtiveRecord::AssociationProxies::ParentProxy do
  let(:person) { mock 'person' }
  
  describe ".new" do
    it "returns an object of the required type" do
      Person.should_receive(:find).with(:jim).and_return(person)
      described_class.new(:person, :jim)
    end
    
    it "stores its accepted class" do
      Person.stub(:find)
      proxy = described_class.new(:person, :jim)
      proxy.association_klass.should == Person
    end
  end

  describe "#method_missing" do
    it "delegates to its association" do
      Person.stub(:find).with(:jim).and_return(person)
      person.should_receive(:wibble)
      proxy = described_class.new(:person, :jim)
      proxy.wibble
    end
  end

  describe "#check_class" do
    
  end
  
end
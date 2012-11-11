require 'spec_helper'

describe HashtiveRecord::AssociationProxies::PolymorphicParentProxy do
  let(:person)  { build(:person) }
  let(:pet)     { build(:pet) }
  let(:proxy)   { described_class.build(:minder, :person, :jim)  }
  
  before(:all) do
    Minder = Module.new
    class Person<HashtiveRecord::Base;include Minder;end
  end
  
  describe ".build" do
    it "returns an appropriatae proxy" do
      Person.should_receive(:find).with(:jim)
      proxy
    end
  end
  
end
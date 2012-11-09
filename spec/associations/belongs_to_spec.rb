require 'spec_helper'

describe "HashtiveRecord::Associations::BelongsTo" do
  let(:klass) { HashtiveRecord::Associations::BelongsTo }
  let(:belongs_to) { klass.new(Pet, :person) }
  let(:pet) { build(:pet) }
  let(:person) { build(:person) }
  
  describe ".new" do
    it "initializes an parent class name and belonger class" do
      belongs_to.parent_klass_name.should == :person
      belongs_to.belonger_klass.should == Pet
    end
    
    describe "defined getter method" do
      it "it invokes a proxy" do
        HashtiveRecord::AssociationProxies::ParentProxy.should_receive(:new).with(:person, pet.person_id)
        pet.person
      end
    end

    
    it "defines a setter method for the owner" do
      
      pet.person = person
    end
    
  end
  
end
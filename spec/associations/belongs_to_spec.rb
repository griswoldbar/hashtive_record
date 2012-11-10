require 'spec_helper'

describe HashtiveRecord::Associations::BelongsTo do
  
  let!(:belongs_to) { described_class.new(Pet, :person) }
  let(:pet) { build(:pet) }
  let(:person) { build(:person) }
  let(:proxy) { mock 'proxy' }
  
  describe ".new" do
    
    describe "regular relationship" do
      it "adds it to the reflection" do
        Pet.reflection.should == {belongs_to: [:person]}
      end
      
      it "initializes a parent class name and belonger class" do
        belongs_to.parent_klass_name.should == :person
        belongs_to.belonger_klass.should == Pet
      end

      describe "defined getter method" do
        it "it invokes a proxy" do
          HashtiveRecord::AssociationProxies::ParentProxy.should_receive(:build).with(:person, pet.person_id)
          pet.person
        end
      end

      describe "defined setter method" do
        before { HashtiveRecord::AssociationProxies::ParentProxy.stub(:new).and_return(proxy) }
        it "raises an exception when given the wrong type" do
          proxy.should_receive(:valid_klass?).and_return(false)
          expect {pet.person = pet}.to raise_error(HashtiveRecord::Associations::TypeMismatch, "#{pet}")
        end

        it "updates the record id when given the correct type" do
          proxy.should_receive(:valid_klass?).and_return(true)
          proxy.should_receive(:association=).with(person)
          pet.person = person
          pet.person_id.should == person.id
        end
      end
    end
    

        

    
    describe "alternative association name" do
      let!(:belongs_to) { described_class.new(Pet, :person, as: :owner) }
      
      it "defines an appropriate getter" do
        HashtiveRecord::AssociationProxies::ParentProxy.should_receive(:build).with(:person, pet.owner_id)
        pet.owner
      end
      
      it "defines an appropriate setter" do
        HashtiveRecord::AssociationProxies::ParentProxy.stub(:new).and_return(proxy)
        proxy.should_receive(:valid_klass?).and_return(true)
        proxy.should_receive(:association=).with(person)
        pet.owner = person
        pet.owner_id.should == person.id
      end  
    end
    
    describe "polymorphic association" do
      let!(:belongs_to) { described_class.new(Pet, :person, as: :owner, polymorphic: true) }
      let(:pet) { build(:polymorphic_owned_pet) }
      
      
      
    end
    
  end
  
end
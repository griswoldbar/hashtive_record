require 'spec_helper'

describe HashtiveRecord::Associations::BelongsTo do
  
  let!(:belongs_to) { described_class.new(Pet, :person) }
  let(:pet) { build(:pet) }
  let(:person) { build(:person) }
  let(:proxy) { mock 'proxy' }
  
  describe ".new" do
    
    describe "regular relationship" do
      it "adds it to the reflection" do
        Pet.reflection.belongs_tos.should == { person: { id: :person_id, class_name: :person, polymorphic: false } }
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
      before(:each) do
        Pet.reflection = HashtiveRecord::Reflection.new(Pet)
      end
      
      it "adds it to the reflection" do
        described_class.new(Pet, :owner, class_name: :player)
        Pet.reflection.belongs_tos.should == { owner: { id: :owner_id, class_name: :player, polymorphic: false } }
      end
      
      it "defines an appropriate getter" do
        pet.stub(:owner_id).and_return(:bob)
        HashtiveRecord::AssociationProxies::ParentProxy.should_receive(:build).with(:player, pet.owner_id)
        described_class.new(Pet, :owner, class_name: :player)
        pet.owner
      end
      
      it "defines an appropriate setter" do
        described_class.new(Pet, :owner, class_name: :player)
        HashtiveRecord::AssociationProxies::ParentProxy.stub(:new).and_return(proxy)
        proxy.should_receive(:valid_klass?).and_return(true)
        proxy.should_receive(:association=).with(person)
        pet.owner = person
        pet.owner_id.should == person.id
      end  
    end
    
    describe "polymorphic association" do
      let!(:belongs_to) { described_class.new(Pet, :keeper, polymorphic: true) }
      
      before(:all) do
        Keeper = Module.new
        class Monster < HashtiveRecord::Base;include Keeper;end
        class Alien < HashtiveRecord::Base; include Keeper; end
      end
      
      before(:each) do
        @monster = Monster.instantiate(build(:record, hash: { zorg: {name: "Zorgon"}}))
        @alien = Alien.instantiate(build(:record, hash: { grey: {name: "The Grey"}}))
        pet.keeper_id = :zorg
        pet.keeper_type = :monster
      end
      
      it "adds it to the reflection" do
        Pet.reflection.belongs_tos[:keeper].should == {:id=>:keeper_id, :class_name=>:keeper, :polymorphic=>true}
      end
      
      it "defines an appropriate getter" do
        HashtiveRecord::AssociationProxies::PolymorphicParentProxy.should_receive(:build).with(:keeper, :monster, pet.keeper_id)
        pet.keeper
      end
      
      it "defines an appropriate setter" do
        HashtiveRecord::AssociationProxies::ParentProxy.stub(:new).and_return(proxy)
        proxy.should_receive(:valid_klass?).and_return(true)
        proxy.should_receive(:association=).with(@monster)
        pet.keeper = @monster
        pet.keeper_id.should == @monster.id
        pet.keeper_type.should == :monster
      end
      
      it "can be set to an instance of another class" do
        HashtiveRecord::AssociationProxies::ParentProxy.stub(:new).and_return(proxy)
        proxy.should_receive(:valid_klass?).and_return(true)
        proxy.should_receive(:association=).with(@alien)
        pet.keeper = @alien
        pet.keeper_id.should == @alien.id
        pet.keeper_type.should == :alien
      end
      
    end
    
  end
  
end
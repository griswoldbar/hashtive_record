require 'spec_helper'

describe HashtiveRecord::AssociationProxies::CollectionProxy do
  let(:proxy) { described_class.build(:cars, :park_id, :selfridges, :park)  }
  let(:collection) { mock 'collection' }
  let(:reflection) { mock 'reflection' }
  
  before(:all) do
    class Car < HashtiveRecord::Base ; end
    class Park < HashtiveRecord::Base; end
  end
  
  before(:each) do
    Car.stub(:reflection).and_return(reflection)
    reflection.stub(:belongs_tos).and_return(park: {id: :park_id, polymorphic: false})
  end
  
  describe ".build" do
    context "when not polymorphic" do
      it "finds an object of the required type" do
        Car.should_receive(:find_by).with({park_id: :selfridges})
        proxy
      end
    end

    context "when polymorphic" do
      let(:proxy) { described_class.build(:players, :game_id, :awesome_game, :doom)  }
      
      before(:each) do
        class Player < HashtiveRecord::Base
          belongs_to :game, polymorphic: true
        end
        
        class Doom < HashtiveRecord::Base
          has_many :players, as: :team
        end
      end
      
      it "finds an object of the required type" do
        Player.should_receive(:find_by).with(game_id: :awesome_game, game_class_name: :doom)
        proxy
      end
    end
  end
  
  describe "#method_missing" do
    it "delegates to its association" do
      Car.stub(:find_by).with({park_id: :selfridges}).and_return(collection)
      collection.should_receive(:wibble)
      proxy.wibble
    end
  end
  
  describe "#valid_klass?" do
    it "returns true when the class is correct and false when it isn't" do
      Car.stub(:find_by)
      car = Car.new
      park = Park.new
      proxy.valid_klass?(car).should be_true
      proxy.valid_klass?(park).should be_false
    end
  end
  
  describe "<<" do
    it "adds the object to the collection if valid" do
      Car.stub(:find_by).and_return([])
      car = Car.new
      proxy << car
      proxy.collection.should include(car)
    end
    
    it "excludes the object if not valid" do
      Car.stub(:find_by)
      park = Park.new
      expect { proxy << park }.to raise_error(HashtiveRecord::Associations::TypeMismatch)
    end
  end
end
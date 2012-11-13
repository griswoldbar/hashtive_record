require 'spec_helper'

describe HashtiveRecord::Associations::HasMany do
  before(:all) do
    class Flake < HashtiveRecord::Base; end  
    class Box < HashtiveRecord::Base; end
    Box.has_many(:flakes)
  end
  
  describe ".new" do
    let(:box) { Box.instantiate(build(:record, hash: {krunchies: {name: "Krunchies"}}  )) }
    
    describe "regular relationship" do
      
      it "adds it to the reflection" do
        Box.has_many(:flakes)
        Box.reflection.has_manys[:flakes].should == {id: :box_id}
      end
      
      it "defines a getter" do
        HashtiveRecord::AssociationProxies::CollectionProxy.should_receive(:build).with(box, :flakes, :box_id)
        box.flakes
      end
      
    end
    
    describe "polymorphic relationship" do
      before(:all) do
        class Item < HashtiveRecord::Base
          belongs_to :container, polymorphic: :true
        end
        class Room < HashtiveRecord::Base
          has_many :items, as: :container
        end
      end
      
      let(:room) { Room.instantiate(build(:record, hash: {bedroom: {name: "Master bedroom"}}))}
      
      it "adds it to the reflection" do
        Room.reflection.has_manys[:items].should == {id: :container_id}
      end
      
      it "defines a getter" do
        HashtiveRecord::AssociationProxies::CollectionProxy.should_receive(:build).with(room, :items, :container_id)
        room.items
      end
      
    end
    
  end
  
end
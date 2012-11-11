require 'spec_helper'

describe HashtiveRecord::Associations::HasMany do
  before(:all) do
    Flake = Class.new(HashtiveRecord::Base)
    Box = Class.new(HashtiveRecord::Base)
    Box.has_many(:flakes)
  end
  
  describe ".new" do
    let(:box) { Box.instantiate(build(:record, hash: {krunchies: {name: "Krunchies"}}  )) }
    
    describe "regular relationship" do
      
      it "adds it to the reflection" do
        
      end
      
      it "defines a getter" do
        
      end
      
    end
    
    describe "polymorphic relationship" do
      
    end
    
  end
  
end
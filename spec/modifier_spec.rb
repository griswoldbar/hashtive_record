require 'spec_helper'



describe "Modifier" do

  before(:all) do
    module Destroy
      include HashtiveRecord::Modifier      
    end
    
    module Plonk
      include HashtiveRecord::Modifier
      
      default_message "Oh bugger"
    end
  end
  
  describe "#message" do
    let(:thing) { build(:thing) }
    
    it "outputs the default message if none is given at module level" do
      thing.add_modifier(:destroy)
      thing.destroy_message.should == "You destroy the #{thing.name}"
    end
    
    it "outputs the modules's default message if none is given at instance level" do
      thing.add_modifier(:plonk)
      thing.plonk_message.should == "Oh bugger"
    end
  end
end
require 'spec_helper'



describe "Modifier" do
  let(:thing)  { build(:thing) }
  let(:record) { build(:thing_record, modifiers: {plonk: {message: "You fuck it up big time", 
                                                          name: "thingumy blah",
                                                          description: "it looks awful"}})}
  
  before(:all) do
    module Destroy
      include HashtiveRecord::Modifier      
    end
    
    module Plonk
      include HashtiveRecord::Modifier
      defaults message: "Oh bugger", 
               new_name: "wankered thing",
               new_description: "it's completely fucked"
                 
    end
    
  end
  
  describe "#message" do

    it "outputs the default message if none is given at module level" do
      thing.add_modifier(:destroy)
      thing.destroy_message.should == "You destroy the #{thing.name}"
    end
    
    it "outputs the modules's default message if none is given at instance level" do
      thing.add_modifier(:plonk)
      thing.plonk_message.should == "Oh bugger"
    end
    
    it "outputs the instance's message if supplied" do
      thing = record.klass.instantiate(record)
      thing.plonk_message.should == "You fuck it up big time"
    end
  end
  
  describe "#name" do
    it "outputs the default name if none is given at module level" do
      thing.add_modifier(:destroy)
      thing.destroy_name.should == "destroyed #{thing.name}"
    end
    
    it "outputs the modules's default name if none is given at instance level" do
      original_name = thing.name
      thing.add_modifier(:plonk)
      thing.plonk_name.should == "wankered thing"
    end
    
    it "outputs the instance's name if supplied" do
      thing = record.klass.instantiate(record)
      thing.plonk_name.should == "thingumy blah"
    end
  end
  
  describe "#description" do
    it "outputs the default description if none is given at module level" do
      thing.add_modifier(:destroy)
      thing.destroy_description.should == "the #{thing.name} has been destroyed"
    end
    
    it "outputs the modules's default description if none is given at instance level" do
      original_description = thing.description
      thing.add_modifier(:plonk)
      thing.plonk_description.should == "it's completely fucked"
    end
    
    it "outputs the instance's description if supplied" do
      thing = record.klass.instantiate(record)
      thing.plonk_description.should == "it looks awful"
    end
  end
  
end
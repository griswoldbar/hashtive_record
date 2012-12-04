require 'spec_helper'

describe HashtiveRecord::Modifier do
  let(:mod) { described_class }
  describe "configuration" do
    
    describe ".configure" do
      it "evaluates the given block" do
        mod.should_receive(:blah)
        mod.configure { blah }
      end
    end
    
    describe ".text" do
      it "adds to the definitions hash" do
        mod.text(:new_name)
        mod.definitions.should == {new_name: {}}
        mod.text(:new_description, default: "useless")
        mod.definitions.should == {new_name: {}, new_description: {default: "useless"}}
      end
    end
    
  end
  
  describe "inclusion" do
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
                 new_description: "the ==placeholder== is completely fucked"

      end
    end

    describe "attributes" do
      describe ":message" do

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

      describe ":name" do
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

      describe ":description" do
        it "outputs the default description if none is given at module level" do
          thing.add_modifier(:destroy)
          thing.destroy_description.should == "the #{thing.name} has been destroyed"
        end

        it "outputs the modules's default description if none is given at instance level" do
          original_description = thing.description
          thing.add_modifier(:plonk)
          thing.plonk_description.should == "the #{thing.name} is completely fucked"
        end

        it "outputs the instance's description if supplied" do
          thing = record.klass.instantiate(record)
          thing.plonk_description.should == "it looks awful"
        end
      end

    end

    describe "modify_method" do
      it "changes the name and description" do
        thing.add_modifier(:destroy)
        thing.destroy
        thing.screen_name.should == "destroyed #{thing.name}"
      end
    end
    
  end
  
  
end
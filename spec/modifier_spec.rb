require 'spec_helper'

describe HashtiveRecord::Modifier do
  let(:mod) { described_class }
  let(:thing)  { build(:thing) }
  
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
        mod.definitions.new_name.should == nil
        blok = proc { "some block" }
        mod.text(:new_description, &blok)
        mod.definitions.new_description.should == blok
      end
    end
    
  end
  
  describe "inclusion" do
    let(:record) { build(:thing_record, modifiers: {plonk: {message: "You fuck it up big time", 
                                                            name: "thingumy blah",
                                                            description: "it looks awful"}})}

    before(:all) do
      HashtiveRecord::Modifier.configure do
        text(:name)        {|mod, thing| "#{mod.to_s}ed #{thing.name}"}
        text(:message)     {|mod, thing| "You #{mod} the #{thing.name}"}
        text(:description) {|mod, thing| "the #{thing.name} has been #{mod}ed"}

        meth {
          mod_name = __method__.to_s.gsub(/default_/,"").to_sym
          options = modifier_options[mod_name].dup
          message, name, description = [options[:message], options[:name], options[:description]].map {|thing|
            thing.is_a?(Proc) ? thing.call(mod_name, self) : thing
          }

          self.screen_name = name
          self.description = description
          message
        }
      end
      
      
      module Destroy
        include HashtiveRecord::Modifier      
      end

      module Plonk
        include HashtiveRecord::Modifier
        text :message, "Oh bugger"
        text :name, "Plonked thing"
        text(:description) {|mod,thing| "the #{thing.name} is completely #{mod}ed" }
      end
    end

    describe "#add_modifier" do
      #we're implicitly testing the "meth" method here which defines the default behaviour of action methods like "smash"
      
      describe ":message" do

        it "outputs the default message if none is given at module level" do
          thing.add_modifier(:destroy)
          thing.destroy.should == "You destroy the #{thing.name}"
        end

        it "outputs the modules's default message if none is given at instance level" do
          thing.add_modifier(:plonk)
          thing.plonk == "Oh bugger"
        end

        it "outputs the instance's message if supplied" do
          thing = record.klass.instantiate(record)
          thing.plonk.should == "You fuck it up big time"
        end
      end

      describe ":name" do
        it "outputs the default name if none is given at module level" do
          thing.add_modifier(:destroy)
          thing.destroy
          thing.screen_name.should == "destroyed #{thing.name}"
        end

        it "outputs the modules's default name if none is given at instance level" do
          thing.add_modifier(:plonk)
          thing.plonk
          thing.screen_name.should == "Plonked thing"
        end

        it "outputs the instance's name if supplied" do
          thing = record.klass.instantiate(record)
          thing.plonk
          thing.screen_name.should == "thingumy blah"
        end
      end

      describe ":description" do
        it "outputs the default description if none is given at module level" do
          thing.add_modifier(:destroy)
          thing.destroy
          thing.description.should == "the #{thing.name} has been destroyed"
        end

        it "outputs the modules's default description if none is given at instance level" do
          original_description = thing.description
          thing.add_modifier(:plonk)
          thing.plonk
          thing.description.should == "the #{thing.name} is completely plonked"
        end

        it "outputs the instance's description if supplied" do
          thing = record.klass.instantiate(record)
          thing.plonk
          thing.description.should == "it looks awful"
        end
      end

    end
    
  end
  
  describe "overriding the default method" do
    before(:all) do
      module Clonk
        include HashtiveRecord::Modifier
        
        def clonk
          default_clonk + " and also this"
        end
      end
    end
    
    it "allows you to refer to the configuration default" do
      thing.add_modifier(:clonk)
      thing.clonk.should == "You clonk the #{thing.name} and also this"
    end
  end
  
  
end
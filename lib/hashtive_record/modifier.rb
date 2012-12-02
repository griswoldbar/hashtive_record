module HashtiveRecord
  module Modifier

    def define_reader(attribute, text, mod_name, thing_name=nil)

      text = text.gsub(/==placeholder==/, thing_name) if thing_name
      reader = "#{mod_name}_#{attribute}"
      instance_variable_set("@"+reader, text)
    
      instance_eval "
        def #{reader}
          @#{reader}
        end
      "
    end


    def self.included(base)
      base.extend(ClassMethods)
      base.setup_defaults
    end
    
    module ClassMethods
      def setup_defaults
        mod_name = self.to_s.downcase
        message_text = self.message
        name_text = self.new_name
        description_text = self.new_description
        
        define_singleton_method :extended do |thing|
          [:message, :description, :name].each do |attribute|
            if thing.modifier_modules.include?(mod_name.to_sym) && thing.record.modifiers.send(mod_name) && thing.record.modifiers.send(mod_name).send(attribute)
              text = thing.record.modifiers.send(mod_name).send(attribute)
              thing.define_reader attribute, text, "#{mod_name}"
            else
              thing.define_reader attribute, eval("#{attribute}_text"), "#{mod_name}", thing.name
            end
          end

        end
      end
      
      def message
        "You #{name.downcase} the ==placeholder=="
      end
      
      def new_name
        "#{name.downcase}ed ==placeholder=="
      end
      
      def new_description
        "the ==placeholder== has been #{name.downcase}ed"
      end
      
      def defaults(options)
        options.each {|k,v|
          define_singleton_method k do
            v
          end
        }
        setup_defaults
      end
    end

  end
end
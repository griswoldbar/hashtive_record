module HashtiveRecord
  module Modifier
    def set_message(text, mod_name, thing_name=nil)
      text.gsub!(/==placeholder==/, thing_name) if thing_name
      reader = "#{mod_name}_message"
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
        text = self.message
        instance_eval "
        def self.extended(thing)
          if thing.modifier_modules.include?(:#{mod_name}) && thing.record.modifiers.#{mod_name} && thing.record.modifiers.#{mod_name}.message
            text = thing.record.modifiers.#{mod_name}.message
            thing.set_message text, %Q{#{mod_name}}
          else
            thing.set_message %Q{#{text}}, %Q{#{mod_name}}, thing.name
          end
        end
        "
      end
      
      def message
        @message || "You #{name.downcase} the ==placeholder=="
      end
      
      def default_message(text)
        @message = text
        setup_defaults
      end
    end

  end
end
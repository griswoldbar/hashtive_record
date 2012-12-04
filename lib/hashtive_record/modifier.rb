module HashtiveRecord
  module Modifier
    extend self

    attr_accessor :mod
    
    def configure(&block)  
      instance_eval(&block)  
    end
    
    def definitions=val
      @definitions = val
    end
        
    def definitions  
      @definitions ||= OpenStruct.new  
    end  

    def text(name, &block)    
      definitions.send(name.eqify, block)
    end
    
    def mod_name
      name.downcase.to_sym
    end
    
    # def define_reader(attribute, text, mod_name, thing_name=nil)
    #   text = text.gsub(/==placeholder==/, thing_name) if thing_name
    #   reader = "#{mod_name}_#{attribute}"
    #   instance_variable_set("@"+reader, text)
    # 
    #   instance_eval "
    #     def #{reader}
    #       @#{reader}
    #     end
    #   "
    # end

    def included(base)
      base.extend(self)
      base.definitions = self.definitions
    end
    
    def extended(base)
      if base.class.name != "Module"
        modifiers = self.definitions.marshal_dump.merge(base.modifiers.send(mod_name).marshal_dump)
        modifiers.each do |modifier|
          throw "this is where i got up to - define e.g. 'kill' method"
          # base.send(:define_singleton_method
        end
      end
    end
    
    # module ClassMethods
    #   def setup_defaults
    #     mod_name = self.to_s.downcase
    #     message_text = self.message
    #     name_text = self.new_name
    #     description_text = self.new_description
    #     
    #     define_singleton_method :extended do |thing|
    #       thing.definitions = 
    #       [:message, :description, :name].each do |attribute|
    #         if thing.modifier_modules.include?(mod_name.to_sym) && thing.record.modifiers.send(mod_name) && thing.record.modifiers.send(mod_name).send(attribute)
    #           text = thing.record.modifiers.send(mod_name).send(attribute)
    #           thing.define_reader attribute, text, "#{mod_name}"
    #         else
    #           thing.define_reader attribute, eval("#{attribute}_text"), "#{mod_name}", thing.name
    #         end
    #       end
    #     end
    #     
    #     define_method mod_name do
    #       self.screen_name = self.send("#{mod_name}_name")
    #       self.description = self.send("#{mod_name}_description")
    #       self.send("#{mod_name}_message")
    #     end
    #     
    #     
    #   end
    # end
    
  end
end
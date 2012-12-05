module HashtiveRecord
  module Modifier
    extend self
    
    def configure(&block)  
      instance_eval(&block)  
    end
    
    def definitions=val
      @definitions = val
    end
        
    def definitions  
      @definitions ||= OpenStruct.new  
    end 
    
    def meth &block
      definitions.meth = block
    end

    def text(name, str=nil, &block)    
      definitions.send(name.eqify, str || block)
    end
    
    def mod_name
      name.downcase.to_sym
    end

    def included(base)
      base.extend(self)
      base.definitions = self.definitions.dup
    end
    
    def extended(base)
      if base.class.name != "Module"
        modifiers = self.definitions.marshal_dump.merge(base.modifiers.send(mod_name).marshal_dump)
        base.modifier_options[mod_name] = modifiers
        meth = self.definitions.meth
        base.send(:define_singleton_method, "default_#{mod_name}", &meth)
      end
    end
    
    def method_missing(method, *args, &block)
      default = "default_#{method}".to_sym
      if singleton_methods.include?(default)        
        send(default, *args, &block)
      else
        super(method, *args, &block)
      end
    end
      
  end
end
HashtiveRecord::Modifier.configure do
  text(:name)        {|mod, thing| "#{mod.to_s}ed #{thing.name}"}
  text(:message)     {|mod, thing| "You #{mod} the #{thing.name}"}
  text(:description) {|mod, thing| "the #{thing.name} has been #{mod}ed"}
  
  #the default method. 
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
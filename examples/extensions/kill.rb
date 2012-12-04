module Kill
  include HashtiveRecord::Modifier
  text :new_name, {default: lambda {|mod| "You utterly #{mod} the ==placeholder" }}
  
end
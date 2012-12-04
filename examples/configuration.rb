HashtiveRecord::Modifier.configure do
  text :name, {default: lambda {|mod|"#{mod}ed ==placeholder=="}}
  text :message,  {default: lambda {|mod|"You #{mod} the ==placeholder=="}}
  text :description, {default: lambda {|mod| "the ==placeholder== has been #{mod}ed"}}
end
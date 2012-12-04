HashtiveRecord::Modifier.configure do
  text(:name)        {|mod, thing| "#{mod}ed #{thing.name}"}
  text(:message)     {|mod, thing| "You #{mod} the #{thing.name}"}
  text(:description) {|mod, thing| "the #{thing.name} has been #{mod}ed"}
end
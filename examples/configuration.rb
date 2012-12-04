HashtiveRecord::Modifier.configure do
  text(:name)        {|mod|"#{mod}ed ==placeholder=="}
  text(:message)     {|mod|"You #{mod} the ==placeholder=="}
  text(:description) {|mod| "the ==placeholder== has been #{mod}ed"}
end
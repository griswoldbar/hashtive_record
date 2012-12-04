module Kill
  include HashtiveRecord::Modifier
  text(:name) {|mod| "You utterly #{mod} the ==placeholder" }
  
end
module Kill
  include HashtiveRecord::Modifier
  text(:name) {|mod,thing| "You utterly #{mod} the #{thing.name}" }
  
end
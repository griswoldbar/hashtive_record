module Kill
  include HashtiveRecord::Modifier
  text(:name) {|mod,thing| "You utterly #{mod} the #{thing.name}" }
  
  # def kill
  #   default_kill + " oh deary me"
  # end
end
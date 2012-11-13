module Container
  extend ActiveSupport::Concern
  
  included { has_many :items, as: :container }
  
end
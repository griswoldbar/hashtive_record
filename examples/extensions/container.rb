module Container
  extend ActiveSupport::Concern
  
  included { has_many :items, foreign_key: :container_id }
  
end
module Owner
  extend ActiveSupport::Concern
  
  included do
    has_many :pets, as: :owner
  end
  
end
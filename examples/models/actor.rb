class Actor < HashtiveRecord::Base
  include Trifik::Model
  include Container
  
  belongs_to :room

  
end
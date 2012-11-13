class Actor < HashtiveRecord::Base
  include Container
  
  belongs_to :room

  
end
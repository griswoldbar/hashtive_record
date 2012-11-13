class Connection < HashtiveRecord::Base
  
  belongs_to :room
  belongs_to :adjacent, as: :room

  
end
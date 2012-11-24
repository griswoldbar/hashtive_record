class Connection < HashtiveRecord::Base
  
  belongs_to :exit, class_name: :room
  belongs_to :entrance, class_name: :room

  
end
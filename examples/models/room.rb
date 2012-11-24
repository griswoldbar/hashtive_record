class Room < HashtiveRecord::Base
  include Container
  
  has_many :actors
  has_many :players
  has_many :exits, class_name: :connection, foreign_key: :exit_id
  has_many :entrances, class_name: :connection, foreign_key: :entrance_id
  

end
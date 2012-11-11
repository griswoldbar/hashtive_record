class Pet < HashtiveRecord::Base
  belongs_to :owner, polymorphic: true
  
end
class Item < HashtiveRecord::Base

  belongs_to :container, polymorphic: true


end
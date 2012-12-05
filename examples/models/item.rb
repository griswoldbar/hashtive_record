class Item < HashtiveRecord::Base
  include Trifik::Model

  belongs_to :container, polymorphic: true


end
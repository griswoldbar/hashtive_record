module HashtiveRecord
  module Macros

    def belongs_to(parent_name)
      HashtiveRecord::Associations::BelongsTo.new(self, parent_name)
    end
  
    def has_many(collection_name)
  
    end
  
  end

end
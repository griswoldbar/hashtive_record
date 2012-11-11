module HashtiveRecord
  module Macros

    def belongs_to(parent_name, options = {})
      Associations::BelongsTo.new(self, parent_name, options)
    end
  
    def has_many(collection_name, options = {})
      
    end
  
  end

end
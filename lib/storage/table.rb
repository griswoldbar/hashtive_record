module HashtiveRecord
  module Storage
    
    class Table
      include HashtiveRecord::Container
      collection :records
      
      attr_accessor :records, :id
      
      def initialize(id)
        @id = id
        @records = []
      end
      
    end
  
  end
  
end
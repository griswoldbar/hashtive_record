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
        
      def klass
        id.to_class
      end
      
      def find_by(attributes={})
        attributes.inject(collection) do |selected, attribute|
          selected.select{|record| record.send(attribute[0]) == attribute[1] }
        end
      end

    end
  
  end
  
end
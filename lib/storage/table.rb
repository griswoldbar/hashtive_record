module HashtiveRecord
  module Storage
    
    class Table
      attr_accessor :records
      attr_reader :id
      
      def initialize(id)
        @id = id
        @records = []
      end
      
      def find(id)
        records.find { |rec| rec.id == id }
      end
      
      def method_missing(method, *args, &block)
        if records.respond_to?(method)
          records.send(method, *args, &block)
        elsif find(method)
          find(method)
        else
          super(method, *args, &block)
        end
      end

      def respond_to?(method, include_private = false)
        super || records.respond_to?(method, include_private)
      end

      
    end
  
  end
  
end
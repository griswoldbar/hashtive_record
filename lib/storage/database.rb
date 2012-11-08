module HashtiveRecord
  module Storage
    
    class Database
      attr_accessor :tables
      
      def initialize
        @tables = []
      end
      
      def find(id)
        tables.find { |rec| rec.id == id }
      end
      
      def method_missing(method, *args, &block)
        if tables.respond_to?(method)
          tables.send(method, *args, &block)
        elsif find(method)
          find(method)
        else
          super(method, *args, &block)
        end
      end

      def respond_to?(method, include_private = false)
        super || tables.respond_to?(method, include_private)
      end

      
    end
  
  end
  
end
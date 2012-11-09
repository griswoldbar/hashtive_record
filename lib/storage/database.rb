module HashtiveRecord
  module Storage
    
    class Database
      include HashtiveRecord::Container
      collection :tables
      
      attr_accessor :tables
      
      
      def initialize
        @tables = []
      end
      
    end
  
  end
end
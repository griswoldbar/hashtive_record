module HashtiveRecord

  class Base
    attr_reader :record
    
    def initialize(record)
      @record = record
    end
    
    class<<self
      
      attr_accessor :table_name
      attr_reader :table
      
      def find(id)
        new(table.find(id))
      end
      
      def inherited(base)
        base.table_name ||= base.name.tableize.to_sym
      end
      
      def table
        @table ||= database.send(table_name)
      end
      
      def database
        @@database
      end
      
      def database=(val)
        @@database=val
      end
      
      def table_name=(val)
        @table_name=val
      end
    end

  end
end
module HashtiveRecord

  class Base
    extend HashtiveRecord::Macros
    attr_reader :record
    
    def initialize(record)
      @record = record
    end
    
    def method_missing(method, *args, &block)
      if record.respond_to?(method)
        record.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end

    def respond_to?(method, include_private = false)
      super || record.respond_to?(method, include_private)
    end
    
    
    class<<self
      
      attr_accessor :table_name
      
      def inherited(base)
        base.table_name ||= base.name.tableize.to_sym if !!base.name
      end
      
      def find(id)
        record = table.find(id)
        if !!record
          new(record)
        else
          nil
        end
      end
      
      def table
        database.send(table_name)
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
      
      def all
        table.map {|record| new(record) }
      end
      
      def method_missing(method, *args, &block)
        if record = find(method)
          record
        else
          super(method, *args, &block)
        end
      end

      def respond_to?(method, include_private = false)
        super || find(method)
      end
      
    end

  end
end
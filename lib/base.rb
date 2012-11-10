module HashtiveRecord

  class Base
    extend Macros
    attr_accessor :record

    
    def method_missing(method, *args, &block)
      if self.class.accessors.include?(method)
        record.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end

    def respond_to?(method, include_private = false)
      super || record.respond_to?(method, include_private)
    end
    
    
    class<<self
      
      attr_accessor :table_name, :reflection
      
      def load(record)
        new.tap {|item| item.record=record}
      end
      
      def inherited(base)
        base.reflection = Reflection.new
        base.table_name ||= base.name.tableize.to_sym if !!base.name
      end
      
      def columns(*names)
        reflection.add_columns(*names)
      end
      
      def accessors
        reflection.accessors
      end
      
      def find(id)
        record = table.find(id)
        if !!record
          load(record)
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
        table.map {|record| load(record) }
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
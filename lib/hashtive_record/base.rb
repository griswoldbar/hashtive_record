module HashtiveRecord

  class Base
    extend Macros
    include Comparable
    attr_accessor :record
        
    def id
      record.id
    end
    
    def modifiers
      record.modifiers ||= OpenStruct.new
    end
    
    def modifiers=(val)
      record.modifiers=val
    end
    
    def modifier_options
      @modifier_options ||= Hash.new
    end
    
    def modifier_modules
      record.modifiers.marshal_dump.keys rescue []
    end
    
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
    
    def add_modifier(modifier)
      record.send(:modifiers=, OpenStruct.new) unless record.modifiers
      record.modifiers.send(modifier.eqify, OpenStruct.new) unless modifier_modules.include?(modifier)
      extend(modifier.to_class)
    end
    
    def==(other)
      self.id == other.id
    end
    
    class<<self
      
      attr_accessor :table_name, :reflection
    
      def instantiate(record)
        new.tap do |item| 
          item.record=record
          item.modifier_modules.each {|modifier| item.extend(modifier.to_class)}
        end
      end
      
      def build(id, attrs={})
        attrs.reject! {|attr| !accessors.include?(attr) }
        record = Storage::Record.new(id => attrs)
        table << record
        instantiate(record)
      end
      
      def inherited(base)
        base.reflection = Reflection.new(base)
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
          instantiate(record)
        else
          nil
        end
      end
      
      def find_by(fields={})
        table.find_by(fields).map{|record| instantiate(record) }
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
        table.map {|record| instantiate(record) }
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
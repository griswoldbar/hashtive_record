module HashtiveRecord
  class Reflection
    attr_reader :columns, :belongs_tos, :has_manys, :owner_class_name
    
    def initialize(owner)
      @owner_class_name = owner.to_s.downcase.to_sym
      @columns = []
      @belongs_tos = {}
      @has_manys = {}
    end
    
    def add_columns(*names)
      names.each { |name| @columns << name }
    end
    
    def add_belongs_to(name, options = {})
      id = (options[:as] ? "#{options[:as]}_id" : "#{name}_id").to_sym
      polymorphic = options[:polymorphic] || false
      @belongs_tos[name] = {id: id, polymorphic: polymorphic}
    end
    
    def add_has_many(name, options = {})
      id = (options[:as] ? "#{options[:as]}_id" : "#{owner_class_name}_id").to_sym
      @has_manys[name] = {id: id}
    end
    
    def accessors
      @_accessors = []
      add_column_accessors
      add_belongs_to_accessors
      add_has_many_accessors
      @_accessors.flatten
    end
    
    private
    def add_column_accessors
      columns.inject(@_accessors) {|accessors, column| accessors << [column, column.eqify]}
    end
    
    def add_belongs_to_accessors
      belongs_tos.inject(@_accessors) do |accessors, thing|
        attributes = thing[1]
        column = attributes[:id]
        new_accessors = [column, column.eqify]
        if attributes[:polymorphic]
          class_col_accessor = column.to_s.gsub('_id', '_class_name').to_sym
          new_accessors << [class_col_accessor, class_col_accessor.eqify]
        end
        accessors << new_accessors
      end
    end
    
    def add_has_many_accessors
      has_manys.inject(@_accessors) do |accessors, thing|
        accessors << thing[0]
      end
    end
  end
end
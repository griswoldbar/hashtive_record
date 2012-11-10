module HashtiveRecord
  class Reflection
    attr_reader :columns, :belongs_tos, :has_manys
    
    def initialize
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
  end
end
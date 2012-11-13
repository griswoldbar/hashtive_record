module HashtiveRecord
  class Loader
    #this allows us to load yaml files as per the examples. Objects may be
    #nested within the yaml (as per rooms/garden.yaml)
    
    attr_reader :folder, :tables
    
    def initialize(folder)
      @folder = folder
    end
    
    def load
      initialize_tables
      initialize_database
      fill_tables
    end
    
    private
    def initialize_tables
      collection_names = Dir.glob("#{folder}/*").map {|subfolder| File.basename subfolder }
      @tables = collection_names.map {|collection_name| Storage::Table.new(collection_name.to_sym) }
    end
    
    def fill_tables
      @tables.each {|table| load_records(table) }
    end
    
    def load_records(table)
      files = Dir.glob("#{folder}/#{table.id.to_s}/*.yaml")
      hashes = files.map {|file| YAML.load(File.read(file)) }
      records = hashes.map {|hash| process_hash(hash, table) }
      table.records += records
    end
    
    def initialize_database
      @database = Storage::Database.new
      @database.tables = tables
      HashtiveRecord::Base.database = @database
    end
    
    def process_hash(hash, parent_table)
      collections = hash.map {|k,v| v.delete(:collections)}.compact
      parent_id = hash.keys[0]
      collections.each {|collection| collection.each {|table_name, items| process_collection(table_name, items, parent_id, parent_table) }}
      Storage::Record.new(hash)
    end
    
    def process_collection(table_name,items,parent_id, parent_table)
      child_table = @tables.select {|table| table.id == table_name}.first
      items.each{|child_id, attributes| process_nested(child_table, child_id, attributes, parent_id, parent_table)}
    end
    
    def process_nested(child_table, child_id, attributes, parent_id, parent_table) 
      parent_refs = get_parent_refs(parent_table, child_table, parent_id)
      attributes.merge!(parent_refs) if !!parent_refs
      record = Storage::Record.new(child_id => attributes)
      child_table.records << record
    end
    
    def get_parent_refs(parent_table, child_table, parent_id)
      child_klass = child_table.klass
      parent_klass = parent_table.klass
      
      foreign_key_name = parent_klass.reflection.has_manys[child_table.id][:id]
      foreign_ref = foreign_key_name.to_s.chomp("_id").to_sym
      
      polymorphic = child_klass.reflection.belongs_tos[foreign_ref][:polymorphic]
      
      refs = {foreign_key_name => parent_id}
      
      if polymorphic
        foreign_key_class_name = (foreign_ref.to_s + "_type").to_sym
        refs.merge!(foreign_key_class_name => parent_table.id.to_s.chomp.to_sym)
      end
    end
    
  end
end
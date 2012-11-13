module HashtiveRecord
  class Loader
    attr_reader :folder, :tables
    
    def initialize(folder)
      @folder = folder
    end
    
    def load
      initialize_tables
      fill_tables
      initialize_database
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
      records = hashes.map {|hash| Storage::Record.new(hash)}
      table.records = records
    end
    
    def initialize_database
      database = Storage::Database.new
      database.tables = tables
      HashtiveRecord::Base.database = database
    end
    
  end
end
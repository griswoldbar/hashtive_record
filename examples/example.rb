require './lib/hashtive_record'
Dir.glob("./examples/extensions/*.rb") {|file| require file}
Dir.glob("./examples/models/*.rb") {|file| require file}


loader = HashtiveRecord::Loader.new('./examples/yamls')
loader.load



# jim = HashtiveRecord::Storage::Record.new(:jim => {name: "Jim", age: 12})
# bob = HashtiveRecord::Storage::Record.new(:bob => {name: "Bob", age: 13})
# jekyll = HashtiveRecord::Storage::Record.new(:jekyll => {name: "Jekyll", owner_id: :jim, owner_type: :person})
# heidi = HashtiveRecord::Storage::Record.new(:heidi => {name: "Heidi"})
# hubble = HashtiveRecord::Storage::Record.new(:hubble => {name: "Hubble"})
# zogo = HashtiveRecord::Storage::Record.new(zogo: {name: "Zogo the mighty"})
# bibble = HashtiveRecord::Storage::Record.new(bibble: {name: "Bibble Bobble"})
# 
# people = HashtiveRecord::Storage::Table.new(:people)
# pets = HashtiveRecord::Storage::Table.new(:pets)
# monsters = HashtiveRecord::Storage::Table.new(:monsters)
# aliens = HashtiveRecord::Storage::Table.new(:aliens)
# 
# people << jim
# people << bob
# pets << jekyll
# pets << heidi
# pets << hubble
# monsters << zogo
# aliens << bibble
# 
# HashtiveRecord::Base.database << people
# HashtiveRecord::Base.database << pets
# HashtiveRecord::Base.database << monsters
# HashtiveRecord::Base.database << aliens
# 


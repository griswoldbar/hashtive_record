require './requirements'
Dir.glob("./examples/models/*.rb") {|file| require file}

HashtiveRecord::Base.database = HashtiveRecord::Storage::Database.new
jim = HashtiveRecord::Storage::Record.new(:jim => {name: "Jim", age: 12})
bob = HashtiveRecord::Storage::Record.new(:bob => {name: "Bob", age: 13})
jekyll = HashtiveRecord::Storage::Record.new(:jekyll => {name: "Jekyll", person_id: :jim})
heidi = HashtiveRecord::Storage::Record.new(:heidi => {name: "Heidi"})
hubble = HashtiveRecord::Storage::Record.new(:hubble => {name: "Hubble"})

people = HashtiveRecord::Storage::Table.new(:people)
pets = HashtiveRecord::Storage::Table.new(:pets)

people << jim
people << bob
pets << jekyll
pets << heidi
pets << hubble
HashtiveRecord::Base.database << people
HashtiveRecord::Base.database << pets

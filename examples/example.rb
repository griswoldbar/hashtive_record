require 'active_support/core_ext'

require './lib/hashtive_record/initializers/hash'
require './lib/hashtive_record/initializers/symbol'
require './lib/hashtive_record/initializers/open_struct'

require './lib/hashtive_record/extensions/container'
require './lib/hashtive_record/extensions/macros'
require './lib/hashtive_record/storage/database'
require './lib/hashtive_record/storage/table'
require './lib/hashtive_record/storage/record'
require './lib/hashtive_record/base'
require './lib/hashtive_record/modifier'
require './lib/hashtive_record/associations'
require './lib/hashtive_record/loader'
require './lib/hashtive_record/reflection'  
require './lib/hashtive_record/associations/belongs_to'
require './lib/hashtive_record/associations/has_many'
require './lib/hashtive_record/association_proxies/parent_proxy'
require './lib/hashtive_record/association_proxies/collection_proxy'
require './examples/extensions/container'
require './examples/extensions/trifik'

require './examples/configuration'
require './examples/modifiers/droppable'
require './examples/modifiers/kill'
require './examples/modifiers/smashable'
require './examples/modifiers/takeable'
require './examples/models/actor'
require './examples/models/connection'
require './examples/models/item'
require './examples/models/player'
require './examples/models/room'

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


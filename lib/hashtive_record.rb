require 'active_support/core_ext'

require 'hashtive_record/initializers/hash'
require 'hashtive_record/initializers/symbol'
require 'hashtive_record/extensions/container'
require 'hashtive_record/extensions/macros'
require 'hashtive_record/storage/database'
require 'hashtive_record/storage/table'
require 'hashtive_record/storage/record'
require 'hashtive_record/base'
require 'hashtive_record/modifier'
require 'hashtive_record/associations'
require 'hashtive_record/loader'
require 'hashtive_record/reflection'  
require 'hashtive_record/associations/belongs_to'
require 'hashtive_record/associations/has_many'
require 'hashtive_record/association_proxies/parent_proxy'
require 'hashtive_record/association_proxies/collection_proxy'

module HashtiveRecord

  
  # Dir.glob("./lib/hashtive_record/initializers/*.rb") {|file| require file}
  # Dir.glob("./lib/hashtive_record/extensions/*.rb") {|file| require file}
  # Dir.glob("./lib/hashtive_record/storage/*.rb") {|file| require file}

  # Dir.glob("./lib/hashtive_record/*.rb") {|file| require file}
  # Dir.glob("./lib/hashtive_record/**/*.rb") {|file| require file}
  
  class RecordError < Exception; end
  
  
end
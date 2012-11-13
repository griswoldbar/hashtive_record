require 'active_support/core_ext'
module HashtiveRecord
  
  
  Dir.glob("./lib/hashtive_record/initializers/*.rb") {|file| require file}
  Dir.glob("./lib/hashtive_record/extensions/*.rb") {|file| require file}
  Dir.glob("./lib/hashtive_record/storage/*.rb") {|file| require file}

  Dir.glob("./lib/hashtive_record/*.rb") {|file| require file}
  Dir.glob("./lib/hashtive_record/**/*.rb") {|file| require file}
  
  class RecordError < Exception; end
  
  
end
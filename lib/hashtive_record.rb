module HashtiveRecord
  require 'active_support/core_ext'

  Dir.glob("./initializers/*.rb") {|file| require file}
  Dir.glob("./lib/extensions/*.rb") {|file| require file}
  Dir.glob("./lib/storage/*.rb") {|file| require file}

  Dir.glob("./lib/*.rb") {|file| require file}
  Dir.glob("./lib/**/*.rb") {|file| require file}
  
  class RecordError < Exception; end
end
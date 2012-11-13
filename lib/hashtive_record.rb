module HashtiveRecord
  require 'rubygems'
  require 'active_support/core_ext'
  require 'yaml'
  
  Dir.glob("./initializers/*.rb") {|file| require file}
  Dir.glob("./lib/extensions/*.rb") {|file| require file}
  Dir.glob("./lib/storage/*.rb") {|file| require file}

  Dir.glob("./lib/*.rb") {|file| require file}
  Dir.glob("./lib/**/*.rb") {|file| require file}
  
  class RecordError < Exception; end
  
  
end
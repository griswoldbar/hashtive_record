require 'active_support'

Dir.glob("./initializers/*.rb") {|file| require file}
Dir.glob("./lib/extensions/*.rb") {|file| require file}
Dir.glob("./lib/storage/*.rb") {|file| require file}

Dir.glob("./lib/*.rb") {|file| require file}
Dir.glob("./lib/**/*.rb") {|file| require file}

# require 'yaml'
# require 'pp'
Dir.glob("./initializers/*.rb") {|file| require file}
Dir.glob("./lib/*.rb") {|file| require file}
Dir.glob("./lib/**/*.rb") {|file| require file}

# require 'yaml'
# require 'pp'
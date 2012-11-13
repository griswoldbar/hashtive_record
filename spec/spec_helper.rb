require 'rspec'
require 'factory_girl'

require './lib/hashtive_record'
Dir.glob("./spec/support/*.rb") {|file| require file}


FactoryGirl.find_definitions

HashtiveRecord::Base.database = HashtiveRecord::Storage::Database.new

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

RSpec.configure do |config|
  config.color_enabled = true
end

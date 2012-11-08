require 'rspec'
require 'factory_girl'

require './requirements'

FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

RSpec.configure do |config|
  config.color_enabled = true
end

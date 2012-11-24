RSpec::Matchers.define :resemble do |expected|
  match do |actual|
    
    #ensures proxies match and object IDs don't matter
    if expected.is_a? Array
      expected.map {|item| item.inspect[25..-1] } == actual.map {|item| item.inspect[25..-1] }
    else
      actual.inspect[25..-1] == expected.inspect[25..-1]
    end
  end
end
require './spec/support/test_classes'
FactoryGirl.define do

  factory :pet do
    initialize_with { Pet.instantiate(build(:record, hash: {jekyll: {name: "Jekyll"}})) }
  
  end
  
  factory :person do
    initialize_with { Person.instantiate(build(:record, hash: {bob: {name: "Bob"}}))}
  end
end
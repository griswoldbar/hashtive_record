require './spec/support/test_classes'
FactoryGirl.define do

  factory :pet do
    initialize_with { new(build(:record, hash: {jekyll: {name: "Jekyll", person_id: :jim}})) }
  end
  
  factory :person do
    initialize_with { new(build(:record, hash: {bob: {name: "Bob"}}))}
  end
end
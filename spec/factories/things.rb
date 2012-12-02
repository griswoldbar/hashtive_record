FactoryGirl.define do
  factory :thing, :class => Class.new do
    sequence(:id)   {|n| "thing-#{n}".to_sym}
    sequence(:name) {|n| "Thing #{n}" }
    description "A non-descript thing"
    modifiers OpenStruct.new
    klass { FactoryGirl.build(:model_klass) }
    initialize_with { klass.build(id, {name: name, description: description, modifiers: modifiers})}
  end


end
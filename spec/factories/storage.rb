FactoryGirl.define do
  factory :database, class: HashtiveRecord::Storage::Database do
    
  end
  
  factory :table, class: HashtiveRecord::Storage::Table do
    initialize_with { new(id) }
  end
  
  factory :record, class: HashtiveRecord::Storage::Record do
    hash { { jim: {name: "Jimbo Jones", age: 12} } }
    initialize_with { new(hash) }
  end
  
  factory :thing_record, class: HashtiveRecord::Storage::Record do
    sequence(:id)   {|n| "thing-#{n}".to_sym}
    sequence(:name) {|n| "Thing #{n}" }
    description "A non-descript thing"
    modifiers OpenStruct.new
    klass { FactoryGirl.build(:model_klass) }
    initialize_with { new( {id => {name: name, description: description, modifiers: modifiers}} )}  
  end
  
end
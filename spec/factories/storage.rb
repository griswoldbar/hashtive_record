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
  
end
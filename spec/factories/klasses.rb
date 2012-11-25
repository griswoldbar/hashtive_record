FactoryGirl.define do
  factory :model_klass, :class => Class do
    sequence(:name) { |n| "ModelType#{n}"}
    initialize_with { 
      table_name = (name.downcase+"s").to_sym
      table = HashtiveRecord::Storage::Table.new(table_name)
      HashtiveRecord::Base.database << table
      klass = Object.const_set(name, Class.new(HashtiveRecord::Base))
      klass.table_name = table_name
      klass
    }
  end
end

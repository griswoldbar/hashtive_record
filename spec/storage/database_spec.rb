require 'spec_helper'
require 'support/shared_examples_for_container'

describe "HashtiveRecord::Storage::Database" do
  let(:database) { build(:database) }

  
  describe ".new" do
    it "initializes an array" do
      database.tables.should == []
    end
  end
  
  it_behaves_like "container" do
    let(:container) { database }
    let(:thing1)   { build(:table, id: :blah) }
    let(:thing2)   { build(:table, id: :plop) }
  end
    
  

end
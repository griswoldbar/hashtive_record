shared_examples_for "container" do
  
  describe "#find" do
    it "finds the thing with that id" do
      container.collection = [thing1,thing2]
      container.find(:plop).should == thing2
      container.find(:blah).should == thing1
    end
  end
  
  describe "#method_missing" do
    it "delegates missing methods to its set of things" do
      container.collection.should_receive(:poop)
      container.poop
    end

    it "further delegates methods to its own find method" do
      container.collection = [thing1,thing2]
      container.plop.should == thing2
      container.blah.should == thing1
    end
  end
  

end
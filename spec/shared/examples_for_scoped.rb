shared_examples_for "scoped" do
  before(:each) do
    @instance = create(scoped_class.name.downcase.to_sym)
  end

  it "should respond to :scoped_id" do
    @instance.should respond_to(:scoped_id)
  end

  it "should respond to :to_param" do
    @instance.should respond_to(:scoped_id)
  end

  it "should report :scoped_id as the value for :to_param" do
    @instance.scoped_id = @instance.id + 1
    @instance.scoped_id.should_not eq(@instance.id)
    @instance.to_param.should eq(@instance.scoped_id)
  end
end
require 'spec_helper'

describe "core extensions" do
  describe "Kernel.debug" do
    it "should return a Binding object" do
      debug.is_a?(Binding).should be_true
    end

    it "should allow evaluation of local variables in the binding" do
      eval("my_variable", debug_with_my_variable).should == 5
    end
  end

  describe "Binding" do
    it "should have a log method" do
      args = ["a debug message", 'var1', 'var2']
      the_binding = binding
      DebugLog.expects(:log).with(the_binding, *args)
      the_binding.log(*args)
    end
  end

  def debug_with_my_variable
    my_variable = 5
    debug
  end
end

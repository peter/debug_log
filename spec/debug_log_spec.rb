require 'spec_helper'
require 'logger'

describe DebugLog do
  describe "log" do
    before do
      @comment = "a debug printout"
      @expression_string = "expression string"
      @the_binding = binding
      @calling_method = "calling method"
      @expected_message = [DebugLog.prefix, @comment, @expression_string, @calling_method].join(DebugLog.separator)
      DebugLog.stdout = true
      DebugLog.enabled = true
      @logger_before = DebugLog.logger
      @enabled_before = DebugLog.enabled
    end
    
    after do
      # Reset default values
      DebugLog.logger = @logger_before
      DebugLog.enabled = @enabled_before
    end

    it "should output a message and a number of variables to stdout" do
      DebugLog.logger = nil

      log_expectations
      DebugLog.expects(:puts).with(@expected_message)

      invoke_log
    end

    it "does not output to stdout if DebugLog.stdout is false" do
      DebugLog.stdout = false

      log_expectations
      DebugLog.expects(:puts).never

      invoke_log
    end

    it "invokes info on the logger object if there is one" do
      logger = Logger.new($stdout)
      DebugLog.logger = logger

      log_expectations
      DebugLog.expects(:puts).with(@expected_message)
      logger.expects(:info).with(@expected_message)

      invoke_log
    end

    it "does nothing if DebugLog.enabled = false" do
      DebugLog.enabled = false

      DebugLog.expects(:puts).never

      invoke_log
    end

    def log_expectations
      DebugLog.expects(:calling_method).returns(@calling_method)
      DebugLog.expects(:expression_string).with(@the_binding, 'my_var', 'my_var[0]').returns(@expression_string)
    end

    def invoke_log
      DebugLog.log(@the_binding, @comment, 'my_var', 'my_var[0]')      
    end
  end

  describe "logger" do
    it "defaults to nil but can be initialized to a logger object" do
      DebugLog.logger.should be_nil
      logger = Logger.new($stdout)
      DebugLog.logger = logger
      DebugLog.logger.should == logger
    end
  end

  describe "stdout" do
    it "is true by default but can be set to false" do
      DebugLog.stdout.should be_true
      DebugLog.stdout = false
      DebugLog.stdout.should be_false
    end
  end

  describe "enabled" do
    it "is true by default but can be set to false" do
      DebugLog.enabled.should be_true
      DebugLog.enabled = false
      DebugLog.enabled.should be_false
    end
  end

  describe "calling_method" do
    it "should get the calling method from the Kernel.caller stack, three steps up" do
      method_that_invokes_debug_log.should =~ /method_that_invokes_debug_log/
    end

    def method_that_invokes_debug_log
      invoke_binding_log
    end

    def invoke_binding_log
      invoke_debug_log
    end

    def invoke_debug_log
      DebugLog.calling_method
    end
  end

  describe "format_value" do
    it "invokes inspect by default" do
      the_value = [:foo, :bar]
      DebugLog.format_value(the_value).should == the_value.inspect
    end
  end

  describe "format_expression" do
    it "evaluates an expression and also prints the class" do
      the_value = [:foo, :bar]
      formated_value = "formated value"
      DebugLog.expects(:format_value).with(the_value).returns(formated_value)
      expected_format = %Q{the_value="#{formated_value}" (#{the_value.class.name})}
      DebugLog.format_expression(binding, 'the_value').should == expected_format
    end
  end

  describe "separator" do
    it "returns pipe by default" do
      DebugLog.separator.should == " | "
    end
  end

  describe "expression_string" do
    it "creates a comma separated key-value string from a number of expressions and a binding object" do
      my_var = "Peter"
      the_binding = binding
      expressions = ['my_var', 'my_var[0,1]']
      formats = ['my_var formated', 'myvar[0,1] formated']
      DebugLog.expects(:format_expression).with(the_binding, 'my_var').returns(formats[0])
      DebugLog.expects(:format_expression).with(the_binding, 'my_var[0,1]').returns(formats[1])
      expected_string = formats.join(", ")      
      DebugLog.expression_string(the_binding, 'my_var', 'my_var[0,1]').should == expected_string
    end
  end

  describe "prefix" do
    it "returns class name by default" do
      DebugLog.prefix.should == "DebugLog"
    end
  end
end

module Kernel
  alias_method :debug, :binding
end

class Binding
  def log(comment, *expressions)
    DebugLog.log(self, comment, *expressions)
  end
end

module DebugLog
  mattr_accessor :logger
  self.logger = nil

  mattr_accessor :stdout
  self.stdout = true

  mattr_accessor :enabled
  self.enabled = true

  def self.prefix
    name
  end

  def self.separator
    " | "
  end

  def self.log(binding, comment, *expressions)
    return unless enabled
    message = [prefix, comment, expression_string(binding, *expressions), calling_method].join(separator)
    puts(message) if stdout
    logger.info(message) if logger
  end

  def self.expression_string(binding, *expressions)
    expressions.map { |expression| format_expression(binding, expression) }.join(", ")
  end

  def self.calling_method
    Kernel.caller(3).first
  end

  def self.format_value(value)
    value.inspect
  end

  def self.format_expression(binding, expression)
    value = eval(expression, binding)
    %Q{#{expression}="#{format_value(value)}" (#{value.class.name})}
  end
end

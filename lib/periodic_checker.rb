require 'eventmachine'

module PeriodicChecker
  def self.error_handler(*args, &block)
    EventMachine.error_handler(*args, &block)
  end

  def self.run(&block)
    EventMachine.run { Group.start(&block) }
  end
end

require "periodic_checker/version" unless PeriodicChecker.const_defined?(:VERSION)
require 'periodic_checker/watch'
require 'periodic_checker/group'
module PeriodicChecker
  class Group
    include Enumerable

    def self.start(*args, &block)
      self.new(*args, &block).start
    end

    def initialize(&block)
      @checkers = []
      @running = false
      block.call(self) if block_given?
    end

    def each(&block)
      @checkers.each(&block)
    end

    def add(*args, &block)
      @checkers << Watch.new(*args, &block)
    end

    def running?
      @running
    end

    def start
      unless self.running?
        self.each do |checker|
          checker.start
        end
        @running = true
      end
      self
    end

    def stop
      if self.running?
        self.each do |checker|
          checker.stop
        end
        @running = false
      end
      self
    end

    def stop!
      self.stop
      EventMachine.stop
    end
  end
end
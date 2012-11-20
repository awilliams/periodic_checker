module PeriodicChecker
  class Group
    include Enumerable

    def self.start(*args, &block)
      self.new(*args, &block).start
    end

    def self.start!(*args, &block)
      self.new(*args, &block).start!
    end

    def initialize(&block)
      @watchers = []
      @running = false
      block.call(self) if block_given?
    end

    def each(&block)
      @watchers.each(&block)
    end

    def add_watcher(watch)
      @watchers << watch
      watch
    end

    def every(*args, &block)
      self.add_watcher(Watch.new(*args, &block))
    end

    def running?
      @running
    end

    def start_watchers(&each_watcher)
      unless self.running?
        self.each(&each_watcher)
        @running = true
      end
      self
    end

    def start
      self.start_watchers { |watcher| watcher.start }
    end

    def start!
      self.start_watchers { |watcher| watcher.start! }
    end

    def stop
      if self.running?
        self.each do |watcher|
          watcher.stop
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
module PeriodicChecker
  class Watch
    attr_reader :interval

    def initialize(interval)
      @interval = interval
      @previous_value = nil
      @running = false
      @checking_for_updates = false
      self
    end

    def start
      @timer = EventMachine::PeriodicTimer.new(self.interval) { self.check_for_updates }
      @running = true
      self
    end

    def stop
      @timer.cancel
      @running = false
      self
    end

    def do_on_change(&block)
      @do_update = block
      self
    end

    def check_for_change(&block)
      @check_update = Proc.new do
        block.call(self)
      end
      self
    end

    def check_for_change!(&block)
      @check_update = Proc.new do
        self.check_for_update_callback(block.call(self))
      end
    end

    def to_proc
      self.check_for_update_callback
    end

    def check_for_update_callback
      @check_for_update_callback ||= Proc.new do |new_value|
        self.on_new_value(new_value)
      end
    end

    def on_change(previous_value = nil, current_value = nil)
      if @do_update.arity < 1
        @do_update.call
      elsif @do_update.arity == 1
        @do_update.call(previous_value)
      else
        @do_update.call(previous_value, current_value)
      end
    end

    def on_change!(*args)
      begin
        result = self.on_change(*args)
      rescue StopIteration
        self.stop
      end
      result
    end

    def on_new_value(new_value)
      if new_value != @previous_value
        on_change!(@previous_value, new_value)
        @previous_value = new_value
      end
    end

    def check_for_updates
      if @check_update
        @check_update.call
      else
        self.on_change!
      end
    end
  end
end
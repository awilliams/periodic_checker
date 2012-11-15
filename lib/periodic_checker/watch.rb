module PeriodicChecker
  class Watch
    # if proc_to_check is nil, an update is always triggered
    def initialize(interval, proc_to_check = nil, &on_change)
      @interval = interval
      @proc_to_check = proc_to_check
      @previous_value = @proc_to_check && @proc_to_check.call
      @block = on_change
      @running = false
    end

    def start
      @timer = EventMachine::PeriodicTimer.new(@interval) { self.check_for_updates }
      @running = true
      self
    end

    def stop
      @timer.cancel
      @running = false
      self
    end

    def execute(previous_val = nil, current_val = nil)
      if @block.arity < 1
        @block.call
      elsif @block.arity == 1
        @block.call(previous_val)
      else
        @block.call(previous_val, current_val)
      end
    end

    def execute!(*args)
      begin
        result = self.execute(*args)
      rescue StopIteration
        # stop this checker
      ensure
        self.stop
      end
      result
    end

    def check_for_updates
      if @proc_to_check
        current_value = @proc_to_check.call
        if current_value != @previous_value
          execute!(@previous_value, current_value)
          @previous_value = current_value
        end
      else
        execute!
      end
    end
  end
end
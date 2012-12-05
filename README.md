# PeriodicChecker

Ruby library which helps create groups of EventMachine::PeriodicTimers. Each checker has a #check method which is called periodically and an #update method which is called when #check is true

## Installation

Add this line to your application's Gemfile:

    gem 'periodic_checker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install periodic_checker

## Usage

### Basic Usage
```ruby
EventMachine.run do
  # create a watcher group and start all the watchers
  @checker = PeriodicChecker::Group.start! do |group|
    # create watcher which checks every 2s
    watcher = PeriodicChecker::Watch.new(2)
    # this block is checked every interval for changes (notice bang)
    watcher.check_for_change! { puts 'checking...'; rand(2) }
    # when a change happens, this block is executed
    watcher.do_on_change do |previous_value, current_value|
      puts "change detected, previously #{previous_value.inspect} is now #{current_value.inspect}"
    end
    # add this watcher to the watcher group
    group.add_watcher(watcher)
  end
  trap(:INT) {
    @checker.stop!
    puts "#{@checker.count} checkers & EventMachine stopped stopped"
  }
end
```

### Less Basic Usage
```ruby
EventMachine.run do
  def long_running_query(&on_query_result)
    # do some long running non-blocking stuff
    puts 'checking...'
    on_query_result.call(rand(2))
  end
  # create a watcher group and start all the watchers
  @checker = PeriodicChecker::Group.start! do |group|
    # create watcher which checks every 2s
    watcher = PeriodicChecker::Watch.new(2)
    # this block is checked every interval for changes (notice non-bang)
    # Watcher#to_proc is a proc which receives the value to compare with the previous value
    watcher.check_for_change { |w| long_running_query(&w) }
    # when a change happens, this block is executed
    watcher.do_on_change do |previous_value, current_value|
      puts "change detected, previously #{previous_value.inspect} is now #{current_value.inspect}"
    end
    # add this watcher to the watcher group
    group.add_watcher(watcher)
  end
  trap(:INT) {
    @checker.stop!
    puts "#{@checker.count} checkers & EventMachine stopped stopped"
  }
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

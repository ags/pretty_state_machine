Pretty State Machine
====================

Usage
-----

```ruby
class Reznor < PrettyStateMachine::Machine
  state :up_above_it, initial: true

  state :down_in_it

  state :gave_up

  transition :get_down! do
    from :up_above_it
    to :down_in_it
  end

  transition :give_up! do
    from :up_above_it, :down_in_it
    to :gave_up
  end
end

>> machine = Reznor.new
>> machine.state.name
=> :up_above_it
>> machine.get_down!
>> machine.state.name
=> :down_in_it
```

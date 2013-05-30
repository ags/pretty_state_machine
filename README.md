[![Build Status](https://travis-ci.org/ags/pretty_state_machine.png?branch=master)](https://travis-ci.org/ags/pretty_state_machine)

Pretty State Machine
====================

Simple FSM class-oriented DSL. Somewhere between [MicroMachine](https://github.com/soveran/micromachine) and [state_machine](https://github.com/pluginaweek/state_machine/).

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

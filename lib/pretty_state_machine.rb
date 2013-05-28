require 'pretty_state_machine/machine'

module PrettyStateMachine
  InvalidMachine = Class.new(Exception)
  InvalidTransition = Class.new(Exception)
  InvalidState = Class.new(Exception)
end

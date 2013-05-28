require 'pretty_state_machine/machine'
require 'pretty_state_machine/state'
require 'pretty_state_machine/transition'

module PrettyStateMachine
  InvalidMachine = Class.new(Exception)
  InvalidTransition = Class.new(Exception)
  InvalidState = Class.new(Exception)
end

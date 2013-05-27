require 'forwardable'

module PrettyStateMachine
  class Machine
    def self.states
      @_states ||= {}
    end

    def self.transitions
      @_transitions ||= {}
    end

    def self.initial_state
      states.values.find(&:initial?)
    end

    def self.state(name, initial: false)
      state = State.new(name, initial: initial)
      states[name] = state
    end

    def self.transition(name, &block)
      transition = Transition.new(self, name)
      transition.instance_eval(&block)

      define_method(name) do
        if transition.permitted_from?(@state)
          @state = transition.to_state
        else
          raise InvalidTransition, "cannot transition to '#{transition.to_state}' via '#{name}' from '#{@state}'"
        end
      end

      if transition.to_state.nil?
        raise InvalidTransition, "transition '#{name}' requires an end state"
      end

      transitions[name] = transition
    end

    def initialize(state=nil)
      if state.nil?
        @state = self.class.initial_state
      else
        @state = self.class.states.fetch(state) { raise InvalidMachine }
      end

      if @state.nil?
        raise InvalidMachine.new('an initial state is required')
      end
    end

    def state
      @state.name
    end

    protected

    def self.state_from_name(state_name)
      states.fetch(state_name) do
        raise InvalidState.new("#{state_name} is invalid state")
      end
    end

  end

  class State
    extend Forwardable

    attr_reader :name

    def_delegator :name, :to_s

    def initialize(name, initial: false)
      @name = name
      @initial = initial
    end

    def initial?
      @initial
    end
  end

  class Transition
    attr_reader :to_state

    def from(*state_names)
      @from_states = state_names.flatten.compact.map { |state_name|
        @machine_class.state_from_name(state_name)
      }
    end

    def to(state_name)
      @to_state = @machine_class.state_from_name(state_name)
    end

    def initialize(machine_class, name)
      @machine_class = machine_class
      @name = name
      @from_states = []
    end

    def permitted_from?(state)
      @from_states.include?(state)
    end
  end

  InvalidMachine = Class.new(Exception)
  InvalidTransition = Class.new(Exception)
  InvalidState = Class.new(Exception)
end

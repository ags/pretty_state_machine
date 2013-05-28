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

    def initialize(state=self.class.initial_state)
      raise InvalidMachine.new('an initial state is required') if state.nil?
      @state = State(state)
    end

    def state
      @state.name
    end

    protected

    def self.state_from_name(state_name)
      states.fetch(state_name) do
        raise InvalidState.new("'#{state_name}' is an invalid state")
      end
    end

    def State(arg)
      case arg
      when State then arg
      when Symbol then self.class.state_from_name(arg)
      else
        raise TypeError, "cannot convert #{arg.inspect} to State"
      end
    end

  end
end

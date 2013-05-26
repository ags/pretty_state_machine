require 'set'

module PrettyStateMachine
  class Machine
    def self.states
      @states ||= {}
    end

    def self.transitions
      @transitions ||= {}
    end

    def self.initial_state
      @states.values.find(&:initial?)
    end

    def self.state(name, options={}, &block)
      state = State.new(name, initial: options[:initial])
      state.instance_eval(&block) if block_given?
      states[name] = state
    end

    def self.transition(name, &block)
      transition = Transition.new(name)
      transition.instance_eval(&block)

      define_method(name) do
        if transition.permitted_from?(@state.name)
          @state = self.class.states[transition.to_state_name]
        else
          raise InvalidTransition, "cannot transition to '#{transition.to_state_name}' via '#{name}' from '#{@state.name}'"
        end
      end

      transitions[name] = transition
    end

    def initialize(state=nil)
      @state = self.class.states.fetch(state) { self.class.initial_state }
      if @state.nil?
        raise InvalidMachine.new('an initial state is required')
      end
    end

    def state
      @state.name
    end
  end

  class State
    attr_reader :name

    def initialize(name, initial: false)
      @name = name
      @initial = initial
    end

    def initial?
      @initial
    end
  end

  class Transition
    attr_reader :to_state_name
    attr_reader :from_state_names

    def from(state_names)
      @from_state_names = Set.new(state_names)
    end

    def to(state_name)
      @to_state_name = state_name
    end

    def initialize(name)
      @name = name
      @from_state_names = Set.new
    end

    def permitted_from?(state_name)
      from_state_names.include?(state_name)
    end
  end

  InvalidMachine = Class.new(Exception)
  InvalidTransition = Class.new(Exception)
end

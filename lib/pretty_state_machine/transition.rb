module PrettyStateMachine
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

end

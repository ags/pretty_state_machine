module PrettyStateMachine
  module ClassExtensions
    def state_machine(klass, attribute: :state)
      include PrettyStateMachine::Extensions

      instance_eval do
        define_method(attribute) do
          _machine(attribute).state
        end

        klass.transitions.each do |name, transition|
          define_method(transition.name) do
            _machine(attribute).transition_via(transition)
          end
        end
      end
    end
  end

  module Extensions
    private
    def _machine(attribute)
      @_machine ||= Machine.new(self, attribute)
    end
  end

  class Transition < Struct.new(:name, :from, :to)
    def valid_from?(state)
      from.include?(state)
    end
  end

  class Machine
    attr_reader :state

    def self.initial_state(name)
      @@initial_state = name
    end

    # TODO to should be required, from not
    def self.transition(name, from: nil, to: nil)
      @@transitions ||= {}
      @@transitions[name] = Transition.new(name, from, to)
    end

    def self.transitions
      @@transitions
    end

    def self.state(*)
    end

    def initialize(master, attribute)
      @master = master
      @state = @@initial_state
    end

    def transition_via(transition)
      if transition.valid_from?(@state)
        @state = transition.to
      else
        raise InvalidTransition.new("cannot transition to '#{transition.to}' via '#{transition.name}' from '#{@state}'")
      end
    end

  end

  InvalidTransition = Class.new(Exception)
end

Class.class_eval do
  include PrettyStateMachine::ClassExtensions
end

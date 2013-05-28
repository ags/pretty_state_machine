require 'forwardable'

module PrettyStateMachine
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
end

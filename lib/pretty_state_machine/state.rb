require 'forwardable'

module PrettyStateMachine
  class State
    extend Forwardable

    attr_reader :name

    def_delegator :name, :to_s

    def initialize(name, options={})
      @name = name
      @initial = options.fetch(:initial) { false }
    end

    def initial?
      @initial
    end

  end
end

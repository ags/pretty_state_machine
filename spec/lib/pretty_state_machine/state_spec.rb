require './lib/pretty_state_machine'

describe PrettyStateMachine::State do
  describe "#initial?" do
    it "is false by default" do
      state = PrettyStateMachine::State.new(:foobar)
      expect(PrettyStateMachine::State.new(:foobar).initial?).to be_false
    end

    it "is true when state is created with 'initial' parameter" do
      state = PrettyStateMachine::State.new(:foobar, initial: true)
      expect(state.initial?).to be_true
    end
  end

  describe "#to_s" do
    it "returns the state name" do
      state = PrettyStateMachine::State.new(:foobar, initial: true)
      expect(state.to_s).to eq('foobar')
    end
  end
end

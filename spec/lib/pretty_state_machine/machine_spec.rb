require './lib/pretty_state_machine'

describe PrettyStateMachine::Machine do
  class Empty < PrettyStateMachine::Machine; end

  class Reznor < PrettyStateMachine::Machine
    state :up_above_it, initial: true

    state :down_in_it

    state :gave_up

    transition :get_down! do
      from :up_above_it
      to :down_in_it
    end

    transition :give_up! do
      from :down_in_it
      to :gave_up
    end
  end

  it "sets state to provided initial state on creation" do
    expect(Reznor.new.state.name).to eq(:up_above_it)
  end

  it "initial state can be overriden on initialization" do
    expect(Reznor.new(:down_in_it).state.name).to eq(:down_in_it)
  end

  it "raises InvalidMachine without an initial state" do
    expect do
      Empty.new
    end.to raise_error(PrettyStateMachine::InvalidMachine,
                       'an initial state is required')
  end

  it "defines transition methods that change state" do
    machine = Reznor.new
    expect do
      machine.get_down!
    end.to change { machine.state.name }.from(:up_above_it).to(:down_in_it)
  end

  it "does not allow definition of transitions without a to" do
    expect do
      class NoTransitionTo < PrettyStateMachine::Machine
        state :foo, initial: true
        transition :bar do from :foo end
      end
    end.to raise_error(PrettyStateMachine::InvalidTransition,
                       "transition 'bar' requires an end state")
  end

  it "enforces transition from declarations" do
    machine = Reznor.new
    expect do
      machine.give_up!
    end.to raise_error(PrettyStateMachine::InvalidTransition,
                       "cannot transition to 'gave_up' via 'give_up!' from 'up_above_it'")
    expect(machine.state.name).to eq(:up_above_it)
  end

  context "when given an invalid initial state" do
    it "raises PrettyStateMachine::InvalidState" do
      expect do
        Reznor.new(:foobar)
      end.to raise_error(PrettyStateMachine::InvalidState,
                         "'foobar' is an invalid state")
    end
  end

end

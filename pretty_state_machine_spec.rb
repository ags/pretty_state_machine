require_relative 'pretty_state_machine'

describe PrettyStateMachine do

  class Reznor < PrettyStateMachine::Machine
    initial_state :up_above_it

    transition :get_down,
      from: [:up_above_it],
      to: :down_in_it

    state :down_in_it
  end

  class Foo; state_machine Reznor; end
  class Bar; state_machine Reznor, attribute: :baz; end

  it "allows declaration of an initial state" do
    expect(Foo.new.state).to eq(:up_above_it)
  end

  it "allows transitions via methods" do
    machine = Foo.new
    expect do
      machine.get_down
    end.to change { machine.state }.to(:down_in_it)
  end

  it "throws InvalidTransition for invalid transitions" do
    machine = Foo.new
    machine.get_down
    expect do
      machine.get_down
    end.to raise_error(PrettyStateMachine::InvalidTransition, "cannot transition to 'down_in_it' via 'get_down' from 'down_in_it'")
  end

  it "allows specification of state attribute" do
    expect(Bar.new.baz).to eq(:up_above_it)
  end
end

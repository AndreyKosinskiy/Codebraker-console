RSpec.describe ConsoleMenu::RegistrationMenu::Registration do
  let(:commands) do
    { valid_name: 'Rickis', invalid_name: 'R', exit: 'exit',
      valid_difficult: { name: 'easy', attempts: 15, hints: 2 } }
  end
  let(:player) { class_double(BeforeGame::RegistrationPlayer) }
  let(:difficult) { BeforeGame::DifficultChooser }
  let(:state) { { temp: 1 } }
  let(:described_instance) { described_class.new(state: state, player_object: player, difficult_object: difficult) }

  it 'correct initialization' do
    expect(described_instance).to be_a(described_class)
  end

  it 'init separator variables' do
    described_instance.separators_init(separator_begin: '*!*')
    expect(described_instance.instance_variable_get(:@separator_begin)).to eq('*!*')
  end

  describe '#create_player' do
    it 'create player' do
      allow(player).to receive(:new).with(name: commands[:valid_name]).and_return(true)
      allow(described_instance).to receive(:gets).and_return(commands[:valid_name])
      expect(described_instance.create_player).to eq(nil)
    end

    it 'exit from console if player name is "exit" ' do
      allow(described_instance).to receive(:gets).and_return(commands[:exit])
      expect { described_instance.create_player }.to raise_error(SystemExit)
    end

    describe '#check_player' do
      it 'return true if player valid' do
        allow(player).to receive(:new).with(name: commands[:valid_name]).and_return(true)
        expect(described_instance.check_player(commands[:valid_name])).to be true
      end

      it 'return false if player invalid' do
        allow(player).to receive(:new).and_raise(ArgumentError, 'message error')
        allow(STDOUT).to receive(:puts).with('message error')
        allow(STDOUT).to receive(:puts).with('=> Please, try again')
        expect(described_instance.check_player(commands[:valid_name])).to be false
      end
    end
  end

  describe '#choose_difficul' do
    it 'show part of readable player name' do
      described_instance.instance_variable_set(:@separator_after_name, ' - :')
      expect(described_instance.raw_name(commands[:valid_name])).to eq(commands[:valid_name] + ' - :')
    end

    it 'show part of readable attempts' do
      described_instance.instance_variable_set(:@separator_after_attempts, ' - :')
      expect(described_instance.raw_attempts(commands[:valid_name])).to eq(commands[:valid_name] + ' - :')
    end

    it 'show part of readable hint' do
      described_instance.instance_variable_set(:@separator_after_hints, ' - :')
      expect(described_instance.raw_hint(commands[:valid_name])).to eq(commands[:valid_name] + ' - :')
    end

    it 'output correct full template menu row' do
      expect(described_instance.template_menu_row(name: 'str',
                                                  attempts: 1,
                                                  hints: 1)).to eq("str. - 1 attempts, 1 hints.\n")
    end

    it 'correct input difficult variant' do
      allow(difficult).to receive(:new).with(difficult_variant: commands[:valid_difficult])
      expect(described_instance.check_difficult_variant(commands[:valid_difficult])).to be true
    end

    it 'input unknown difficult variant' do
      expect(described_instance.check_difficult_variant(nil)).to be false
    end

    it ' print all avaliable difficult' do
      allow(described_instance).to receive(:template_menu_row).and_return('time')
      # expect(described_instance).to receive(:template_menu_row).exactly(3).times
      expect { described_instance.difficult_to_menu }.to output("timetimetime\n").to_stdout
    end

    it 'return difficult by input name' do
      expect(described_instance.difficult_by_name(commands[:valid_difficult][:name])).to eq(commands[:valid_difficult])
    end

    it 'exit from choose_difficult' do
      allow(described_instance).to receive(:gets).and_return(commands[:exit])
      # Error when stub constant
      allow(described_instance).to receive(:difficult_to_menu).and_return(true)
      expect { described_instance.choose_difficult }.to raise_error(SystemExit)
    end

    it 'return difficult' do
      allow(described_instance).to receive(:gets).and_return('easy')
      allow(described_instance).to receive(:difficult_to_menu).and_return(true)
      allow(described_instance).to receive(:difficult_by_name).and_return(commands[:valid_difficult])
      allow(described_instance).to receive(:check_difficult_variant).and_return(true)
      described_instance.choose_difficult
    end
  end

  describe '#run' do
    it 'call func create_player before choose_difficult' do
      allow(described_instance).to receive(:create_player)
      allow(described_instance).to receive(:choose_difficult)
      described_instance.run
    end
  end
end

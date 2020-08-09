RSpec.describe ConsoleMenu::GameMenu::Game do
  let(:difficult) { instance_double(BeforeGame::DifficultChooser) }
  let(:player) { instance_double(BeforeGame::RegistrationPlayer) }
  let(:game) { class_double(Game::CodeBreaker) }
  let(:row) { instance_double('Statistic::StatisticRow') }
  let(:game_instance) do
    instance_double(Game::CodeBreaker, player_win?: false,
                                       can_use_attempts?: true,
                                       my_guess: [true, true, true, true], hint: '1')
  end
  let(:state) { { sheet: instance_double('Statistic::StatisticSheet', new_row: nil) } }
  let(:described_instance) { described_class.new(state: state, game: game, player: player, difficult: difficult) }
  let(:commands) { { guess: 'guess', hint: 'hint', exit: 'exit', invalid_command: 'invalid_command' } }

  describe '#initialize' do
    it 'correct initialize' do
      allow(game).to receive(:new).and_return(instance_double('Game::CodeBreaker'))
      expect(described_class.new(state: state, game: game,
                                 player: player, difficult: difficult)).to be_a(described_class)
    end
  end

  describe '#run' do
    before do
      # allow_any_instance_of(Game::CodeBreaker).to receive(:player_win?).and_return(false)
      allow(game).to receive(:new).and_return(game_instance)
      allow(described_instance).to receive(:loop).and_yield
    end

    it 'show menu' do
      expect { described_instance.show_menu }.to output("1. guess\n2. hint\n3. exit\n").to_stdout
    end

    it 'if put "hint call hint func"' do
      allow(described_instance).to receive(:gets).and_return(commands[:hint])
      allow(described_instance).to receive(:hint).once
      described_instance.run
    end

    it 'break when guess' do
      allow(described_instance).to receive(:guess).and_return(1)
      allow(described_instance).to receive(:gets).and_return(commands[:guess])
      expect(described_instance.run).to be_nil
    end

    it 'exit form game if put "exit"' do
      allow(described_instance).to receive(:gets).and_return(commands[:exit])
      expect { described_instance.run }.to raise_error(SystemExit)
    end

    it 'if wrong command, put warning message' do
      allow(described_instance).to receive(:gets).and_return(commands[:invalid_command])
      allow(described_instance).to receive(:puts).twice
      described_instance.run
    end

    it 'return result guess' do
      allow(described_instance).to receive(:gets).and_return('sdf')
      allow(described_instance).to receive(:check_guess)
      described_instance.guess
    end

    it 'put hint' do
      allow(STDOUT).to receive(:puts).with('1')
      described_instance.hint
    end

    it 'put warning on call hint' do
      allow(game_instance).to receive(:hint).and_return(nil)
      expect { described_instance.hint }.to output("You have not any hints left\n").to_stdout
    end
  end

  describe '#check_win?' do
    before do
      allow(game).to receive(:new).and_return(game_instance)
    end

    it 'if not win return ' do
      allow(game_instance).to receive(:player_win?).with(true).and_return(false)
      expect(described_instance.check_win(true)).to be_nil
    end

    it 'if win offer for save result' do
      allow(game_instance).to receive(:player_win?).with(true).and_return(true)
      allow(STDOUT).to receive(:puts).with("You win!\n Save result?(Yes/No)")
      allow(described_instance).to receive(:gets).and_return('no')
      described_instance.check_win(true)
    end

    it 'save result' do
      allow(game_instance).to receive(:current_stat).and_return(row)
      allow(state[:sheet]).to receive(:new_row=)
      allow(state[:sheet]).to receive(:store)
      expect(described_instance.save_game_result).to be_nil
    end
  end

  describe '#check_lose' do
    before do
      allow(game).to receive(:new).and_return(game_instance)
    end

    it 'return if can use attempts' do
      expect(described_instance.check_lose).to be_nil
    end

    it 'return 1 cant use attempts' do
      allow(game_instance).to receive(:can_use_attempts?).and_return(false)
      expect(described_instance.check_lose).to eq(1)
    end
  end

  describe '#check_guess' do
    before do
      allow(game).to receive(:new).and_return(game_instance)
    end

    it 'return 1 if win' do
      allow(described_instance).to receive(:check_win).and_return(1)
      expect(described_instance.check_guess(true)).to eq(1)
    end

    it 'return 1 if lose' do
      allow(described_instance).to receive(:check_win).and_return(0)
      allow(described_instance).to receive(:check_lose).and_return(1)
      expect(described_instance.check_guess(true)).to eq(1)
    end

    it 'return error msg if error' do
      allow(game_instance).to receive(:my_guess).and_raise(ArgumentError)
      allow(STDOUT).to receive(:puts)
      described_instance.check_guess(true)
    end
  end
end

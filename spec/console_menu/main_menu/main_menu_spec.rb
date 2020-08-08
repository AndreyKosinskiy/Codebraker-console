RSpec.describe ConsoleMenu::MainMenu::Main do
  let(:err_msg) { 'File for rules do not exists' }
  let(:commands) { { start: 'start', stat: 'stat', rule: 'rule', exit: 'exit', invalid: 'invalid' } }
  let(:sheet) { instance_double('Statistic::StatisticSheet') }
  let(:curr_inst) do
    allow(sheet).to receive(:is_a?).and_return(true)
    allow(sheet).to receive(:load).and_return(false)
    allow(File).to receive(:exist?).with('mock_file').and_return(true)
    described_class.new(rule_file_path: 'mock_file', sheet: sheet)
  end
  let(:rule_file) { class_double('Temp') }
  let(:rule_content) { 'rule readed' }
  let(:statistic_row) do
    instance_double('TmpRow', rating: 1, player_name: 'tempname', difficult_name: 'easy',
                              init_attempts_count: 1, used_attempts_count: 1,
                              init_hints_count: 1, used_hints_count: 1)
  end

  it 'fail initialization when file for rules do not exists' do
    expect do
      described_class.new(rule_file_path: 'do_not_exists.file',
                          sheet: nil)
    end.to raise_error(ArgumentError, err_msg)
  end

  it 'fail intitializaton when sheet arg is not Statistic::StatisticSheet' do
    err_msg = 'Sheet must be type of Statistic::StatisticSheet'
    allow(File).to receive(:exist?).with('mock_file').and_return(true)

    expect { described_class.new(rule_file_path: 'mock_file', sheet: nil) }.to raise_error(ArgumentError, err_msg)
  end

  it 'correct initialization' do
    expect(curr_inst).to be_a(described_class)
  end

  it ' must show main menu' do
    message = "1. Start\n2. Rule\n3. Stat\n4. Exit\nEnter your choice: "
    allow(STDOUT).to receive(:puts).with(message)
    curr_inst.show_menu
  end

  describe '#run' do
    it 'call check_menu' do
      allow(curr_inst).to receive(:check_menu).and_raise(SystemExit)
      allow(curr_inst).to receive(:gets).and_return('exit')
      expect { curr_inst.run }.to raise_error(SystemExit)
    end

    it 'break when input start' do
      allow(curr_inst).to receive(:gets).and_return(commands[:start])
      expect(curr_inst.run).to eq(nil)
    end

    describe '#check_menu' do
      it 'command rule call show_rule' do
        allow(curr_inst).to receive(:show_rule)
        curr_inst.check_menu(commands[:rule])
      end

      it 'must show rule' do
        allow(rule_file).to receive(:read).and_return(rule_content)
        allow(rule_file).to receive(:close).and_return(nil)
        allow(File).to receive(:open).with('mock_file').and_return(rule_file)
        allow(STDOUT).to receive(:puts).with(rule_content)
        curr_inst.show_rule
      end

      it ' must put line from statistic table' do
        statistic_table = [statistic_row]
        expect_line = [1, 'tempname', 'easy', 1, 1, 1, 1].join('-----')
        allow(STDOUT).to receive(:puts).and_return(expect_line)
        curr_inst.puts_line(statistic_table)
      end

      it 'must put empty stat from file' do
        allow(STDOUT).to receive(:puts).and_return('', '', '', '')
        curr_inst.show_statistics
      end

      it 'must put full table statistic' do
        allow(curr_inst).to receive(:puts_line)
        allow(sheet).to receive(:load).and_return([1, 2, 3])
        curr_inst.show_statistics
      end

      it 'command stat call show_statistic' do
        allow(curr_inst).to receive(:show_statistics)
        curr_inst.check_menu(commands[:stat])
      end

      it 'exit from console app when input exit' do
        expect { curr_inst.check_menu(commands[:exit]) }.to raise_error(SystemExit)
      end

      it 'show invalid message when input invalid message' do
        allow(STDOUT).to receive(:puts).with('Try again, wrong command: ' + commands[:invalid])
        curr_inst.check_menu(commands[:invalid])
      end
    end
  end
end

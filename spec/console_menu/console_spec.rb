RSpec.describe ConsoleMenu::Console do
  let(:described_instance) { described_class.new(rule_file_path: 'rule.txt') }
  let(:commands) { { yes: 'yes', no: 'no' } }

  describe '#initialize' do
    it 'correct initialize' do
      expect(described_instance).to be_a(described_class)
    end
  end

  it 'return true if player put comand "yes"' do
    allow(described_instance).to receive(:gets).and_return(commands[:yes])
    expect(described_instance.re_run).to eq(true)
  end

  # it 'exit from func if player don`t want new game' do
  #   allow_any_instance_of(Hash).to receive(:map)
  #   allow(described_instance).to receive(:loop).and_yield
  #   allow(described_instance).to receive(:re_run).and_return(false)
  #   expect(described_instance.run).to be_nil
  # end
end

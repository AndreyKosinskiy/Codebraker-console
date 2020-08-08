# frozen_string_literal: true

module ConsoleMenu
  module MainMenu
    class Main
      def initialize(rule_file_path:, sheet:)
        Validation::MainMenu.validation_init_args(rule_file_path: rule_file_path, sheet: sheet)
        @rule_file_path = rule_file_path
        @sheet = sheet
      end

      def run
        loop do
          show_menu
          command = gets.chomp.downcase
          break if command == 'start'

          check_menu(command)
        end
      end

      def check_menu(command)
        case command
        when 'rule' then show_rule
        when 'stat' then show_statistics
        when 'exit' then exit
        else puts 'Try again, wrong command: ' + command
        end
      end

      def show_menu
        puts "1. Start\n2. Rule\n3. Stat\n4. Exit\nEnter your choice: "
      end

      def show_rule
        file = File.open(@rule_file_path)
        puts file.read
        file.close
      end

      def puts_line(statistic_table)
        statistic_table.map do |row|
          puts [row.rating, row.player_name, row.difficult_name,
                row.init_attempts_count, row.used_attempts_count,
                row.init_hints_count, row.used_hints_count]
            .join('-----')
        end
      end

      def show_statistics
        statistic_table = @sheet.load
        puts '================== begin ======================'
        puts 'Rating-----Name-----Difficulty-----Attempts Total-----Attempts Used-----Hints Total----Hints Used'
        if statistic_table
          puts_line(statistic_table)
        else
          puts 'Empty Statistic'
        end
        puts '================== end ========================'
      end
    end
  end
end

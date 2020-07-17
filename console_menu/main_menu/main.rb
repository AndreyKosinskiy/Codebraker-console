# frozen_string_literal: true

module ConsoleMenu
  module MainMenu
    class Main
      def initialize(rule_file_path:, sheet:)
        @rule_file_path = rule_file_path
        @sheet = sheet
      end

      def run
        loop do
          show_menu
          command = gets.chomp.downcase
          case command
          when 'start'
            break
          when 'rule'
            show_rule
          when 'stat'
            show_statistics
          when 'exit'
            exit
          else
            puts 'Try again, wrong command: ' + command
          end
        end
      end

      def show_menu
        puts '1. Start'
        puts '2. Rule'
        puts '3. Stat'
        puts '4. Exit'
        puts 'Enter your choice: '
      end

      def show_rule
        file = File.open(@rule_file_path)
        puts file.read
        file.close
      end

      def show_statistics
        statistic_table = @sheet.load
        puts '================== begin ======================'
        puts 'Rating-----Name-----Difficulty-----Attempts Total-----Attempts Used-----Hints Total----Hints Used'
        if statistic_table
          statistic_table.map do |row|
            puts [row.player_name, row.difficult_name,
                  row.init_attempts_count, row.used_attempts_count,
                  row.init_hints_count, row.used_hits_count]
              .join('-----')
          end
        else
          puts 'Empty Statistic'
        end
        puts '================== end ========================'
      end
    end
  end
end

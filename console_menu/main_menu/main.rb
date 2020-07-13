# frozen_string_literal: true

module ConsoleMenu
  module MainMenu
    class Main
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
        puts '================== begin ======================'
        puts '================== rule ======================='
        puts '================== end ========================'
      end

      def show_statistics
        puts '================== begin ======================'
        puts '================== staistic ==================='
        puts '================== end ========================'
      end
    end
  end
end

module ConsoleMenu
  module GameMenu
    class Game
      def initialize(game:,player:,difficult:)
        @game = game.new(player:player,difficult:difficult)
      end

      def run
        loop do
          show_menu
          command = gets.chomp.downcase
          case command
          when 'guess'
            break if guess == 1
          when 'hint'
            hint
          when 'exit'
            exit
          else
            puts 'Try again, wrong command: ' + command
          end
        end
      end

      def show_menu
        puts '1. guess'
        puts '2. hint'
        puts '3. exit'
      end

      def guess
        puts "Enter guess: "
        guess = gets.chomp.downcase
        begin
          result = @game.my_guess(input_value:guess)
          return 1 if @game.player_win?(result) or !@game.can_use_attempts?
          puts " You have not any attempts left."
        rescue ArgumentError => e
          puts e.message
        end
      end

      def hint
        @game.hint
      end
    end
  end
end

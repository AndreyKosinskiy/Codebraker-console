# frozen_string_literal: true

module ConsoleMenu
  module GameMenu
    class Game
      def initialize(state:, game:, player:, difficult:)
        @game = game.new(player: player, difficult: difficult)
        @state = state
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
        # TODO: i18n gem
        puts '1. guess'
        puts '2. hint'
        puts '3. exit'
      end

      def guess
        puts 'Enter guess: '
        guess = gets.chomp.downcase
        begin
          result = @game.my_guess(input_value: guess)
          puts cover_for_result(result)
          if @game.player_win?(result)
            puts "You win!\n Save result?(Yes/No(or else))"
            save_it = gets.chomp.downcase
            save_game_result if save_it == "yes"
            return 1
          end

          if !@game.can_use_attempts?
            # TODO: i18n gem
            puts ' You have not any attempts left.'
            return 1
          else
          end
        rescue ArgumentError => e
          puts e.message
        end
      end

      def hint
        hint_to_console = @game.hint
        if hint_to_console
          puts hint_to_console
        else
          # TODO: i18n gem
          puts 'You have not any hints left'
        end
      end

      def save_game_result
        @state[:sheet].new_row = @game.current_stat
        @state[:sheet].store
      end

      def cover_for_result(result, true_cover = '+', false_cover = '-')
        result.map { |item| item ? true_cover : false_cover }.join
      end
    end
  end
end

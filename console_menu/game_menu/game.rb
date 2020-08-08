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
          when 'guess' then break if guess == 1
          when 'hint' then hint
          when 'exit' then exit
          else puts 'Try again, wrong command: ' + command
          end
        end
      end

      def show_menu
        # TODO: i18n gem
        puts "1. guess\n2. hint\n3. exit"
      end

      def check_win(result)
        return unless @game.player_win?(result)

        puts "You win!\n Save result?(Yes/No)"
        save_it = gets.chomp.downcase
        save_game_result if save_it == 'yes'
        1
      end

      def check_lose
        return if @game.can_use_attempts?

        puts ' You have not any attempts left.'
        1
      end

      def check_guess(guess)
        result = @game.my_guess(input_value: guess)
        puts cover_for_result(result)
        return 1 if check_win(result) == 1

        check_lose
      rescue ArgumentError => e
        puts e.message
      end

      def guess
        puts 'Enter guess: '
        guess = gets.chomp.downcase
        check_guess(guess)
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

      def cover_for_result(result, digit_and_place = '+', only_digit = '-')
        result.map { |item| item ? digit_and_place : only_digit }.join
      end
    end
  end
end

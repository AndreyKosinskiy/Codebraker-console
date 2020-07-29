# frozen_string_literal: true

module ConsoleMenu
  module RegistrationMenu
    class Registration
      def initialize(state:, player_object:, difficult_object:)
        @player_object = player_object
        @difficult_object = difficult_object
        @state = state
        separators_init
      end

      def separators_init(separator_begin: '', separator_after_name: '. - ',
                          separator_after_attempts: ' attempts, ', separator_after_hints: " hints.\n")
        @separator_begin = separator_begin
        @separator_after_name = separator_after_name
        @separator_after_attempts = separator_after_attempts
        @separator_after_hints = separator_after_hints
      end

      def check_player(player_name)
        @state[:player] = @player_object.new(name: player_name)
        true
      rescue ArgumentError => e
        puts e.message
        puts '=> Please, try again'
        false
      end

      def create_player
        go_to_choose_difficult = false
        until go_to_choose_difficult
          puts 'Please, enter your name: '
          player_name = gets.chomp
          exit_now!(player_name)
          go_to_choose_difficult = check_player(player_name)
          # begin
          #   @state[:player] = @player_object.new(name: player_name)
          #   go_to_choose_difficult = true
          # rescue ArgumentError => e
          #   puts e.message
          #   puts '=> Please, try again'
          # end
        end
      end

      def check_difficult_variant(difficult_variant)
        if difficult_variant
          @state[:difficult] = @difficult_object.new(difficult_variant: difficult_variant)
          true
        else
          puts '=> Entered difficult name is not in list. Try again!'
          false
        end
      end

      def choose_difficult
        go_to_game = false
        until go_to_game
          puts 'Choose dificult: '
          difficult_to_menu
          difficult_name = gets.chomp.downcase
          exit_now!(difficult_name)
          difficult_variant = difficult_by_name(difficult_name)
          go_to_game = check_difficult_variant(difficult_variant)
        end
      end

      def difficult_by_name(input_value)
        @difficult_object::DIFFICULT_VARIANTS.detect { |value| value[:name] == input_value }
      end

      def difficult_to_menu
        menu = ''
        variants = @difficult_object::DIFFICULT_VARIANTS
        variants.map { |row| menu += template_menu_row(name: row[:name], attempts: row[:attempts], hints: row[:hints]) }
        puts menu
      end

      def raw_name(name)
        name + @separator_after_name
      end

      def raw_attempts(attempts)
        attempts.to_s + @separator_after_attempts
      end

      def raw_hint(hints)
        hints.to_s + @separator_after_hints
      end

      def template_menu_row(name:, attempts:, hints:)
        @separator_begin + raw_name(name) + raw_attempts(attempts) + raw_hint(hints)
      end

      def exit_now!(input_text)
        exit if input_text == 'exit'
      end

      def run
        create_player
        choose_difficult
      end
    end
  end
end

# frozen_string_literal: true

module ConsoleMenu
  module RegistrationMenu
    class Registration
      def initialize(state:, player_object:, difficult_object:, separator_begin: '', separator_after_name: '. - ', separator_after_attempts: ' attempts, ', separator_after_hints: " hints.\n")
        @player_object = player_object
        @difficult_object = difficult_object
        @separator_begin = separator_begin
        @separator_after_name = separator_after_name
        @separator_after_attempts = separator_after_attempts
        @separator_after_hints = separator_after_hints
        @state = state
      end

      def create_player
        go_to_choose_difficult = false
        until go_to_choose_difficult
          puts 'Please, enter your name: '
          player_name = gets.chomp
          exit_now!(player_name)
          begin
            @state[:player] = @player_object.new(name: player_name)
            go_to_choose_difficult = true
          rescue ArgumentError => e
            puts e.message
            puts '=> Please, try again'
          end
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
          if difficult_variant
            @state[:difficult] = @difficult_object.new(difficult_variant: difficult_variant)
            go_to_game = true
          else
            puts '=> Entered difficult name is not in list. Try again!'
          end
        end
      end

      def difficult_by_name(input_value)
        @difficult_object::DIFFICULT_VARIANTS.select { |value| value[:name] == input_value }.first
      end

      def difficult_to_menu
        menu = ''
        variants = @difficult_object::DIFFICULT_VARIANTS
        variants.map { |row| menu += template_menu_row(name: row[:name], attempts: row[:attempts], hints: row[:hints]) }
        puts menu
      end

      def template_menu_row(name:, attempts:, hints:)
        @separator_begin + name + @separator_after_name + attempts.to_s + @separator_after_attempts + hints.to_s + @separator_after_hints
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

# frozen_string_literal: true

require_relative 'bootstrap'

module ConsoleMenu
  class Console
    def initialize(storage: nil,rule_file_path:nil)
      @init_state = {
        player: BeforeGame::RegistrationPlayer,
        difficult: BeforeGame::DifficultChooser,
        game: Game::CodeBreaker,
        sheet: Statistic::StatisticSheet.new(storage: YamlSaver.new(permitted_classes: [Statistic::StatisticRow]))
      }
      @state = @init_state
      @console_menu = {
        main_menu_console: proc { ConsoleMenu::MainMenu::Main.new(rule_file_path:rule_file_path,sheet:@state[:sheet]).run },
        registration_menu_console: proc { ConsoleMenu::RegistrationMenu::Registration.new(state: @state, player_object: @state[:player], difficult_object: @state[:difficult]).run },
        game_menu_console: proc { ConsoleMenu::GameMenu::Game.new(state: @state, game: @state[:game], player: @state[:player], difficult: @state[:difficult]).run }
      }
    end

    def re_run
      puts 'Restart game? Yes/No(or else)'
      restart = gets.chomp.downcase
      if restart == 'yes'
        true
      else
        false
      end
    end

    def run
      loop do
        @console_menu.map { |_key, command| command.call }
        re_run ? @state = @init_state : break
      end
    end
  end
end

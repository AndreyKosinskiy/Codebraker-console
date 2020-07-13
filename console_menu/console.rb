# frozen_string_literal: true

require_relative 'bootstrap'
require_relative 'main_menu/main'
require_relative 'registration_menu/registration'
require_relative 'game_menu/game'
require_relative '../../Codebraker-gem/bootstrap'

module ConsoleMenu
  class Console
    def initialize
      gem = {
        gem_player: BeforeGame::RegistrationPlayer,
        gem_difficult: BeforeGame::DifficultChooser,
        gem_game: Game::CodeBreaker,
      }

      @console_menu = {
        main_menu_console: ConsoleMenu::MainMenu::Main.new.run,
        registration_menu_console: ConsoleMenu::RegistrationMenu::Registration.new(init:gem,player_object: gem[:gem_player], difficult_object: gem[:gem_difficult]).run,
        game_menu_console: ConsoleMenu::GameMenu::Game.new(init:gem,game:gem[:gem_game],player: gem[:gem_player], difficult: gem[:gem_difficult])
        # :statistic_menu_console => Statistic.new(),
      }
    end

    def run
      loop do
        @console_menu.map
      end
    end
  end
end

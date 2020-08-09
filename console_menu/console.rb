# frozen_string_literal: true

require_relative 'bootstrap'

module ConsoleMenu
  class Console
    MENU_GEM = ConsoleMenu::MainMenu::Main
    REGISTATION_GEM = ConsoleMenu::RegistrationMenu::Registration
    GAME_GEM = ConsoleMenu::GameMenu::Game

    def initialize(rule_file_path:)
      @rule_file_path = rule_file_path
      @state = init_state
      @console_menu = console_menu
    end

    def re_run
      puts 'Restart game? Yes/No(or else)'
      restart = gets.chomp.downcase
      restart == 'yes'
    end

    def run
      loop do
        @console_menu.map { |_key, command| command.call }
        re_run ? @state = init_state : break
      end
    end

    private

    def init_state
      {
        player: BeforeGame::RegistrationPlayer,
        difficult: BeforeGame::DifficultChooser,
        game: Game::CodeBreaker,
        sheet: Statistic::StatisticSheet.new(storage: YamlSaver.new(permitted_classes: [Statistic::StatisticRow]))
      }
    end

    def menu_step
      proc { MENU_GEM.new(rule_file_path: @rule_file_path, sheet: @state[:sheet]) }
    end

    def registration_step
      proc {
        REGISTATION_GEM.new(state: @state, player_object: @state[:player],
                            difficult_object: @state[:difficult])
      }
    end

    def game_step
      proc {
        GAME_GEM.new(state: @state, game: @state[:game],
                     player: @state[:player], difficult: @state[:difficult])
      }
    end

    def steps
      {
        menu_step: menu_step,
        registration_step: registration_step,
        game_step: game_step
      }
    end

    def console_menu
      {
        main_menu_console: proc { steps[:menu_step].call.run },
        registration_menu_console: proc { steps[:registration_step].call.run },
        game_menu_console: proc { steps[:game_step].call.run }
      }
    end
  end
end

# frozen_string_literal: true

require_relative 'console'

console = ConsoleMenu::Console.new(rule_file_path: '../rule.txt')
console.run

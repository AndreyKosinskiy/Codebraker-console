module Validation
  class MainMenu
    def self.validation_init_args(rule_file_path:, sheet:)
      raise ArgumentError, 'File for rules do not exists' unless File.exist?(rule_file_path)
      unless sheet.is_a? Statistic::StatisticSheet
        raise ArgumentError, 'Sheet must be type of Statistic::StatisticSheet'
      end

      true
    end
  end
end

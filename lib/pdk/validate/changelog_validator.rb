require 'pdk'
require 'pdk/cli/exec'
require 'pdk/validate/base_validator'
require 'pdk/validate/changelog/changelog_exist'

module PDK
  module Validate
    class ChangelogValidator < BaseValidator
      def self.name
        'changelog'
      end

      def self.changelog_validators
       [ChangelogExist]
      end

      def self.invoke(report, options = {})
        exit_code = 0

        changelog_validators.each do |validator|
          exit_code = validator.invoke(report, options)
          break if exit_code != 0
        end

        exit_code
      end
    end
  end
end

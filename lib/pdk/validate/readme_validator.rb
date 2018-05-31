require 'pdk'
require 'pdk/cli/exec'
require 'pdk/validate/base_validator'
require 'pdk/validate/readme/readme_exist'

module PDK
  module Validate
    class ReadmeValidator < BaseValidator
      def self.name
        'readme'
      end

      def self.readme_validators
       [ReadmeExist]
      end

      def self.invoke(report, options = {})
        exit_code = 0

        readme_validators.each do |validator|
          exit_code = validator.invoke(report, options)
          break if exit_code != 0
        end

        exit_code
      end
    end
  end
end

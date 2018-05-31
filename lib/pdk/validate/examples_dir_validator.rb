require 'pdk'
require 'pdk/cli/exec'
require 'pdk/validate/base_validator'
require 'pdk/validate/examples_dir/examples_dir_exist'

module PDK
  module Validate
    class ExamplesDirValidator < BaseValidator
      def self.name
        'examples'
      end

      def self.examples_validators
       [ExamplesExist]
      end

      def self.invoke(report, options = {})
        exit_code = 0

        examples_validators.each do |validator|
          exit_code = validator.invoke(report, options)
          break if exit_code != 0
        end

        exit_code
      end
    end
  end
end

require 'pdk/validate/metadata_validator'
require 'pdk/validate/puppet_validator'
require 'pdk/validate/ruby_validator'
require 'pdk/validate/readme_validator'
require 'pdk/validate/changelog_validator'
require 'pdk/validate/examples_dir_validator'

module PDK
  module Validate
    def self.validators
      @validators ||= [MetadataValidator,
                       PuppetValidator,
                       RubyValidator,
                       ChangelogValidator,
                       ReadmeValidator,
                       ExamplesDirValidator].freeze
    end
  end
end

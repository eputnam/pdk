require 'pdk/validate/metadata_validator'
require 'pdk/validate/puppet_validator'
require 'pdk/validate/ruby_validator'
require 'pdk/validate/file_validator'

module PDK
  module Validate
    def self.validators
      @validators ||= [MetadataValidator, PuppetValidator, RubyValidator, FileValidator].freeze
    end
  end
end

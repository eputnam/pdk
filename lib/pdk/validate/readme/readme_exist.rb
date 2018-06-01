require 'pdk'
require 'pdk/validate/file_exist'

module PDK
  module Validate
    class ReadmeExist < FileExist
      def self.filename
        'README'
      end

      def self.file_type
        'file'
      end

      def self.name
       'readme-exist'
      end
    end
  end
end
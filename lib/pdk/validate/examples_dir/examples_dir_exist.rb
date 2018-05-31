require 'pdk'
require 'pdk/validate/file_exist'

module PDK
  module Validate
    class ExamplesExist < FileExist
      def self.filename
        'examples/'
      end

      def self.file_extensions
        ''
      end

      def self.name
       'examples-dir-exist'
      end
    end
  end
end

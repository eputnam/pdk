require 'pdk'
require 'pdk/validate/file_exist'

module PDK
  module Validate
    class ChangelogExist < FileExist
      def self.filename
        'CHANGELOG'
      end

      def self.file_type
        'file'
      end

      def self.name
       'changelog-exist'
      end
    end
  end
end

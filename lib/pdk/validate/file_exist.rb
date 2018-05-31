require 'pdk'
require 'pdk/cli/exec'
require 'pdk/validate/base_validator'
require 'pdk/util'

module PDK
  module Validate
    class FileExist < BaseValidator
      def self.filename
        'readme'
      end

      def self.file_extensions
        '(\.md|\.mkdwn|\.mkdn|\.markdown)'
      end

      def self.name
       'file-validator'
      end

      def self.spinner_text(_targets = [])
        _("Checking for %{filename}.") % { filename: filename }
      end

      def self.create_spinner(targets = [], options = {})
        return unless PDK::CLI::Util.interactive?
        options = options.merge(PDK::CLI::Util.spinner_opts_for_platform)

        exec_group = options[:exec_group]
        @spinner = if exec_group
                     exec_group.add_spinner(spinner_text(targets), options)
                   else
                     TTY::Spinner.new("[:spinner] #{spinner_text(targets)}", options)
                   end
        @spinner.auto_spin
      end

      def self.stop_spinner(exit_code)
        if exit_code.zero? && @spinner
          @spinner.success
        elsif @spinner
          @spinner.error
        end
      end

      def self.invoke(report, options = {})
        targets, skipped, invalid = parse_targets(options)

        regex = %r{^(?:.*\/)?#{filename}#{file_extensions}?$}i

        targets = PDK::Util.files_in_module_root.select { |file| file if file.match(regex) }

        process_skipped(report, skipped)
        process_invalid(report, invalid)

        return_val = 0
        create_spinner(targets, options)

        # The pure ruby JSON parser gives much nicer parse error messages than
        # the C extension at the cost of slightly slower parsing. We require it
        # here and restore the C extension at the end of the method (if it was
        # being used).

        if !targets.empty? && File.exist?(targets[0])
          report.add_event(
            file:     targets[0],
            source:   name,
            state:    :passed,
            severity: 'ok',
          )
        else
          report.add_event(
            file: filename,
            source: name,
            state: :failure,
            severity: 'error',
            message: _("Could not find #{filename} with #{regex.to_s}"),
          )
          return_val = 1
        end

        stop_spinner(return_val)
        return_val
      end
    end
  end
end

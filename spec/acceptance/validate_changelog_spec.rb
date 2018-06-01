require 'spec_helper_acceptance'
require 'fileutils'

describe 'pdk validate changelog', module_command: true do
  let(:junit_xsd) { File.join(RSpec.configuration.fixtures_path, 'JUnit.xsd') }
  let(:spinner_text) { %r{CHANGELOG exists\?}i }
  let(:empty_string) { %r{\A\Z} }

  include_context 'with a fake TTY'

  valid_changelog = File.join('./', 'CHANGELOG.md')
  invalid_changelog = File.join('./', 'CHANGE.md')

  context 'with no changelog and incorrectly named changelog' do
    include_context 'in a new module', 'validate_puppet_module'

    before do
      FileUtils.rm(valid_changelog) if File.exist?(valid_changelog)
      FileUtils.touch(invalid_changelog) unless File.exist?(invalid_changelog)
    end

    describe command('pdk validate changelog') do
      its(:exit_status) { is_expected.to eq(1) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to match(%r{Could not find CHANGELOG}) }
    end

    describe command('pdk validate changelog --format junit') do
      its(:exit_status) { is_expected.to eq(1) }
      its(:stderr) { is_expected.to match(spinner_text) }

      its(:stdout) { is_expected.to pass_validation(junit_xsd) }
      its(:stdout) { is_expected.to have_junit_testcase.in_testsuite('changelog-exist').that_failed }
    end
  end

  context 'with correctly named changelog' do
    include_context 'in a new module', 'foo'

    before(:all) do
      File.open(valid_readme, 'w') do |f|
        f.puts <<-EOS
        # Changelog

        EOS
      end
    end

    describe command('pdk validate changelog') do
      its(:exit_status) { is_expected.to eq(0) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to match(empty_string) }
    end

    describe command('pdk validate changelog --format junit') do
      its(:exit_status) { is_expected.to eq(0) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to pass_validation(junit_xsd) }

      its(:stdout) { is_expected.to have_junit_testsuite('changelog-exist') }
    end
  end
end

require 'spec_helper_acceptance'
require 'fileutils'

describe 'pdk validate readme', module_command: true do
  let(:junit_xsd) { File.join(RSpec.configuration.fixtures_path, 'JUnit.xsd') }
  let(:spinner_text) { %r{README exists\?}i }
  let(:empty_string) { %r{\A\Z} }

  include_context 'with a fake TTY'

  valid_readme = File.join('./', 'README.md')
  invalid_readme = File.join('./', 'READ.md')

  context 'with no readme' do
    include_context 'in a new module', 'validate_puppet_module'

    before do
      FileUtils.rm(valid_readme) if File.exist?(valid_readme)
      FileUtils.touch(invalid_readme) unless File.exist?(invalid_readme)
    end

    describe command('pdk validate readme') do
      its(:exit_status) { is_expected.to eq(1) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to match(%r{Could not find README}) }
    end

    describe command('pdk validate readme --format junit') do
      its(:exit_status) { is_expected.to eq(1) }
      its(:stderr) { is_expected.to match(spinner_text) }

      its(:stdout) { is_expected.to pass_validation(junit_xsd) }
      its(:stdout) { is_expected.to have_junit_testcase.in_testsuite('readme-exist').that_failed }
    end
  end

  context 'with correctly named readme' do
    include_context 'in a new module', 'foo'

    before(:all) do
      File.open(valid_readme, 'w') do |f|
        f.puts <<-EOS
        # ntp

#### Table of Contents


1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with ntp](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)


## Module description

## Setup
        EOS
      end
    end

    describe command('pdk validate readme') do
      its(:exit_status) { is_expected.to eq(0) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to match(empty_string) }
    end

    describe command('pdk validate readme --format junit') do
      its(:exit_status) { is_expected.to eq(0) }
      its(:stderr) { is_expected.to match(spinner_text) }
      its(:stdout) { is_expected.to pass_validation(junit_xsd) }

      its(:stdout) { is_expected.to have_junit_testsuite('readme-exist') }
    end
  end
end

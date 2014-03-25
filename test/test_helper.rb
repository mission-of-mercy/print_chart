require_relative '../lib/print_chart'

require 'minitest/autorun'
require 'minitest/spec'
require 'minispec-metadata'
require 'vcr'
require 'minitest-vcr'
require 'minitest/stub_any_instance'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
end

MinitestVcr::Spec.configure!

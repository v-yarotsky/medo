require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('spec/**/*_spec.rb')
  t.verbose = true
end

desc "Integration test"
task :integration_test do |t|
  require File.join(File.dirname(__FILE__), 'spec/integration_test.rb')
end

task :default => :test

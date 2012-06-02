# encoding: utf-8
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

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


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
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "medo"
  gem.homepage = "http://github.com/v-yarotsky/medo"
  gem.license = "MIT"
  gem.summary = %Q{Simple CLI todo manager app}
  gem.email = "vladimir.yarotksy@gmail.com"
  gem.authors = ["Vladimir Yarotsky"]
  gem.files.exclude '.travis.yml'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new do |t|
  t.test_files = Dir.glob('spec/**/*_spec.rb')
  t.verbose = true
end

desc "Integration test"
task :integration_test do |t|
  require File.join(File.dirname(__FILE__), 'spec/integration_test.rb')
end

task :default => :test


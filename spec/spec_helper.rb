require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'rspec/autorun'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'medo'
require 'medo/support'

include Medo

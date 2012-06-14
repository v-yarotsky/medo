require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'rspec/autorun'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$:.unshift File.expand_path(File.dirname(__FILE__))
$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'medo'
require 'medo/support'

include Medo

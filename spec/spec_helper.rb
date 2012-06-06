require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'rspec/autorun'

$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'medo'
require 'medo/support'

include Medo

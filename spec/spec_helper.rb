require 'rubygems'
require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun'

$: << File.expand_path('../lib', File.dirname(__FILE__))

require 'medo'

include Medo

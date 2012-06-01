PROJECT_ROOT = File.expand_path('../', File.dirname(__FILE__))

$: << File.join(PROJECT_ROOT, 'lib')
$: << File.join(PROJECT_ROOT, 'bin')

require 'rubygems'
require 'bundler/setup'
require 'fileutils'

require 'task'

version_file = File.join(PROJECT_ROOT, 'VERSION')
VERSION = File.read(version_file)

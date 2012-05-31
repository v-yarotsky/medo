$: << File.expand_path("../lib", File.dirname(__FILE__))
$: << File.expand_path("../bin", File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'
require 'fileutils'
require 'pry'

require 'task'
require 'version'

TASKS_FILE = File.expand_path("../tasks.txt", File.dirname(__FILE__))

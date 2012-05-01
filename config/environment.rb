$: << File.expand_path("../lib", File.dirname(__FILE__))

require 'rubygems'
require 'isolate/now'
require 'fileutils'

require 'task'

TASKS_FILE = File.expand_path("../tasks.txt", File.dirname(__FILE__))

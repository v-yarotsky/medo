#!/usr/bin/env ruby-1.9.3-p125@global

require_relative '../config/environment'
require 'gli'
require 'file_task_storage'

include GLI::App

program_desc 'Simple CLI To-Do manager'
version VERSION

commands_from 'commands'

Signal.trap("SIGINT") do
  puts "Terminating"
  exit 1
end

default_command :list

FileTaskStorage.using_storage(TASKS_FILE) do |the_storage|
  define_singleton_method(:storage) { the_storage }
  exit run(ARGV)
end


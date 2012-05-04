#!/usr/bin/env ruby-1.9.3-p125@global

require_relative '../config/environment'

def show_help
  puts "List of available commands: #{COMMANDS.join(", ")}"
end

begin
  COMMANDS = %W(new done list note clear delete).freeze

  cmd = ARGV.shift or raise "No command given!"
  if cmd == "-h"
    show_help
  else
    raise "No such command: #{cmd}" unless COMMANDS.include?(cmd)
    require_relative "medo-#{cmd}.rb"
  end
rescue Exception => e
  puts e.message
end


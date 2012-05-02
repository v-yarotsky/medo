#!/usr/bin/env ruby-1.9.3-p125@global

require_relative '../config/environment'

begin
  COMMANDS = %W(new done list note clear delete).freeze

  cmd = ARGV.shift or raise "No command given!"
  raise "No such command: #{cmd}" unless COMMANDS.include?(cmd)

  require_relative "medo-#{cmd}.rb"
rescue Exception => e
  puts e.message
end

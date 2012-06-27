require 'rubygems'
require 'fileutils'
require 'tempfile'

require 'gli'
require 'medo'
require 'medo/support'
require 'medo/file_task_storage'
require 'medo/cli_support'

module Medo
  class CLI
    extend GLI::App
    extend Medo
    extend CLISupport

    program_desc 'Simple CLI To-Do manager'
    version VERSION

    load_commands
    default_command :list

    desc "A file with tasks"
    flag [:f, "tasks-file"], :default_value => File.join(ENV['HOME'], '.medo-tasks')

    desc "Do not use colorful output"
    switch "no-color", :negatable => false

    around do |global_options, command, options, arguments, cmd|
      FileTaskStorage.using_storage(global_options.fetch(:"tasks-file")) do |storage|
        instance_eval do
          eigen = class << self; self; end
          { 
            :storage        => storage,
            :global_options => global_options,
            :options        => options,
            :arguments      => arguments
          }.each do |method, value|
            eigen.send(:define_method, method) { value }
          end
        end

        cmd.call
      end
    end
  end
end


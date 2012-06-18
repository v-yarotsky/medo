require 'rubygems'
require 'fileutils'
require 'tempfile'

begin
  require 'gli'
  require 'medo'
  require 'medo/support'
  require 'medo/file_task_storage'
rescue LoadError => e #development
  raise if $loaded
  $:.unshift File.expand_path('../../lib', __FILE__) #load what we work on, even if gem installed
  require 'bundler'
  Bundler.setup(:default)
  $loaded = true
  retry
end

module Medo
  class CLI
    module CommandHelpers
      def load_commands
        Dir.glob(File.expand_path('../commands/*', __FILE__)).each do |f|
          contents = File.read(f)
          class_eval contents, f, 1
        end
      end

      def tasks
        @tasks ||= storage.read
        @original_tasks ||= @tasks.map(&:dup)
        @tasks
      end

      def tasks_changed?
        defined? @tasks && @tasks != @original_tasks
      end

      def committing_tasks
        yield

        if tasks_changed?
          storage.write(tasks)
          storage.commit
        end
      end

      def colorize
        yield unless global_options[:"no-color"] == false
      end

      def choose_task(select_options = {})
        task_number = Integer(options[:number] || 1) rescue
          raise(ArgumentError, "Invalid task #: #{task_number}")
        task = tasks.reject { |t| select_options[:done] ^ t.done? }.sort[task_number - 1] or 
          raise(RuntimeError, "No such task!")
        [task, task_number]
      end

      def get_input
        result = nil
        if options[:editor]
          path = File.join(Dir::Tmpname.tmpdir, "taketo-input-#{Time.now.to_i}")
          status = system("$EDITOR #{path}")
          if status && File.exists?(path)
            result = File.read(path)
            FileUtils.rm(path)
          end
        else
          result = arguments.join(" ").strip
        end
        result.to_s
      end
    end

    extend GLI::App
    include Medo
    extend Medo
    extend CommandHelpers

    program_desc 'Simple CLI To-Do manager'
    version VERSION

    load_commands
    default_command :list

    desc "A file with tasks"
    flag [:f, "tasks-file"], :default_value => File.join(ENV['HOME'], '.medo-tasks')

    desc "Do not use colorful output"
    switch "no-color", :negatable => false

    around do |global_options, command, options, arguments, cmd|
      FileTaskStorage.using_storage(global_options.fetch(:"tasks-file")) do |the_storage|
        instance_eval do
          eigen = class << self; self; end
          { 
            :storage        => the_storage,
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


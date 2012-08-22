require 'medo/tasks_collection'

module Medo
  module CLISupport
    def load_commands
      Dir.glob(File.expand_path('../commands/*', __FILE__)).each do |f|
        contents = File.read(f)
        class_eval contents, f, 1
      end
    end

    def tasks
      @_raw_tasks ||= storage.read
      @tasks ||= TasksCollection.new(@_raw_tasks)
      @original_tasks ||= TasksCollection.new(@_raw_tasks.map(&:dup))
      @tasks
    end

    def tasks_changed?
      defined? @tasks and @tasks != @original_tasks
    end

    def committing_tasks
      yield

      if tasks_changed?
        storage.write(tasks.to_a)
        storage.commit
      end
    end

    def colorize
      yield unless global_options[:"no-color"] == false
    end

    def interactive?
      !!options[:interactive]
    end

    def choose_task(select_options = {})
      task_number = interactive? ? ask_for_task : parse_task_number
      task = get_task(task_number, select_options)
      [task, task_number]
    end

    def parse_task_number
      task_number = Integer(options[:number] || 1) rescue
        raise(ArgumentError, "Invalid task #: #{task_number}")
    end

    def ask_for_task
      list_command = commands.detect { |c| c.first == :list }.last
      list_command.execute(global_options, options, arguments)
      puts "Enter task number:"
      task_number = begin
        input = STDIN.gets.chomp
        Integer(input)
      rescue
        raise(ArgumentError, "Invalid task #: #{input.inspect}")
      end
    end

    def get_input
      process_input
    end

    def edit_input(value)
      process_input do |path|
        File.open(path, "w") { |f| f.write(value) }
      end
    end

    def process_input
      result = nil
      if options[:editor]
        path = File.join(Dir::Tmpname.tmpdir, "taketo-input-#{Time.now.to_i}")
        yield path if block_given?
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

    private

    def get_task(task_number, select_options = {})
      tasks.reject { |t| select_options[:done] ^ t.done? }.sort[task_number - 1] or
        raise(RuntimeError, "No such task!")
    end
  end
end


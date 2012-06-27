module Medo
  module CLISupport
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
      defined? @tasks and @tasks != @original_tasks
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
end


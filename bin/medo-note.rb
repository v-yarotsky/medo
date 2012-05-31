require_relative '../config/environment'

desc "Add note to a todo"
command :note do |c|
  c.action do |global_options, options, args|
    begin
      FileTaskStorage.using_storage(TASKS_FILE) do |storage|
        tasks = storage.read

        input = args.shift
        number = Integer(input) rescue 
          raise(ArgumentError, "Invalid task #: #{input}")
        note = args.join(" ").strip
        raise ArgumentError, "No note given" if note.empty?

        task = tasks.reject(&:done?).sort[number - 1] or raise RuntimeError, "No such task!"
        task.notes << note

        storage.write(tasks)
        storage.commit
        puts "Note for task #{number} added"
      end
    rescue Exception => e
      puts "todo-note: #{e}"
    end
  end
end


require_relative '../config/environment'

desc "Mark todo as done"
command :done do |c|
  c.action do |global_options, options, args|
    begin
      FileTaskStorage.using_storage(TASKS_FILE) do |storage|
        tasks = storage.read
        number = args.shift.to_i

        task = tasks.reject(&:done?).sort[number - 1] or raise RuntimeError, "No such task!"
        task.done

        storage.write(tasks)
        storage.commit
        puts "Task #{number} done"
      end
    rescue Exception => e
      puts "todo-done: #{e}"
    end
  end
end

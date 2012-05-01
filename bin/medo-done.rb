require_relative '../config/environment'
require 'file_task_storage'

begin
  FileTaskStorage.using_storage(TASKS_FILE) do |storage|
    tasks = storage.read
    number = ARGV.shift.to_i

    task = tasks.reject(&:done?).sort[number - 1] or raise RuntimeError, "No such task!"
    task.done

    storage.write(tasks)
    storage.commit
    puts "Task #{number} done"
  end
rescue Exception => e
  puts "todo-done: #{e}"
end


require_relative '../config/environment'
require 'file_task_storage'

begin
  FileTaskStorage.using_storage(TASKS_FILE) do |storage|
    tasks = storage.read

    task_description = ARGV.join(" ")
    task = Task.new(task_description)

    tasks << task

    storage.write(tasks)
    storage.commit
    puts "Task added"
  end
rescue Exception => e
  puts "todo-new: #{e}"
end


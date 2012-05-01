require_relative '../config/environment'
require 'file_task_storage'

begin
  FileTaskStorage.using_storage(TASKS_FILE) do |storage|
    tasks = storage.read.reject(&:done?)
    storage.write(tasks)
    storage.commit
    puts "Done tasks cleared"
  end
rescue Exception => e
  puts "todo-clear: #{e}"
end


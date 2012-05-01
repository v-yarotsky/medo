require_relative '../config/environment'
require 'file_task_storage'

begin
  FileTaskStorage.using_storage(TASKS_FILE) do |storage|
    tasks = storage.read

    input = ARGV.shift
    number = Integer(input) rescue 
      raise(ArgumentError, "Invalid task #: #{input}")
    note = ARGV.join(" ").strip
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


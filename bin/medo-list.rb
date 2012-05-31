require_relative '../config/environment'
require 'numbering_text_task_printer'

desc "List all todos"
command :list do |c|
  c.action do |global_options, options, args|
    begin
      FileTaskStorage.using_storage(TASKS_FILE) do |storage|
        tasks = storage.read
        printer = NumberingTextTaskPrinter.new
        printer.add_tasks(tasks)
        printer.print
      end
    rescue Exception => e
      puts "todo-list: #{e}"
    end
  end
end

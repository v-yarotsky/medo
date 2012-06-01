require_relative '../config/environment'
require 'numbering_text_task_printer'

desc "List all todos"
command [:list, :ls] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read
    printer = NumberingTextTaskPrinter.new
    printer.add_tasks(tasks)
    printer.print
  end
end

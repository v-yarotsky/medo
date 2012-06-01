require 'medo/numbering_text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read
    writer = Medo::NumberingTextTaskWriter.new
    writer.add_tasks(tasks)
    writer.write
  end
end

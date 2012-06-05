require 'medo/numbering_text_task_writer'
require 'medo/color_numbering_text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    #waiting for fix of https://github.com/davetron5000/gli/pull/90
    writer = global_options[:"no-color"] == false ? Medo::NumberingTextTaskWriter.new
                                                  : Medo::ColorNumberingTextTaskWriter.new
    writer.add_tasks(tasks)
    writer.write
  end
end

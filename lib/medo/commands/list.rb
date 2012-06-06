require 'medo/text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    include TextTaskWriter::Decorators
    writer = NumbersDecorator.decorate(TextTaskWriter.new)

    #waiting for fix of https://github.com/davetron5000/gli/pull/90
    ColorsDecorator.decorate(writer) unless global_options[:"no-color"] == false
    writer.add_tasks(tasks)
    writer.write
  end
end

require 'medo/text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.desc "Number only done tasks"
  c.switch ["number-done"], :negatable => false

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    writer = NumbersDecorator.decorate(TextTaskWriter.new,
      :done => options[:"number-done"] == false)
    colorize { ColorsDecorator.decorate(writer) }
    writer.add_tasks(tasks)
    writer.write
  end
end


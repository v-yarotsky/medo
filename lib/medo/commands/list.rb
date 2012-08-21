require 'medo/text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.desc "Number only done tasks"
  c.switch ["number-done"], :negatable => false

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    puts("no tasks") && break if tasks.empty?
    m_tasks = TextTaskWriter::TasksCollection.new(tasks)
    writer = NumbersDecorator.decorate(TextTaskWriter.new(m_tasks),
      :done => options[:"number-done"] == false)
    colorize { ColorsDecorator.decorate(writer) }
    writer.write
  end
end


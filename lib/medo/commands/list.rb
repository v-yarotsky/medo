require 'medo/text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.desc "Number only done tasks"
  c.switch ["number-done"], :negatable => false

  c.desc "Filter by tag"
  c.flag ["tag"]

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    m_tasks = TextTaskWriter::TasksCollection.new(tasks)
    m_tasks = m_tasks.tagged(options[:tag]) if options[:tag]
    puts("no tasks") && break if m_tasks.empty?
    writer = NumbersDecorator.decorate(TextTaskWriter.new(m_tasks),
      :done => options[:"number-done"] == false)
    colorize { ColorsDecorator.decorate(writer) }
    writer.write
  end
end


require 'medo/text_task_writer'

desc "Show particular note"
command [:show, :cat] do |c|
  c.desc "Number of task to show"
  c.flag [:n, :number]
  c.default_value 1

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    task, number = choose_task
    m_tasks = TextTaskWriter::TasksCollection.new([task])
    writer = TextTaskWriter.new(m_tasks)
    colorize { ColorsDecorator.decorate(writer) }
    writer.write
  end
end


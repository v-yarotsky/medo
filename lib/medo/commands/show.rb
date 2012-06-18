require 'medo/text_task_writer'

desc "Show particular note"
command [:show, :cat] do |c|
  c.desc "Number of task to show"
  c.flag [:n, :number]
  c.default_value 1

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    writer = TextTaskWriter.new
    colorize { ColorsDecorator.decorate(writer) }
    task, number = choose_task
    writer.add_task(task)
    writer.write
  end
end


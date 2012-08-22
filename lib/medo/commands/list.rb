require 'medo/text_task_writer'

desc "List all todos"
command [:list, :ls] do |c|
  c.desc "Number only done tasks"
  c.switch ["number-done"], :negatable => false

  c.desc "Filter by tag"
  c.flag ["tag"]

  c.action do |global_options, options, args|
    include TextTaskWriter::Decorators
    tasks_to_show = options[:tag] ? tasks.tagged(options[:tag]) : tasks
    puts("no tasks") && break if tasks_to_show.empty?
    writer = NumbersDecorator.decorate(TextTaskWriter.new(tasks_to_show),
      :done => options[:"number-done"] == false)
    colorize { ColorsDecorator.decorate(writer) }
    writer.write
  end
end


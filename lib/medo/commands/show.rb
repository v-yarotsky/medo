require 'medo/text_task_writer'

desc "Show particular note"
command [:show, :cat] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    include TextTaskWriter::Decorators
    writer = NumbersDecorator.decorate(TextTaskWriter.new)

    #waiting for fix of https://github.com/davetron5000/gli/pull/90
    ColorsDecorator.decorate(writer) unless global_options[:"no-color"] == false

    task, number = choose_task(args, tasks)
    writer.add_tasks([task])
    writer.write
  end
end


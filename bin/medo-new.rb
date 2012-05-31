require_relative '../config/environment'

desc "Create a todo"
command :new do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    task_description = args.join(" ")
    task = Task.new(task_description)

    tasks << task

    storage.write(tasks)
    storage.commit
    puts "Task added"
  end
end

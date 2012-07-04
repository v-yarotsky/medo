desc "Create a todo"
command [:new, :n] do |c|
  c.desc "Use EDITOR"
  c.switch [:e, :editor]

  c.action do |global_options, options, args|
    task_description = get_input
    task, number = Task.new(task_description)
    committing_tasks { tasks << task }
    puts "Task added"
  end
end

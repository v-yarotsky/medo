desc "Edit a todo"
command [:edit, :e] do |c|
  c.desc "Use EDITOR"
  c.switch [:e, :editor]

  c.desc "Number of the task to edit"
  c.flag [:n, :number]
  c.default_value 1

  c.action do |global_options, options, args|
    task, number = choose_task
    task_description = get_input
    committing_tasks { task.description = task_description }
    puts "Task #{number} edited"
  end
end

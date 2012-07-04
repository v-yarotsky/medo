desc "Delete a todo"
command [:delete, :rm] do |c|
  c.desc "Number of the task to delete"
  c.flag [:n, :number]
  c.default_value 1

  c.desc "Select task interactively"
  c.switch [:interactive, :i]

  c.action do |global_options, options, args|
    task, number = choose_task
    committing_tasks { tasks.delete(task) }
    puts "Task #{number} removed"
  end
end

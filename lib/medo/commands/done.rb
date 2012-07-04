desc "Mark todo as done"
command [:done, :d] do |c|
  c.desc "Number of the task to mark as done"
  c.flag [:n, :number]
  c.default_value 1

  c.desc "Select task interactively"
  c.switch [:interactive, :i]

  c.action do |global_options, options, args|
    task, number = choose_task
    committing_tasks { task.done }
    puts "Task #{number} done"
  end
end

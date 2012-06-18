desc "Reset task"
command :reset do |c|
  c.desc "Number of the task to mark reset"
  c.flag [:n, :number]
  c.default_value 1

  c.action do |global_options, options, args|
    task, number = choose_task(:done => true)
    committing_tasks { task.reset }
    puts "Task #{number} was reset"
  end
end

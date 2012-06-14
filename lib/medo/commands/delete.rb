desc "Delete a todo"
command [:delete, :rm] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    task, number = choose_task(args, tasks)
    tasks -= [task]

    storage.write(tasks)
    storage.commit
    puts "Task #{number} removed"
  end
end

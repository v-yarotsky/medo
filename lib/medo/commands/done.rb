desc "Mark todo as done"
command :done do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    task, number = choose_task(args, tasks)
    task.done

    storage.write(tasks)
    storage.commit
    puts "Task #{number} done"
  end
end

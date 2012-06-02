desc "Delete a todo"
command [:delete, :rm] do |c|
  c.action do |global_options, options, args|
    tasks = storage.read
    number = args.shift.to_i

    task = tasks.reject(&:done?).sort[number - 1] or raise RuntimeError, "No such task!"
    tasks -= [task]

    storage.write(tasks)
    storage.commit
    puts "Task #{number} removed"
  end
end

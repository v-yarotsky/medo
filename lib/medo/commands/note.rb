desc "Add note to a todo"
command :note do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    task, number = choose_task(args, tasks)

    note = args.join(" ").strip
    raise ArgumentError, "No note given" if note.empty?

    task.notes << note

    storage.write(tasks)
    storage.commit
    puts "Note for task #{number} added"
  end
end


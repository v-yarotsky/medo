desc "Add note to a todo"
command :note do |c|
  c.action do |global_options, options, args|
    tasks = storage.read

    input = args.shift
    number = Integer(input) rescue 
      raise(ArgumentError, "Invalid task #: #{input}")
    note = args.join(" ").strip
    raise ArgumentError, "No note given" if note.empty?

    task = tasks.reject(&:done?).sort[number - 1] or raise RuntimeError, "No such task!"
    task.notes << note

    storage.write(tasks)
    storage.commit
    puts "Note for task #{number} added"
  end
end


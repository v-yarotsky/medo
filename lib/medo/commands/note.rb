desc "Add note to a todo"
command :note do |c|
  c.desc "Number of the task to add note to"
  c.flag [:n, :number]
  c.default_value 1

  c.desc "Use EDITOR"
  c.switch [:e, :editor]

  c.action do |global_options, options, args|
    task, number = choose_task
    note = get_input
    raise ArgumentError, "No note given" if note.empty?
    committing_tasks { task.notes << note }
    puts "Note for task #{number} added"
  end
end


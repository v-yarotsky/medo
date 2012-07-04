desc "Add note to a todo"
command :note do |c|
  #These options should be moved to sub-command level, but there is a bug in gli :)
  c.desc "Number of the task to add note to"
  c.flag [:n, :number]
  c.default_value 1

  c.desc "Use EDITOR"
  c.switch [:e, :editor]

  c.desc "Select task interactively"
  c.switch [:interactive, :i]

  c.desc "Add a note to the task"
  c.command :add do |ca|
    ca.action do |global_options, options, args|
      task, number = choose_task
      note = get_input
      raise ArgumentError, "No note given" if note.empty?
      committing_tasks { task.notes << note }
      puts "Note for task #{number} added"
    end
  end

  c.desc "Edit the note for the task"
  c.command :edit do |ce|
    ce.action do |global_options, options, args|
      task, number = choose_task
      note = edit_input(task.notes)
      committing_tasks { task.notes = note }
      puts "Note for task #{number} edited"
    end
  end
end


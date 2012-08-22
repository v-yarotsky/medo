desc "Create a todo"
command [:new, :n] do |c|
  c.desc "Use EDITOR"
  c.switch [:e, :editor]

  c.action do |global_options, options, args|
    input = get_input
    tag, description, notes = input.match(/\A(?:(?:\[(.+)\]) )?(?:(.*\n\n|.*))(?:(.*))?/m).captures.map(&:to_s).map(&:strip)
    task, number = Task.new(description)
    task.notes = notes unless String(notes).empty?
    task.tag   = tag
    committing_tasks { tasks << task }
    puts "Task added"
  end
end

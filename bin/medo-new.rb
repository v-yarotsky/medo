require_relative '../config/environment'

desc "Create a todo"
command :new do |c|
  c.action do |global_options, options, args|
    begin
      FileTaskStorage.using_storage(TASKS_FILE) do |storage|
        tasks = storage.read

        task_description = args.join(" ")
        task = Task.new(task_description)

        tasks << task

        storage.write(tasks)
        storage.commit
        puts "Task added"
      end
    rescue Exception => e
      puts "todo-new: #{e}"
    end
  end
end

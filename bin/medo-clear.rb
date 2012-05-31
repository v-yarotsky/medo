require_relative '../config/environment'

desc "Clear done todos"
command :clear do |c|
  c.action do |global_options, options, args|
    begin
      FileTaskStorage.using_storage(TASKS_FILE) do |storage|
        tasks = storage.read.reject(&:done?)
        storage.write(tasks)
        storage.commit
        puts "Done tasks cleared"
      end
    rescue Exception => e
      puts "todo-clear: #{e}"
    end
  end
end

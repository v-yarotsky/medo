desc "Clear done todos"
command :clear do |c|
  c.action do |global_options, options, args|
    tasks = storage.read.reject(&:done?)
    storage.write(tasks)
    storage.commit
    puts "Done tasks cleared"
  end
end

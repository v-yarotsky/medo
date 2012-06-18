desc "Clear done todos"
command :clear do |c|
  c.action do |global_options, options, args|
    committing_tasks { tasks.reject!(&:done?) }
    puts "Done tasks cleared"
  end
end

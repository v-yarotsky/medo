$: << File.expand_path("../lib", File.dirname(__FILE__))

require 'medo'
require 'medo/support'
require 'medo/task'
require 'medo/text_task_writer'
require 'medo/json_task_writer'
require 'medo/json_task_reader'

include Medo

fake_clock = Object.new

def fake_clock.now
  if !@time
    @time = Time.new
  else
    @time += 60
  end
end

Task.clock = fake_clock

tasks = [
  Task.from_attributes("description" => "Buy Milk", "created_at" => fake_clock.now, "done" => true, "completed_at" => fake_clock.now),
  Task.new("Buy Butter", :notes => ["TBD immediately", "Go to local market"]),
  Task.new("Buy Bread"),
  Task.from_attributes("description" => "Buy Juice", "created_at" => fake_clock.now, "done" => true, "completed_at" => fake_clock.now)
]

writer = TextTaskWriter.new
TextTaskWriter::Decorators::NumbersDecorator.decorate(writer)
writer.add_tasks(tasks)
writer.write

test_tasks_file = File.join(File.dirname(__FILE__), 'tasks_test.txt')

File.open(test_tasks_file, "wb") do |f|
  serializer = JsonTaskWriter.new(f)
  serializer.add_tasks(tasks)
  serializer.write
end

File.open(test_tasks_file, "rb") do |f|
  deserializer = JsonTaskReader.new(f)
  tasks = deserializer.read
  puts tasks.inspect
end

FileUtils.rm(test_tasks_file)

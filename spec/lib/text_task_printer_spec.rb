require_relative '../spec_helper'
require 'medo/text_task_writer'
require 'stringio'

describe TextTaskWriter do
  describe "#write" do
    it "should pretty print the task to STDOUT" do
      creation_time = Time.new(2012, 1, 5, 12, 4)
      task = stub(:description => "Buy Milk", 
                  :created_at  => creation_time, 
                  :done?       => false,
                  :notes       => [])
      fake_output = StringIO.new

      task_writer = TextTaskWriter.new(fake_output)
      task_writer.add_task(task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk (12:04)
      TXT
      fake_output.reopen

      completed_task_creation_time = Time.new(2012, 1, 5, 15, 30)
      completed_task = stub(:description  => "Buy Butter",
                            :created_at   => completed_task_creation_time,
                            :completed_at => Time.new(2012, 1, 5, 16, 30),
                            :done?        => true,
                            :notes        => ["Note 1", "Note 2"])
      task_writer.add_task(completed_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk   (12:04)
----------------------
[+] Buy Butter [16:30]
    Note 1
    Note 2
      TXT
    end
  end
end

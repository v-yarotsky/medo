require_relative '../spec_helper'
require 'text_task_printer'
require 'ostruct'
require 'stringio'

describe TextTaskPrinter do
  describe "#print" do
    it "must pretty print the task to STDOUT" do
      creation_time = Time.new(2012, 1, 5, 12, 4)
      task = OpenStruct.new(:description => "Buy Milk", 
                            :created_at  => creation_time, 
                            :done?       => false,
                            :notes       => [])
      fake_output = StringIO.new

      task_printer = TextTaskPrinter.new(fake_output)
      task_printer.add_task(task)
      task_printer.print

      fake_output.string.must_equal <<-TXT
[ ] Buy Milk (12:04)
      TXT
      fake_output.reopen

      completed_task_creation_time = Time.new(2012, 1, 5, 15, 30)
      completed_task = OpenStruct.new(:description  => "Buy Butter",
                                      :created_at   => completed_task_creation_time,
                                      :completed_at => Time.new(2012, 1, 5, 16, 30),
                                      :done?        => true,
                                      :notes        => ["Note 1", "Note 2"])
      task_printer.add_task(completed_task)
      task_printer.print

      fake_output.string.must_equal <<-TXT
[ ] Buy Milk   (12:04)
----------------------
[+] Buy Butter [16:30]
    Note 1
    Note 2
      TXT
    end
  end
end

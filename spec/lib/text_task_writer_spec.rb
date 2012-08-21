require File.expand_path('../../spec_helper', __FILE__)
require 'support/task_stubs_spec_helper'
require 'medo/text_task_writer'

describe TextTaskWriter do
  include TaskStubsSpecHelper


  def task_writer(pending_tasks, completed_tasks)
    tasks = (pending_tasks + completed_tasks).tap { |c| c.stub(:active => pending_tasks, :completed => completed_tasks) }
    TextTaskWriter.new(tasks, fake_output)
  end

  describe "#write" do
    it "should pretty print the task to STDOUT" do
      task_writer([pending_task], []).write

      fake_output.string.should == <<-TXT
Buy Milk
      TXT
    end

    it "should pretty print completed tasks" do
      task_writer([], [completed_task]).write

      fake_output.string.should == <<-TXT
Buy Butter

  Note 1
  Note 2

      TXT
    end

    it "should split incomplete and complete tasks" do
      task_writer([pending_task], [completed_task]).write

      fake_output.string.should == <<-TXT
Buy Milk
----------
Buy Butter

  Note 1
  Note 2

      TXT
    end

    it "should wrap task desriptions to fit terminal width" do
      Terminal.stub(:instance => stub(:size => [10, 40])) #cols, lines

      task_writer([pending_task], [completed_task]).write

      fake_output.string.should == <<-TXT
Buy Milk
--------
Buy
  Butter

  Note 1
  Note 2

      TXT
    end

    it "should wrap notes to fit terminal width" do
      Terminal.stub(:instance => stub(:size => [20, 40])) #cols, lines

      pending_task.stub(:notes => ["Note 1 is too long to fit the terminal"])
      task_writer([pending_task], []).write

      fake_output.string.should == <<-TXT
Buy Milk

  Note 1 is too long
  to fit the
  terminal

      TXT
    end

    it "should wrap very longs words nicely" do
      Terminal.stub(:instance => stub(:size => [18, 40])) #cols, lines

      pending_task.stub(:notes => ["this is a very long sentence containing the Honorificabilitudinitatibus word"])

      task_writer([pending_task], []).write

      fake_output.string.should == <<-TXT
Buy Milk

  this is a very
  long sentence
  containing the
  Honorificabilitu
  dinitatibus word

      TXT
    end
  end
end

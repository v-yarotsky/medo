require_relative '../spec_helper'
require 'medo/task_writer'

describe TaskWriter do
  describe "#add_task" do
    it "should accept task to be printed" do
      task = stub
      writer = TaskWriter.new
      writer.add_task(task)
      writer.tasks_to_write.should == [task]
    end
  end

  it "should respond to #write" do
    TaskWriter.new.should respond_to(:write)
  end
end


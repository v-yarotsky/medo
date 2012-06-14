require File.expand_path('../../spec_helper', __FILE__)
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

  specify "#write should be abstract" do
    expect { TaskWriter.new.write }.to raise_error NotImplementedError
  end
end


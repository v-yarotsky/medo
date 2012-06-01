require_relative '../spec_helper'
require 'medo/task_writer'

describe TaskWriter do
  describe "#add_task" do
    it "must accept task to be printed" do
      task = Object.new
      writer = TaskWriter.new
      writer.add_task(task)
      writer.tasks_to_write.must_equal [task]
    end
  end

  it "must respond to #write" do
    TaskWriter.new.must_respond_to :write
  end
end


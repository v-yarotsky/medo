require_relative '../spec_helper'
require 'task_printer'

describe TaskPrinter do
  describe "#add_task" do
    it "must accept task to be printed" do
      task = Object.new
      printer = TaskPrinter.new
      printer.add_task(task)
      printer.tasks_to_print.must_equal [task]
    end
  end

  it "must respond to #print" do
    TaskPrinter.new.must_respond_to :print
  end
end


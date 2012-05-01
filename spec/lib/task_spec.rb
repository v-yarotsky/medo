require_relative '../spec_helper'
require 'ostruct'
require 'task'

describe Task do
  it "must have description attribute" do
    Task.new("description").description.must_equal "description"
  end

  it "must require description to be set" do
    proc { Task.new("") }.must_raise ArgumentError
    proc { Task.new(" ") }.must_raise ArgumentError
  end

  it "must allow notes to be set upon creation" do
    Task.new("description", :notes => ["1", "2"]).notes.must_equal ["1", "2"]
    Task.new("description", :notes => 0).notes.must_equal ["0"]
    Task.new("description", :notes => [0, nil]).notes.must_equal ["0"]
  end

  it "must assign creation time upon instantiation" do
    fake_clock = OpenStruct.new(:now => Time.now)
    using_fake_clock(fake_clock) do
      Task.new("description").created_at.must_equal fake_clock.now
    end
  end

  it "must allow assigning notes to the task" do
    task = Task.new("description")
    task.notes << "My Note"
    task.notes.must_include "My Note"
  end

  it "must not allow comparison with shit" do
    task1 = Task.new("asdfsd")
    proc { task1 <=> :foo }.must_raise ArgumentError
  end

  it "must be comparable by creation date and completion date" do
    clock = Object.new

    def clock.now
      @tick ||= 0
      @tick += 1
    end

    using_fake_clock(clock) do
      task1 = Task.new("description of task 1")
      task2 = Task.new("description of task 2")
      task3 = Task.new("description of task 3")
      task4 = Task.new("description of task 4")

      [task1, task3, task4, task2].sort.must_equal [task4, task3, task2, task1]

      task3.done
      task2.done

      [task1, task3, task4, task2].sort.must_equal [task4, task1, task2, task3]
    end
  end

  it "must not be done by default" do
    Task.new("Buy milk").wont_be :done?
  end

  it "must be done after marked as such" do
    task = Task.new("Buy milk")
    task.done
    task.must_be :done?
  end

  describe ".from_attributes" do
    it "must allow all attributes to be set from hash" do
      created_at   = Time.now
      completed_at = Time.now
      task = Task.from_attributes(:description  => "d", 
                                  :notes        => ["n"], 
                                  :done         => true, 
                                  :completed_at => completed_at, 
                                  :created_at   => created_at)
      task.description.must_equal "d"
      task.notes.must_equal ["n"]
      task.must_be :done?
      task.completed_at.must_equal completed_at
      task.created_at.must_equal created_at
    end

    it "should require description, created_at, and completed at if done set to true" do
      proc { Task.from_attributes() }.must_raise ArgumentError ,"No description given!"
      proc { Task.from_attributes(:description => " ") }.must_raise ArgumentError ,"No description given!"
      proc { Task.from_attributes(:description => "asdf") }.must_raise ArgumentError ,"Missing created_at"
      proc { Task.from_attributes(:description => "a", :created_at => Time.now, :done => true) }.must_raise ArgumentError ,"Missing completed_at"
    end
  end

  def using_fake_clock(fake_clock)
    Task.clock = fake_clock
    yield
    Task.clock = Time
  end
end


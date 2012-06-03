require_relative '../spec_helper'
require 'medo/task'

describe Task do
  it "should have description attribute" do
    Task.new("description").description.should == "description"
  end

  it "should require description to be set" do
    proc { Task.new("")  }.should raise_error(ArgumentError)
    proc { Task.new(" ") }.should raise_error(ArgumentError)
  end

  it "should allow notes to be set upon creation" do
    Task.new("description", :notes => ["1", "2"]).notes.should ==  ["1", "2"]
    Task.new("description", :notes => 0).notes.should          ==  ["0"]
    Task.new("description", :notes => [0, nil]).notes.should   ==  ["0"]
  end

  it "should assign creation time upon instantiation" do
    fake_clock = stub(:now => Time.now)
    using_fake_clock(fake_clock) do
      Task.new("description").created_at.should == fake_clock.now
    end
  end

  it "should allow assigning notes to the task" do
    task = Task.new("description")
    task.notes << "My Note"
    task.notes.should include("My Note")
  end

  it "should not allow comparison with shit" do
    task1 = Task.new("asdfsd")
    proc { task1 <=> :foo }.should raise_error(ArgumentError)
  end

  it "should be comparable by creation date and completion date" do
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

      [task1, task3, task4, task2].sort.should ==  [task4, task3, task2, task1]

      task3.done
      task2.done

      [task1, task3, task4, task2].sort.should ==  [task4, task1, task2, task3]
    end
  end

  it "should not be done by default" do
    Task.new("Buy milk").should_not be_done
  end

  it "should be done after marked as such" do
    task = Task.new("Buy milk")
    task.done
    task.should be_done
  end

  describe ".from_attributes" do
    it "should allow all attributes to be set from hash" do
      created_at   = Time.now
      completed_at = Time.now
      task = Task.from_attributes(:description  => "d", 
                                  :notes        => ["n"], 
                                  :done         => true, 
                                  :completed_at => completed_at, 
                                  :created_at   => created_at)
      task.description.should  ==  "d"
      task.notes.should        ==  ["n"]
      task.completed_at.should ==  completed_at
      task.created_at.should   ==  created_at
      task.should be_done
    end

    it "should require description, created_at, and completed at if done set to true" do
      proc { Task.from_attributes({}) }.should raise_error(ArgumentError, "No description given!")
      proc { Task.from_attributes(:description => " ") }.should raise_error(ArgumentError, "No description given!")
      proc { Task.from_attributes(:description => "asdf") }.should raise_error(ArgumentError, "Missing created_at")
      proc { Task.from_attributes(:description => "a", :created_at => Time.now, :done => true) }.should raise_error(ArgumentError, "Missing completed_at")
    end
  end

  def using_fake_clock(fake_clock)
    Task.clock = fake_clock
    yield
    Task.clock = Time
  end
end


require 'spec_helper'
require 'medo/tasks_collection'

describe Medo::TasksCollection do
  describe "comparison" do
    it "should compare by elements" do
      described_class.new([1,2,3]).should == described_class.new([1,2,3])
      described_class.new([2,3,4]).should_not == described_class.new([1,2,3])
    end
  end

  let(:completed_task1) { stub(:CompletedTask1, :done? => true, :completed_at => 1) }
  let(:completed_task2) { stub(:CimpletedTask2, :done? => true, :completed_at => 2) }
  let(:pending_task1) { stub(:PendingTask1, :done? => false, :created_at => 1) }
  let(:pending_task2) { stub(:PendingTask2, :done? => false, :created_at => 2) }

  let(:collection) { described_class.new([completed_task1, pending_task1, pending_task2, completed_task2]) }

  describe "#active" do
    it "should return collection of not finished tasks" do
      collection.active.to_a.should =~ [pending_task1, pending_task2]
    end

    it "should order tasks by creation date starting from newest" do
      collection.active.to_a.should == [pending_task2, pending_task1]
    end

    it "should return instance of TasksCollection" do
      described_class.should === collection.active
    end
  end

  describe "#completed" do
    it "should return collection of finished tasks" do
      collection.completed.to_a.should =~ [completed_task1, completed_task2]
    end

    it "should order tasks by completion date starting with most recently finished" do
      collection.completed.to_a.should == [completed_task2, completed_task1]
    end

    it "should return instance of TasksCollection" do
      described_class.should === collection.completed
    end
  end

  describe "#tagged" do
    let(:tagged_task) { stub(:TaggedTask).as_null_object }
    let(:non_tagged_task) { stub(:NonTaggedTask).as_null_object }

    let(:collection) { described_class.new([tagged_task, non_tagged_task]) }

    it "should return collection of tasks with specified tag" do
      tagged_task.should_receive(:tagged_with?).with("the-tag").and_return(true)
      non_tagged_task.should_receive(:tagged_with?).with("the-tag").and_return(false)
      collection.tagged("the-tag").to_a.should =~ [tagged_task]
    end

    it "should return empty collection if no tasks with specified tag found" do
      tagged_task.should_receive(:tagged_with?).with("qux").and_return(false)
      non_tagged_task.should_receive(:tagged_with?).with("qux").and_return(false)
      collection.tagged("qux").to_a.should =~ []
    end

    it "should return instance of TasksCollection" do
      described_class.should === collection.tagged("anytag")
    end
  end

  describe "#empty?" do
    it "should return true if collection is empty" do
      described_class.new([]).should be_empty
    end

    it "should return false if collection has tasks" do
      described_class.new([1,2,3]).should_not be_empty
    end
  end

  describe "#[]" do
    it "should return element by index" do
      collection = described_class.new([1,2])
      collection[0].should == 1
      collection[1].should == 2
    end
  end

  describe "#<<" do
    let(:collection) { described_class.new([1,2]) }

    it "should append task" do
      collection << 3
      collection.should include(3)
    end

    it "should return self" do
      (collection << 3).should == collection
    end
  end

end


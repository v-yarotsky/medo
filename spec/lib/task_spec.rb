require File.expand_path('../../spec_helper', __FILE__)
require 'medo/task'

describe Medo::Task do
  it "should have description attribute" do
    Medo::Task.new("description").description.should == "description"
  end

  Notes = Class.new unless defined? Notes
  it "should allow notes to be set upon creation" do
    args = anything
    Notes.should_receive(:new).with(args)
    Medo::Task.new("description", :notes => ["1", "2"])
  end

  it "should allow tag to be set upon creation" do
    task = Medo::Task.new("description", :tag => "qux")
    task.tag.should == "qux"
  end

  it "should assign creation time upon instantiation" do
    fake_clock = stub(:now => Time.now)
    using_fake_clock(fake_clock) do
      Medo::Task.new("description").created_at.should == fake_clock.now
    end
  end

  it "should not allow comparison with shit" do
    task1 = Medo::Task.new("asdfsd")
    proc { task1 <=> :foo }.should raise_error(ArgumentError)
  end

  it "should be comparable by creation date and completion date" do
    clock = Object.new

    def clock.now
      @tick ||= 0
      @tick += 1
    end

    using_fake_clock(clock) do
      task1 = Medo::Task.new("description of task 1")
      task2 = Medo::Task.new("description of task 2")
      task3 = Medo::Task.new("description of task 3")
      task4 = Medo::Task.new("description of task 4")

      [task1, task3, task4, task2].sort.should ==  [task4, task3, task2, task1]

      task3.done
      task2.done

      [task1, task3, task4, task2].sort.should ==  [task4, task1, task2, task3]
    end
  end

  it "should not be done by default" do
    Medo::Task.new("Buy milk").should_not be_done
  end

  it "should be done after marked as such" do
    task = Medo::Task.new("Buy milk")
    task.done
    task.should be_done
  end

  it "should reset done state if #reset called" do
    task = Medo::Task.new("Buy milk")
    task.done
    task.reset
    task.should_not be_done
  end

  describe ".from_attributes" do
    it "should allow all attributes to be set from hash" do
      created_at   = Time.now
      completed_at = Time.now
      task = Medo::Task.from_attributes("description"  => "d", 
                                        "tag"          => "the_tag",
                                        "notes"        => "n", 
                                        "done"         => true, 
                                        "completed_at" => completed_at, 
                                        "created_at"   => created_at)
      task.description.should  == "d"
      task.tag.should          == "the_tag"
      task.notes.should        == "n"
      task.completed_at.should == completed_at
      task.created_at.should   == created_at
      task.should be_done
    end

    it "should require description, created_at, and completed at if done set to true" do
      proc { Medo::Task.from_attributes({}) }.should raise_error(ArgumentError, "No description given!")
      proc { Medo::Task.from_attributes("description" => " ") }.should raise_error(ArgumentError, "No description given!")
      proc { Medo::Task.from_attributes("description" => "asdf") }.should raise_error(ArgumentError, "Missing created_at")
      proc { Medo::Task.from_attributes("description" => "a", "created_at" => Time.now, "done" => true) }.should raise_error(ArgumentError, "Missing completed_at")
    end
  end

  it "should not be equal if notes differs" do
    c = Time.now
    t1 = Medo::Task.from_attributes("description" => "d", "created_at" => c, "notes" => "foo")
    t2 = Medo::Task.from_attributes("description" => "d", "created_at" => c, "notes" => "foo")
    t1.should == t2
    t1.notes << "bar"
    t1.should_not == t2
  end

  it "should duplicate with children" do
    t1 = Medo::Task.new("description", "notes" => "my note")
    t2 = t1.dup
    t1.description.should_not equal(t2.description)
    t1.notes.should_not equal(t2.notes)
  end

  context "#description=" do
    let(:task) { Medo::Task.new("description") }

    it "should allow settings description" do
      task.description = "foo"
      task.description.should == "foo"
    end

    it "should raise if description is bad" do
      expect do
        task.description = nil
      end.to raise_error ArgumentError
    end
  end

  context "#tag=" do
    it "should assign a tag" do
      task = Medo::Task.new("description")
      task.tag = "the_tag"
      task.tag.should == "the_tag"
    end
  end

  context "#tagged_with?" do
    let(:task) { Medo::Task.new("description", :tag => "qux") }

    it "should return true if task has the specified tag" do
      task.tagged_with?("qux").should == true
    end

    it "should return false if task does not have the specified tag" do
      task.tagged_with?("yummy").should == false
    end
  end

  Notes = Class.new unless defined? Notes
  it "should create a Notes instance on #notes=" do
    t = Medo::Task.new("foo")
    Notes.should_receive(:new).with("bar")
    t.notes = "bar"
  end

  def using_fake_clock(fake_clock)
    Medo::Task.clock = fake_clock
    yield
    Medo::Task.clock = Time
  end
end


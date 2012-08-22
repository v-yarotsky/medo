require 'spec_helper'
require 'medo/tasks_collection'

describe Medo::TasksCollection do
  describe "comparison" do
    it "should compare by elements" do
      described_class.new([1,2,3]).should == described_class.new([1,2,3])
      described_class.new([2,3,4]).should_not == described_class.new([1,2,3])
    end
  end

end


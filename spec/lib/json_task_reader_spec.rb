require File.expand_path('../../spec_helper', __FILE__)
require 'support/task_stubs_spec_helper'
require 'medo/json_task_reader'
require 'stringio'

module Medo
  unless defined? Task
    class Task; end
  end

  describe JsonTaskReader do
    include TaskStubsSpecHelper

    it "should read tasks" do
      fake_input = StringIO.new '[{"done":false,"description":"Buy Milk","created_at":"2012-01-05 12:04:00",'\
          '"completed_at":null,"notes":""},{"done":true,"description":"Buy Butter","created_at":"2012-01-05 15:30:00",'\
          '"completed_at":"2012-01-05 16:30:00","notes":"Note 1\nNote 2"}]'

      Task.should_receive(:from_attributes).with(pending_task_attributes).and_return(1)
      Task.should_receive(:from_attributes).with(completed_task_attributes).and_return(2)

      JsonTaskReader.new(fake_input).read.should == [1, 2]
    end
  end 
end


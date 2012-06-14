require_relative '../spec_helper'
require 'medo/json_task_reader'
require 'stringio'

include Medo

describe JsonTaskReader do
  class Task; end

  it "should read tasks" do
    fake_input = StringIO.new '[{"done":false,"description":"Buy Milk","created_at":"2012-01-05 12:04:00 +0300",'\
        '"completed_at":null,"notes":[]},{"done":true,"description":"Buy Butter","created_at":"2012-01-05 15:30:00 +0300",'\
        '"completed_at":"2012-01-05 16:30:00 +0300","notes":["Note 1","Note 2"]}]'

    Task.should_receive(:from_attributes).with(
      "description"  => "Buy Milk",
      "created_at"   => Time.new(2012, 1, 5, 12, 4),
      "completed_at" => nil,
      "done"         => false,
      "notes"        => [],
    ).and_return(1)

    Task.should_receive(:from_attributes).with(
      "description"  => "Buy Butter",
      "created_at"   => Time.new(2012, 1, 5, 15, 30),
      "completed_at" => Time.new(2012, 1, 5, 16, 30),
      "done"         => true,
      "notes"        => ["Note 1", "Note 2"]
    ).and_return(2)

    JsonTaskReader.new(fake_input).read.should == [1, 2]
  end
end


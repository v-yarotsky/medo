require_relative '../spec_helper'
require_relative '../support/task_writer_spec_helper'
require 'medo/json_task_writer'

include Medo

describe JsonTaskWriter do
  include TaskWriterSpecHelper

  describe "#write" do
    let(:task_writer) { task_writer = JsonTaskWriter.new(fake_output) }

    it "should print tasks as json" do
      task_writer.add_task(pending_task)
      task_writer.add_task(completed_task)
      task_writer.write
      
      JSON.parse(fake_output.string).should == [
        {
          "done"         => false,
          "description"  => "Buy Milk",
          "created_at"   => "2012-01-05 12:04:00 +0300",
          "completed_at" => nil,
          "notes"        => []
        },
        {
          "done"         => true,
          "description"  => "Buy Butter",
          "created_at"   => "2012-01-05 15:30:00 +0300",
          "completed_at" => "2012-01-05 16:30:00 +0300",
          "notes"        => ["Note 1", "Note 2"]
        }
      ]
    end
  end
end


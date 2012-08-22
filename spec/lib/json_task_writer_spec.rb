require 'spec_helper'
require 'support/task_stubs_spec_helper'
require 'medo/json_task_writer'

include Medo

describe JsonTaskWriter do
  include TaskStubsSpecHelper

  describe "#write" do
    let(:task_writer) { task_writer = JsonTaskWriter.new(fake_output) }

    it "should print tasks as json" do
      task_writer.add_task(pending_task)
      task_writer.add_task(completed_task)
      task_writer.write
      
      JSON.parse(fake_output.string).should == [
        convert_time(pending_task_attributes),
        convert_time(completed_task_attributes)
      ]
    end

    def convert_time(hash)
      hash.merge!(
        "created_at" => hash["created_at"].to_s,
        "completed_at" => (hash["completed_at"].to_s if hash["completed_at"])
      )
    end
  end
end


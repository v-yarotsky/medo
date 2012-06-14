require 'stringio'
require 'time'

module TaskStubsSpecHelper
  def self.included(base)
    base.class_eval do
      let(:pending_task_attributes) do
        {
          "description"  => "Buy Milk",
          "created_at"   => Time.parse("2012-01-05 12:04:00 +0300"),
          "completed_at" => nil,
          "done"         => false,
          "notes"        => []
        }
      end

      let(:completed_task_attributes) do
        {
          "description"  => "Buy Butter",
          "created_at"   => Time.parse("2012-01-05 15:30:00 +0300"),
          "completed_at" => Time.parse("2012-01-05 16:30:00 +0300"),
          "done"         => true,
          "notes"        => ["Note 1", "Note 2"]
        }
      end

      let(:pending_task) do
        attrs = pending_task_attributes
        stub(:Task, attrs.merge("done?" => attrs["done"]))
      end

      let(:completed_task) do
        attrs = completed_task_attributes
        stub(:Task, attrs.merge("done?" => attrs["done"]))
      end

      let(:fake_output) { fake_output = StringIO.new }
    end
  end
end


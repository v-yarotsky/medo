require 'stringio'
require 'time'

module TaskStubsSpecHelper
  def self.included(base)
    base.class_eval do
      let(:pending_task_attributes) do
        {
          "description"  => "Buy Milk",
          "tag"          => "TheTag",
          "created_at"   => Time.parse("2012-01-05 12:04:00"),
          "completed_at" => nil,
          "done"         => false,
          "notes"        => ""
        }
      end

      let(:completed_task_attributes) do
        {
          "description"  => "Buy Butter",
          "tag"          => "TheTag",
          "created_at"   => Time.parse("2012-01-05 15:30:00"),
          "completed_at" => Time.parse("2012-01-05 16:30:00"),
          "done"         => true,
          "notes"        => "Note 1\nNote 2"
        }
      end

      let(:pending_task) { stub_task_from_attributes(pending_task_attributes) }

      let(:completed_task) { stub_task_from_attributes(completed_task_attributes) }

      def stub_task_from_attributes(attributes)
        attrs = attributes.dup
        stub(:Task, attrs.merge("done?" => attrs["done"])).tap do |t|
          t.notes.instance_eval do
            def map(&block)
              each_line.map(&:chomp).map(&block) 
            end
          end
        end
      end

      let(:fake_output) { fake_output = StringIO.new }
    end
  end
end


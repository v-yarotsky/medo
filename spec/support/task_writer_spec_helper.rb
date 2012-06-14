require 'stringio'

module TaskWriterSpecHelper
  def self.included(base)
    base.class_eval do
      let(:pending_task) do
        creation_time = Time.new(2012, 1, 5, 12, 4)
        task = stub(:description => "Buy Milk", 
                    :created_at  => creation_time, 
                    :done?       => false,
                    :notes       => [])
      end

      let(:completed_task) do
        completed_task_creation_time = Time.new(2012, 1, 5, 15, 30)
        completed_task = stub(:description  => "Buy Butter",
                              :created_at   => completed_task_creation_time,
                              :completed_at => Time.new(2012, 1, 5, 16, 30),
                              :done?        => true,
                              :notes        => ["Note 1", "Note 2"])
      end

      let(:fake_output) { fake_output = StringIO.new }
    end
  end
end


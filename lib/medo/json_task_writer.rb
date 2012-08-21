require 'medo/task_writer'
require 'json'

module Medo
  class JsonTaskWriter < TaskWriter
    def initialize(output_stream = STDOUT)
      super()
      @output_stream = output_stream
    end

    def write
      tasks = @tasks.map { |t| TaskPresenter.new(t).as_json }.to_json
      @output_stream.write(tasks)
    end

    class TaskPresenter
      def initialize(task)
        @task = task
      end

      def as_json
        {
          :done         => @task.done?,
          :description  => @task.description,
          :tag          => @task.tag,
          :created_at   => @task.created_at,
          :completed_at => (@task.completed_at if @task.done?),
          :notes        => @task.notes
        }
      end
    end
  end
end


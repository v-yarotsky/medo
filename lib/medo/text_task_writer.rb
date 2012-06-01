require 'medo/task_writer'

module Medo
  class TextTaskWriter < TaskWriter
    def initialize(output_stream = STDOUT)
      super()
      @output_stream = output_stream
    end

    def write
      presented_active_tasks    = present_tasks(active_tasks)
      presented_completed_tasks = present_tasks(completed_tasks)

      max_task_length = (presented_active_tasks + presented_completed_tasks).map do |t| 
        t.to_s.split("\n").map(&:size).max
      end.max
    
      presented_active_tasks.each do |t|
        @output_stream.puts t.to_s(max_task_length)
      end

      if presented_active_tasks.any? and presented_completed_tasks.any?
        @output_stream.puts "-" * max_task_length
      end

      presented_completed_tasks.each do |t|
        @output_stream.puts t.to_s(max_task_length)
      end
    end

    private

    def active_tasks
      @tasks.reject(&:done?).sort
    end

    def completed_tasks
      @tasks.select(&:done?).sort
    end

    def present_tasks(tasks)
      tasks.map { |t| TaskPresenter.new(t) }
    end

    class TaskPresenter
      def initialize(task)
        @task = task
      end

      def description
        @task.description
      end

      def time
        format = "%H:%M"
        if @task.done?
          "[#{@task.completed_at.strftime(format)}]"
        else
          "(#{@task.created_at.strftime(format)})"
        end
      end

      def notes
        "\n" + @task.notes.map do |n|
          "    #{n}"
        end.join("\n")
      end
      
      def done
        "[#{@task.done? ? '+' : ' '}]"
      end

      def elements_except_time
        [done, description]
      end

      def to_s(length = nil)
        result = elements_except_time.join(" ") + " "
        result += length.nil? ? time : time.rjust(length - result.size)
        result += notes unless @task.notes.empty?
        result
      end
    end

  end
end


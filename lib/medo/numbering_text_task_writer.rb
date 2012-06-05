require 'medo/text_task_writer'

module Medo
  class NumberingTextTaskWriter < TextTaskWriter
    private

    def present_tasks(tasks)
      max_tasks_count = [active_tasks.count, completed_tasks.count].max
      tasks.each_with_index.map do |t, i|
        NumberingTaskPresenter.new(t, i + 1, max_tasks_count)
      end
    end

    class NumberingTaskPresenter < TaskPresenter
      def initialize(task, number, count)
        super(task)
        @number        = number
        @number_length = count.to_s.size
      end

      def number
        format = "%-#{@number_length + 1}s"
        format % (@task.done? ? "" : "#@number.")
      end

      def done
        "#{number} [#{@task.done? ? '+' : ' '}]"
      end
    end

  end
end


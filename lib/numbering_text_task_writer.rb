require 'text_task_writer'

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

    def notes
      "\n" + @task.notes.map do |n|
        " " * number.size + " " + n
      end.join("\n")
    end

    def number
      format = "%-#{@number_length + 1}s"
      format % (@task.done? ? "" : "#@number.")
    end

    def done
      "[#{@task.done? ? '+' : ' '}]"
    end

    def elements_except_time
      [number, done, description]
    end
  end

end


require 'medo/task_writer'
require 'medo/terminal'

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

      max_output_width = [Terminal.instance.size.first, max_task_length].min
    
      presented_active_tasks.each do |t|
        @output_stream.puts t.to_s(max_output_width)
      end

      if presented_active_tasks.any? and presented_completed_tasks.any?
        @output_stream.puts "-" * max_output_width
      end

      presented_completed_tasks.each do |t|
        @output_stream.puts t.to_s(max_output_width)
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

      def description(length = nil)
        if length
          words = @task.description.split

          words.each_with_object(0).each_with_object([]) do |(w, current_line), lines|
            line = lines[current_line].to_s
            if (line + w).length > length
              current_line += 1
              redo
            else
              (line << " #{w}").lstrip!
            end
            lines[current_line] = line
          end
        else
          @task.description
        end
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
        return "" if @task.notes.empty?
        @task.notes.any?
        "\n\n" + @task.notes.map do |n|
          n.rjust(n.length + done.length + 1)
        end.join("\n")
      end
      
      def done
        "[#{@task.done? ? '+' : ' '}]"
      end

      def to_s(length = nil)
        if length
          description_length = length - done.length - time.length - 2
          desc = description(description_length)
          desc.map! do |line|
            line.ljust(description_length).rjust(done.length + 1 + description_length) 
          end
          desc.first.lstrip!
          "#{done} #{desc.join("\n")} #{time}#{notes}"
        else
          "#{done} #{description} #{time}#{notes}"
        end
      end
    end

  end
end


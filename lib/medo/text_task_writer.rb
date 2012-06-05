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

      def description(length = nil, options = {})
        if length
          break_line_to_fit(@task.description, length, options)
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

      def notes(length = nil, options = {})
        return "" if @task.notes.empty?
        "\n\n" + @task.notes.map do |n|
          if length
            break_line_to_fit(n, length, options)
          else
            n.rjust(n.length + done.length + 1)
          end
        end.join("\n") + "\n\n"
      end
      
      def done
        "[#{@task.done? ? '+' : ' '}]"
      end

      def to_s(length = nil)
        if length
          description_length = length - done.length - time.length - 2
          description_padding = done.length + 1
          formatted_description = description(description_length, :left_padding => description_padding)

          notes_length = length - done.length - 1
          notes_first_line_padding = done.length + 1
          notes_padding = notes_first_line_padding + 2
          formatted_notes = notes(notes_length, :first_line_padding => notes_first_line_padding, :left_padding => notes_padding)

          "#{done} #{formatted_description} #{time}#{formatted_notes}"
        else
          "#{done} #{description} #{time}#{notes}"
        end
      end

      private

      def break_line_to_fit(str, length, options = {})
        first_line_padding = options[:first_line_padding]
        left_padding       = options[:left_padding]
        padding_diff       = (left_padding - first_line_padding) if first_line_padding && left_padding
        available_length   = length - padding_diff.to_i

        lines = str.gsub(/(.{1,#{available_length}})(?:\s+|\Z)|(.{1,#{available_length}})/m, "\\1\\2\n").split("\n")

        lines.map! do |line|
          line.strip.ljust(available_length).rjust(available_length + left_padding.to_i) 
        end

        lines[0] = lines.first.strip.ljust(length).rjust(length + first_line_padding.to_i)
        lines.join("\n")
      end
    end

  end
end


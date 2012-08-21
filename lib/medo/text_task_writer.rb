require 'medo/task_writer'
require 'medo/terminal'

module Medo
  class TextTaskWriter < TaskWriter
    class TasksCollection
      include Enumerable

      def initialize(tasks)
        @tasks = tasks
      end

      def each
        @tasks.each { |t| yield t }
      end

      def active
        @tasks.reject(&:done?).sort_by { |t| t.completed_at }.reverse
      end

      def completed
        @tasks.select(&:done?).sort_by { |t| t.created_at }.reverse
      end

      def <<(task)
        @tasks << task
        self
      end
    end

    def initialize(tasks, output_stream = STDOUT)
      super()
      @tasks = tasks
      @output_stream = output_stream
    end

    def write
      presented_active_tasks    = present_tasks(@tasks.active)
      presented_completed_tasks = present_tasks(@tasks.completed)

      presented_active_tasks.each do |t|
        @output_stream.puts t.to_s
      end

      if presented_active_tasks.any? and presented_completed_tasks.any?
        @output_stream.puts "-" * (presented_active_tasks + presented_completed_tasks).map(&:to_s).join("\n").each_line.max_by(&:size).chomp.size
      end

      presented_completed_tasks.each do |t|
        @output_stream.puts t.to_s
      end
    end

    private

    def present_tasks(tasks)
      tasks.map { |t| WrappingTaskPresenter.new(t, Terminal.instance.size.first) }
    end

    class WrappingTaskPresenter
      def initialize(task, max_length)
        @task = task
        @length = max_length
      end

      def description
        format_component(@task.description)
      end

      def notes
        return "" if @task.notes.empty?
        "\n\n" + @task.notes.map { |n| note(n) }.join("\n") + "\n\n"
      end

      def note(n)
        format_component(n)
      end

      def to_s
        "#{description.lstrip}#{notes}"
      end

      private

      def format_component(str)
        r = break_line_to_fit(str)
        pad_str(r)
      end

      def break_line_to_fit(str)
        str.gsub(/(.{1,#{length}})(?:\s+|\Z)|(.{1,#{length}})/m, "\\1\\2\n")
      end

      def pad_str(str)
        padding_str = " " * padding.to_i
        str.each_line.map do |line|
          padding_str + line.strip
        end.join("\n")
      end

      def padding
        2
      end

      def length
        @length - padding
      end
    end
  end
end

Dir.glob(File.dirname(__FILE__) + '/text_task_writer/decorators/*_decorator.rb') do |decorator|
  require decorator
end


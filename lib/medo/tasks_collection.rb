module Medo
  class TasksCollection
    include Enumerable

    def initialize(tasks)
      @tasks = tasks
    end

    def each
      @tasks.each { |t| yield t }
    end

    def active
      @tasks.reject(&:done?).sort_by { |t| t.created_at }.reverse
    end

    def completed
      @tasks.select(&:done?).sort_by { |t| t.completed_at }.reverse
    end

    def tagged(tag)
      self.class.new @tasks.select { |t| t.tagged_with?(tag) }
    end

    def empty?
      @tasks.empty?
    end

    def <<(task)
      @tasks << task
      self
    end
  end
end


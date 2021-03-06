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
      self.class.new @tasks.reject(&:done?).sort_by { |t| t.created_at }.reverse
    end

    def completed
      self.class.new @tasks.select(&:done?).sort_by { |t| t.completed_at }.reverse
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

    def [](index)
      @tasks[index]
    end

    def ==(other)
      return true if self.equal?(other)
      return false unless self.class === other
      self.each_with_index.all? { |t, i| t == other[i] }
    end
  end
end


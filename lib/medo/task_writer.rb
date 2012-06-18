require 'medo/task'

module Medo
  class TaskWriter
    def initialize
      @tasks = []
    end

    def add_task(*tasks)
      @tasks += tasks.flatten
    end
    alias add_tasks add_task

    def tasks_to_write
      @tasks.dup
    end

    def write
      raise NotImplementedError
    end
  end
end


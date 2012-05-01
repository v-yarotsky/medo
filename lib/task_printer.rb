class TaskPrinter
  def initialize
    @tasks = []
  end

  def add_task(*tasks)
    @tasks += tasks.flatten
  end
  alias add_tasks add_task

  def tasks_to_print
    @tasks.dup
  end

  def print
    raise NotImplementedError
  end
end


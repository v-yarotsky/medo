require 'task_printer'

class BinaryTaskPrinter < TaskPrinter
  def initialize(output_stream)
    super()
    @output_stream = output_stream
  end

  def print
    @output_stream.write Marshal.dump(@tasks)
  end
end


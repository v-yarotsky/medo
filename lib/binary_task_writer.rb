require 'task_writer'

class BinaryTaskWriter < TaskWriter
  def initialize(output_stream)
    super()
    @output_stream = output_stream
  end

  def write
    @output_stream.write Marshal.dump(@tasks)
  end
end


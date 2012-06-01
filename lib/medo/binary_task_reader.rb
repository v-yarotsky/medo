require 'medo/task_reader'

module Medo
  class BinaryTaskReader < TaskReader
    def initialize(input_stream)
      super()
      @input_stream = input_stream
    end

    def read
      Marshal.load(@input_stream.read)
    end
  end
end


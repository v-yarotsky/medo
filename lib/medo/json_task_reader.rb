require 'medo/task_reader'
require 'json'
require 'time'

module Medo
  class JsonTaskReader < TaskReader
    def initialize(input_stream)
      super()
      @input_stream = input_stream
    end

    def read
      tasks = []
      JSON.parse(@input_stream.read).map do |task_attributes|
        instantiate_task(task_attributes)
      end
    end

    private

    def instantiate_task(attributes)
      attributes["created_at"] = Time.parse(attributes["created_at"])
      if attributes["done"]
        attributes["completed_at"] = Time.parse(attributes["completed_at"])
      end
      Task.from_attributes(attributes)
    end
  end
end



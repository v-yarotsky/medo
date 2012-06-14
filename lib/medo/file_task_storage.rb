require 'fileutils'
require 'tempfile'
require 'medo/json_task_reader'
require 'medo/json_task_writer'

module Medo
  class FileTaskStorage
    def self.using_storage(filename)
      storage = self.new(filename)
      yield storage
    ensure
      storage.dispose if storage
    end

    def initialize(filename, reader_class = JsonTaskReader, writer_class = JsonTaskWriter)
      @filename, @reader_class, @writer_class = filename, reader_class, writer_class
      FileUtils.touch(@filename)
    end

    def read
      begin
        File.open(@filename, "rb") do |f|
          @reader_class.new(f).read
        end
      rescue => e
        []
      end
    end

    def write(tasks)
      serializer = @writer_class.new(tempfile)
      serializer.add_tasks(tasks)
      serializer.write
    ensure
      tempfile.close
    end

    def commit
      FileUtils.cp(tempfile.path, @filename)
    end

    def dispose
      tempfile.unlink
    end

    private

    def tempfile
      @tempfile ||= Tempfile.new(File.basename(@filename), :binmode => true)
    end
  end
end


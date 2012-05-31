require 'fileutils'
require 'tempfile'
require 'binary_task_reader'
require 'binary_task_printer'

class FileTaskStorage
  def self.using_storage(filename)
    storage = self.new(filename)
    yield storage
  ensure
    storage.dispose if storage
  end

  def initialize(filename)
    @filename = filename
    FileUtils.touch(@filename)
  end

  def read
    begin
      File.open(@filename, "rb") do |f|
        BinaryTaskReader.new(f).read
      end
    rescue ArgumentError => e
      []
    end
  end

  def write(tasks)
    serializer = BinaryTaskPrinter.new(tempfile)
    serializer.add_tasks(tasks)
    serializer.print
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


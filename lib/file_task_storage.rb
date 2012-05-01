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
      File.open(TASKS_FILE, "rb") do |f|
        BinaryTaskReader.new(f).read
      end
    rescue ArgumentError => e
      []
    end
  end

  def write(tasks)
    @tempfile ||= Tempfile.new(File.basename(@filename), :binmode => true)
    serializer = BinaryTaskPrinter.new(@tempfile)
    serializer.add_tasks(tasks)
    serializer.print
  ensure
    @tempfile.close if @tempfile
  end

  def commit
    FileUtils.cp(@tempfile.path, @filename)
  end

  def dispose
    if @tempfile
      # puts "Removing #{@tempfile.path}"
      @tempfile.unlink
    end
  end
end


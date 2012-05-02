require_relative '../spec_helper'
require 'file_task_storage'

describe FileTaskStorage do
  before(:each) do
    verbosity, $VERBOSE = $VERBOSE, nil
    load 'fileutils.rb'
    load 'binary_task_reader.rb'
    load 'binary_task_printer.rb'
    $VERBOSE = verbosity
  end

  describe "#initialize" do
    it "must touch a storage file, so it is created if not exists" do
      touched = false
      FileUtils.define_singleton_method :touch do |f|
        touched = true if f == "f"
      end
      FileTaskStorage.new("f")
      touched.must_equal true
    end
  end

  describe "#read" do
    it "return empty array on error" do
      def BinaryTaskReader.read
        raise
      end
      FileTaskStorage.new("f").read.must_equal []
    end
  end

  describe "#write" do
    it "must write to tempfile only" do
      mock = MiniTest::Mock.new
      storage = FileTaskStorage.new("f")
      storage.define_singleton_method(:tempfile) { mock }
      mock.expect(:write, nil, [Marshal.dump([])])
      mock.expect(:close, nil)
      storage.write([])
      mock.verify
    end

    it "must close tempfile if error occured" do
      mock = MiniTest::Mock.new
      storage = FileTaskStorage.new("f")
      storage.define_singleton_method(:tempfile) { mock }
      mock.expect(:close, nil)
      BinaryTaskPrinter.define_singleton_method(:new) { |*args| raise }
      begin
        storage.write([])
      rescue
        #nothing
      end
      mock.verify
    end
  end

  after(:each) do
    FileUtils.rm("f") if File.exists?("f")
  end
end

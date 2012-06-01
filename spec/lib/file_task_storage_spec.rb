require_relative '../spec_helper'
require 'file_task_storage'

describe FileTaskStorage do
  before(:each) do
    verbosity, $VERBOSE = $VERBOSE, nil
    load 'fileutils.rb'
    $VERBOSE = verbosity
  end

  describe "#initialize" do
    it "must touch a storage file, so it is created if not exists" do
      catch(:touched) do
        FileUtils.stub :touch, proc { throw :touched, true } do |f|
          FileTaskStorage.new("f")
        end
      end.must_equal true
    end
  end

  describe "#read" do
    it "return empty array on error" do
      class Reader; def read; raise; end; end
      FileTaskStorage.new("f", Reader, Class).read.must_equal []
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
      class Writer; def write; raise; end; end
      mock = MiniTest::Mock.new
      storage = FileTaskStorage.new("f", Class, Writer)
      storage.stub :tempfile, mock do
        mock.expect(:close, nil)
        storage.write([]) rescue nil #nothing
        mock.verify
      end
    end
  end

  after(:each) do
    FileUtils.rm("f") if File.exists?("f")
  end
end

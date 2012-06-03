require_relative '../spec_helper'
require 'medo/file_task_storage'

describe FileTaskStorage do
  before(:each) do
    verbosity, $VERBOSE = $VERBOSE, nil
    load 'fileutils.rb'
    $VERBOSE = verbosity
  end

  describe "#initialize" do
    it "should touch a storage file, so it is created if not exists" do
      FileUtils.should_receive(:touch)
      FileTaskStorage.new("f")
    end
  end

  describe "#read" do
    it "return empty array on error" do
      class Reader; def read; raise; end; end
      FileTaskStorage.new("f", Reader, Class).read.should ==  []
    end
  end

  describe "#write" do
    it "should write to tempfile only" do
      storage = FileTaskStorage.new("f")
      tempfile = mock
      storage.stub(:tempfile => tempfile)
      tempfile.should_receive(:write).with(Marshal.dump([]))
      tempfile.should_receive(:close)
      storage.write([])
    end

    it "should close tempfile if error occured" do
      class Writer
        def write
          raise
        end
      end

      tempfile = mock
      storage = FileTaskStorage.new("f", Class, Writer)
      storage.stub(:tempfile => tempfile)
      tempfile.should_receive(:close)
      storage.write([]) rescue nil #nothing
    end
  end

  after(:each) do
    FileUtils.rm("f") if File.exists?("f")
  end
end

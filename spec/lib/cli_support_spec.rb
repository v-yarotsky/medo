require 'spec_helper'
require 'medo/cli_support'

describe "CLISupport" do
  class CLISupportContext
    include Medo::CLISupport

    def storage
      @storage ||= RSpec::Mocks::Mock.new(:Storage)
    end

    def global_options
      @global_options ||= {}
    end
  end
  # def load_commands
  # def choose_task(select_options = {})
  # def get_input

  let(:tasks) { ["foo", "bar"] }

  before(:each) do
    @context = CLISupportContext.new
    @context.storage.stub(:read => tasks)
  end

  describe "#tasks" do
    it "should read and memoize tasks" do
      @context.tasks.to_a.should == tasks
    end
  end

  describe "#tasks_changed" do
    it "should react to changess in tasks collection" do
      @context.tasks
      expect do
        tasks.last.upcase!
      end.to change { @context.tasks_changed? }
    end
  end

  describe "#colorize" do
    let(:touch) { mock }

    it "should yield if color mode enabled" do
      @context.global_options[:"no-color"] = true #color
      touch.should_receive(:touched)
      @context.colorize { touch.touched }
    end

    it "should not yield if color mode disabled" do
      @context.global_options[:"no-color"] = false #no color
      touch.should_not_receive(:touched)
      @context.colorize { touch.touched }
    end
  end

  describe "#committing tasks" do
    it "should write and commit tasks if changed" do
      @context.storage.should_receive(:write).with(tasks)
      @context.storage.should_receive(:commit)
      @context.tasks
      @context.committing_tasks do
        tasks.last.upcase!
      end
    end

    it "should not write tasks if not changed" do
      @context.storage.should_not_receive(:write)
      @context.storage.should_not_receive(:commit)
      @context.tasks
      @context.committing_tasks { }
    end
  end

end



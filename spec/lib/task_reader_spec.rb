require File.expand_path('../../spec_helper', __FILE__)
require 'medo/task_reader'

describe TaskReader do
  it "should respond to #read" do
    TaskReader.new.should respond_to(:read)
  end
end


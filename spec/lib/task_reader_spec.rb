require_relative '../spec_helper'
require 'task_reader'

describe TaskReader do
  it "must respond to #read" do
    TaskReader.new.must_respond_to :read
  end
end


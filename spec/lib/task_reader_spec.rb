require File.expand_path('../../spec_helper', __FILE__)
require 'medo/task_reader'

describe TaskReader do
  specify "#read should be abstract" do
    expect { TaskReader.new.read }.to raise_error NotImplementedError
  end
end


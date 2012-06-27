require File.expand_path('../../spec_helper', __FILE__)
require 'medo/notes'

module Medo
  describe Notes do
    it "should be create from various arguments" do
      Notes.new(["1", "2"]).should == "1\n2"
      Notes.new(0).should          == "0"
      Notes.new([0, nil]).should   == "0"
      Notes.new("note").should     == "note"
      Notes.new.should             == ""
    end

    it "should allow appending notes" do
      notes = Notes.new
      notes << "My Note"
      notes.should == "My Note"
      notes << "FooBar"
      notes.should == "My Note\nFooBar"
    end

    it "should be coerced to string" do
      Notes.new(["foo", "bar"]).to_s.should == "foo\nbar"
    end

    it "should respond to #empty?" do
      Notes.new.should be_empty
      Notes.new("foo").should_not be_empty
    end

    it "should be enumerable" do
      expect { |b| Notes.new("foo\nbar").each(&b) }.to yield_successive_args("foo", "bar")
    end

    it "should test for equality" do
      Notes.new("foo").should == Notes.new("foo")
      Notes.new("foo").should_not == Notes.new("foo\nbar")
    end

    it "should be duplicable" do
      n1 = Notes.new("foo")
      n2 = n1.dup
      n1 << "bar"
      n2.should == "foo"
    end
  end
end


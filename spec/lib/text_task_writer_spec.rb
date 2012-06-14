require_relative '../spec_helper'
require_relative '../support/task_writer_spec_helper'
require 'medo/text_task_writer'

describe TextTaskWriter do
  include TaskWriterSpecHelper

  describe "#write" do
    let(:task_writer) { task_writer = TextTaskWriter.new(fake_output) }

    it "should pretty print the task to STDOUT" do
      task_writer.add_task(pending_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk (12:04)
      TXT
    end

    it "should pretty print completed tasks" do
      task_writer.add_task(completed_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[+] Buy Butter [16:30]

    Note 1            
    Note 2            

      TXT
    end

    it "should split incomplete and complete tasks" do
      task_writer.add_task(pending_task)
      task_writer.add_task(completed_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk   (12:04)
----------------------
[+] Buy Butter [16:30]

    Note 1            
    Note 2            

      TXT
    end

    it "should wrap task desriptions to fit terminal width" do
      Terminal.stub(:instance => stub(:size => [20, 40])) #cols, lines
      
      task_writer.add_task(pending_task)
      task_writer.add_task(completed_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk (12:04)
--------------------
[+] Buy     
    Butter   [16:30]

    Note 1          
    Note 2          

      TXT
    end

    it "should wrap notes to fit terminal width" do
      Terminal.stub(:instance => stub(:size => [20, 40])) #cols, lines
      
      task_writer.add_task(pending_task)
      pending_task.stub(:notes => ["Note 1 is too long to fit the terminal"])
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk (12:04)

    Note 1 is too   
      long to fit   
      the terminal  

      TXT
    end

    it "should pass edge fucking case" do
      Terminal.stub(:instance => stub(:size => [20, 40])) #cols, lines

      pending_task.stub(:notes => ["this is a very long sentence containing the Honorificabilitudinitatibus word"])

      task_writer.add_task(pending_task)
      task_writer.write

      fake_output.string.should == <<-TXT
[ ] Buy Milk (12:04)

    this is a very  
      long sentence 
      containing the
      Honorificabili
      tudinitatibus 
      word          

      TXT
      # s = "this is a very long sentence containing the Honorificabilitudinitatibus word"
      # w = s.split(/(.{1,20})(?:\s+|\Z|)|(.{1,20})/m).map(&:strip).reject(&:empty?).should == ["this is a very long", "sentence containing", "the Honorificabilitu", "dinitatibus word"]
    end
  end
end

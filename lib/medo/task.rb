module Medo
  class Task
    include Comparable

    attr_reader :description, :created_at, :completed_at, :notes

    class << self
      attr_accessor :clock

      def from_attributes(attributes)
        task = Task.new(attributes.delete("description"), attributes)
        task.instance_eval do
          @created_at = attributes["created_at"] or raise ArgumentError, "Missing created_at"
          @done = attributes["done"]
          @completed_at = attributes["completed_at"] or raise ArgumentError, "Missing completed_at" if @done
        end
        task
      end
    end
    self.clock = Time

    def initialize(description, options = {})
      @description  = description.to_s.strip
      raise ArgumentError, "No description given!" if @description.empty?
      @created_at   = clock.now
      @completed_at = nil
      @notes        = parse_notes(options["notes"] || options[:notes])
    end

    def <=>(other)
      unless other.kind_of?(Task)
        raise ArgumentError, "comparison of #{self.class.name} with #{other.class.name} failed"
      end

      case [self.completed_at.nil?, other.completed_at.nil?]
      when [true, true]   then (self.created_at <=> other.created_at) * -1
      when [false, false] then (self.completed_at <=> other.completed_at) * -1
      when [true, false]  then -1
      when [false, true]  then 1
      end
    end

    def done
      @completed_at = clock.now
      @done         = true
    end

    def done?
      !!@done
    end

    private

    def clock
      self.class.clock
    end

    def parse_notes(notes)
      Array(notes).map { |n| n.to_s.strip }.reject(&:empty?)
    end
  end
end


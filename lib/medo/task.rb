require 'medo/notes'

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
      self.description = description
      @created_at   = clock.now
      @completed_at = nil
      self.notes    = options["notes"] || options[:notes]
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

    def ==(other)
      return true if other.equal? self
      return false unless other.kind_of?(self.class)
      self.description    == other.description &&
        self.created_at   == other.created_at &&
        self.done?        == other.done? &&
        self.completed_at == other.completed_at &&
        self.notes        == other.notes
    end

    def initialize_copy(source)
      super
      @description  = @description.dup
      @created_at   = @created_at.dup
      @completed_at = @completed_at.dup if @completed_at
      @notes        = @notes.dup
    end

    def description=(desc)
      description = desc.to_s.strip
      raise ArgumentError, "No description given!" if description.empty?
      @description  = description
    end

    def notes=(*args)
      @notes = Notes.new(*args)
    end

    def done
      @completed_at = clock.now
      @done         = true
    end

    def reset
      @completed_at = nil
      @done         = false
    end

    def done?
      !!@done
    end

    private

    def clock
      self.class.clock
    end
  end
end


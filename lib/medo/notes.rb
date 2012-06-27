require 'forwardable'

module Medo
  class Notes
    include Comparable
    include Enumerable
    extend Forwardable

    def_delegators :@notes, :<=>, :empty?

    def initialize(*args)
      @notes = args.flatten.map { |n| n.to_s.strip }.reject(&:empty?).join("\n")
    end

    def <<(other)
      @notes << "\n#{other}"
      @notes.lstrip!
    end

    def each
      @notes.each_line { |line| yield line.chomp }
    end

    def ==(other)
      return true if other.equal? self
      other.to_s == @notes
    end

    def initialize_copy(source)
      super
      @notes = @notes.dup
    end

    def to_s
      @notes
    end
  end
end


module Medo
  module Support

    ##
    # This module is intended to extend other (decorator) modules
    #
    # Usage:
    #  
    #   module MyDecorator
    #     extend Decorator
    #
    #     after_decorate do |arg1, arg2|
    #       @arg1, @arg2 = arg1, arg2
    #       ...
    #     end
    #
    #     #methods go here
    #   end
    #
    #   decorated = Object.new
    #   MyDecorator.decorate(decorate, :foo, :bar)
    #
    # :foo and :bar go to after_decorate block, which is evaluated 
    # on decorated object
    #
    # after_update block is optional
    #
    module Decorator
      def decorate(base, *args)
        base.extend(self)
        base.instance_exec(*args, &@after_decorate_block) if defined? @after_decorate_block
        base
      end

      def after_decorate(&block)
        @after_decorate_block = block
      end
    end
  end
end

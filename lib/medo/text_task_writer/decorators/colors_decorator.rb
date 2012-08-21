require 'rubygems'
require 'rainbow'

module Medo
  class TextTaskWriter
    module Decorators
      module ColorsDecorator
        extend Support::Decorator

        private

        def present_tasks(tasks)
          super.each { |t| TaskColors.decorate(t) }
        end

        module TaskColors
          extend Support::Decorator

          def number
            super.to_s.color(:red)
          end

          def tag
            str = super
            str.bright unless String(str).empty?
          end

          private

          def preserve_size(str, colored_str)
            colored_str.instance_eval <<-RUBY
              def size; #{str.size}; end
            RUBY
            colored_str
          end
        end
      end
    end
  end
end


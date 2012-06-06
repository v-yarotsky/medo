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

          def to_s(length = nil)
            c = components(length)
            "#{c.done.color(:red)} #{c.description.color(:black)} #{c.time.color(:yellow)}#{c.notes}"
          end
        end
      end
    end
  end
end


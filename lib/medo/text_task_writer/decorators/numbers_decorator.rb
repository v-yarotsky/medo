module Medo
  class TextTaskWriter
    module Decorators
      module NumbersDecorator
        extend Decorator

        def present_tasks(tasks)
          max_tasks_count = [active_tasks.count, completed_tasks.count].max
          super.each_with_index.map do |t, i|
            TaskNumbers.decorate(t, i + 1, max_tasks_count)
          end
        end

        module TaskNumbers
          extend Decorator

          after_decorate do |number, total|
            @number        = number
            @number_length = total.to_s.size
          end

          def number
            format = "%-#{@number_length + 1}s"
            format % (@task.done? ? "" : "#@number.")
          end

          def done
            "#{number} #{super}"
          end
        end
      end
    end
  end
end


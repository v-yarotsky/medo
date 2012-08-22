require 'medo/support/decorator'

module Medo
  class TextTaskWriter
    module Decorators
      module NumbersDecorator
        extend Support::Decorator

        after_decorate do |options|
          @num_options = options
        end

        def present_tasks(tasks)
          max_tasks_count = [@tasks.active.count, @tasks.completed.count].max
          super.each_with_index.map do |t, i|
            TaskNumbers.decorate(t, i + 1, max_tasks_count, @num_options)
          end
        end

        module TaskNumbers
          extend Support::Decorator

          after_decorate do |number, total, options|
            @number        = number
            @number_length = total.to_s.size
            @num_options   = options || {}
          end

          def number
            format = "%-#{@number_length + 1}s"
            format % (number? ? "" : "#@number.")
          end

          def number?
            @num_options[:done] && @task.done? ||
              @num_options[:pending] && !@task.done?
          end

          def padding
            super + number.size + 1
          end

          def to_s
            "#{number} #{super}"
          end
        end
      end
    end
  end
end


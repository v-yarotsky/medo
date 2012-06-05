require 'medo/numbering_text_task_writer'
require 'rainbow'

module Medo
  class ColorNumberingTextTaskWriter < NumberingTextTaskWriter
    private

    def present_tasks(tasks, presenter_class = ColorNumberingTaskPresenter)
      super
    end

    class ColorNumberingTaskPresenter < NumberingTaskPresenter
      def to_s(length = nil)
        c = components(length)
        "#{c.done.color(:red)} #{c.description.color(:black)} #{c.time.color(:yellow)}#{c.notes}"
      end
    end

  end
end


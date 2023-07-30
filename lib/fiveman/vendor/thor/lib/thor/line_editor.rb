require "fiveman/vendor/thor/lib/thor/line_editor/basic"
require "fiveman/vendor/thor/lib/thor/line_editor/readline"

class Fiveman::Thor
  module LineEditor
    def self.readline(prompt, options = {})
      best_available.new(prompt, options).readline
    end

    def self.best_available
      [
        Fiveman::Thor::LineEditor::Readline,
        Fiveman::Thor::LineEditor::Basic
      ].detect(&:available?)
    end
  end
end

require 'list'
require 'path/printer'

module Path
  class List < ::List

    def print(**keywords)
      Printer.call(self, **keywords)
    end

    def values
      map(&:value)
    end

    def with_descriptions
      self.class.new select(&:description?)
    end

    def value_justification
      values.map(&:length).max
    end

    def join(separator=File::PATH_SEPARATOR)
      super(separator)
    end

    def sub(pattern, replacement)
      self.class.new map { |path| path.sub(pattern, replacement) }
    end

  end
end


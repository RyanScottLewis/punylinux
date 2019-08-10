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

  end
end


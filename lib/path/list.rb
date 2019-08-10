require 'list'

module Path
  class List < ::List

    def names
      map(&:name)
    end

    def values
      map(&:value)
    end

    def with_descriptions
      self.class.new select(&:description?)
    end

    def name_justification
      names.map(&:length).max
    end

    def value_justification
      values.map(&:length).max
    end

  end
end


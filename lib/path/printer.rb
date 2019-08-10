require 'printer'

module Path
  class Printer < ::Printer

    def call(paths, all: false)
      paths               = paths.with_descriptions unless all
      name_justification  = paths.name_justification
      value_justification = paths.value_justification

      paths.each do |path|
        puts "%s = %s # %s" % [
          path.name.to_s.ljust(name_justification),
          path.value.to_s.ljust(value_justification),
          path.description
        ]
      end
    end

  end
end


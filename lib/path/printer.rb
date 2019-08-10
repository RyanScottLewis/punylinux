require 'printer'

module Path
  class Printer < ::Printer

    def call(paths, all: false)
      paths               = paths.with_descriptions unless all
      name_justification  = paths.name_justification
      value_justification = paths.value_justification

      paths.each do |path|
        message = if all
          if path.description?
            "# %s\n%s = %s\n\n" % [
              path.description,
              path.name.to_s.ljust(name_justification),
              path.value
            ]
          else
            "%s = %s\n\n" % [
              path.name.to_s.ljust(name_justification),
              path.value
            ]
          end
        else
          "%s = %s # %s" % [
            path.name.to_s.ljust(name_justification),
            path.value.to_s.ljust(value_justification),
            path.description
          ]
        end

        puts message
      end
    end

  end
end


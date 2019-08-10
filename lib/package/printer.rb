require 'printer'

module Package
  class Printer < ::Printer

    def call(packages)
      name_justification    = packages.name_justification
      version_justification = packages.version_justification

      packages.each do |package|
        puts "%s %s = %s" % [
          package.name.to_s.ljust(name_justification),
          package.version.ljust(version_justification),
          package.archive.uri
        ]
      end
    end

  end
end


require 'list'
require 'package/path_resolver'
require 'package/printer'

module Package
  class List < ::List

    def print(**keywords)
      Printer.call(self, **keywords)
    end

    def versions
      map(&:version)
    end

    def version_justification
      versions.map(&:length).max
    end

    def with_paths!(paths)
      each { |package| PathResolver.call(paths, package) }
    end

    def archive_paths
      map(&:archive_path)
    end

    def build_paths
      map(&:build_path)
    end

    def build_lock_paths
      map(&:build_lock_path)
    end

    def package_lock_paths
      map(&:package_lock_path)
    end

    def with_checksums
      select(&:checksum?)
    end

    def checksum_paths
      with_checksums.map(&:checksum_path)
    end

    def checksum_lock_paths
      with_checksums.map(&:checksum_lock_path)
    end

    def with_signatures
      select(&:signature?)
    end

    def signature_paths
      with_signatures.map(&:signature_path)
    end

    def signature_lock_paths
      with_signatures.map(&:signature_lock_path)
    end

    def with_files
      select(&:files?)
    end

    def files
      with_files.map(&:files).flatten
    end

    def install_paths
      with_files.map(&:install_paths).flatten
    end

  end
end


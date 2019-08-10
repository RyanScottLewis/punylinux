require 'list'
require 'package/path_resolver'

module Package
  class List < ::List

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

    def install_files
      with_files.map(&:install_files).flatten
    end

  end
end


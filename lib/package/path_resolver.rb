require 'forwardable'

module Package
  class PathResolver

    class Struct

      attr_accessor :archive_path
      attr_accessor :checksum_path
      attr_accessor :signature_path
      attr_accessor :build_path
      attr_accessor :lock_path
      attr_accessor :checksum_lock_path
      attr_accessor :signature_lock_path
      attr_accessor :build_lock_path

    end

    def self.call(paths, package)
      new(paths).call(package)
    end

    def initialize(paths)
      @paths = paths
    end

    def call(package)
      struct = Struct.new

      struct.archive_path        = @paths.sources.join(package.archive.basename)
      struct.checksum_path       = @paths.sources.join(package.identifier).append_ext('.checksum')  if package.checksum?
      struct.signature_path      = @paths.sources.join(package.identifier).append_ext('.signature') if package.signature?
      struct.build_path          = @paths.builds.join(package.identifier)
      struct.lock_path           = @paths.tmp.join(package.identifier)
      struct.checksum_lock_path  = struct.lock_path.join('checksum.lock')  if package.checksum?
      struct.signature_lock_path = struct.lock_path.join('signature.lock') if package.signature?
      struct.build_lock_path     = struct.lock_path.join('build.lock')

      package.paths = struct

      struct
    end

  end
end


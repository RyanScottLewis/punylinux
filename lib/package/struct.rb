module Package
  class Struct

    Source = ::Struct.new(:url, :path)

    attr_reader :name

    def name=(value)
      @name = value.to_sym
    end

    attr_accessor :version
    attr_accessor :archive
    attr_accessor :checksum
    attr_accessor :signature
    attr_accessor :files

    def archive_basename
      File.basename(@archive_url)
    end

    def files?
      !!@files
    end

    def build_files
      @files.map { |path| paths.build_root.path.join(path.to_s.gsub(/^\//, '')) }
    end

    def checksum?
      !!@checksum
    end

    def external_checksum?
      checksum? && @checksum.start_with?('http')
    end

    def internal_checksum?
      !external_checksum?
    end

    def signature?
      !!@signature
    end

    attr_accessor :identifier

    attr_accessor :archive_url
    attr_accessor :archive_path

    attr_accessor :checksum_url
    attr_accessor :checksum_path

    attr_accessor :signature_url
    attr_accessor :signature_path

    attr_accessor :build_path

    attr_accessor :lock_path
    attr_accessor :checksum_lock_path
    attr_accessor :signature_lock_path
    attr_accessor :build_lock_path

    def sources
      sources = []

      sources << Source.new(archive_url,   archive_path)
      sources << Source.new(signature_url, signature_path) if signature?
      sources << Source.new(checksum_url,  checksum_path)  if external_checksum?

      sources
    end

    def source_paths
      sources.map(&:path)
    end

    attr_accessor :on_verify

    def on_verify?
      !!@on_verify
    end

    attr_accessor :on_build

    def on_build?
      !!@on_build
    end

    attr_accessor :on_package

    def on_package?
      !!@on_package
    end

  end
end


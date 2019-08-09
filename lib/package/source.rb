require 'uri'
require 'forwardable'
require 'path/struct'
require 'rake/file_utils'

module Package
  class Source

    extend Forwardable

    include FileUtils

    def initialize(value)
      @value   = value
      self.uri = value
    end

    attr_reader :value

    attr_reader :uri

    def uri=(value)
      @uri  = URI(value)
      @path = Path::Struct.new(path: @uri.path)

      @uri
    end

    attr_reader :path
    def_delegators :path, :basename

    def internal?
      @uri.class == URI::Generic
    end

    def file?
      @uri.is_a?(URI::File)
    end

    def external?
      !internal? && !file?
    end

  end
end


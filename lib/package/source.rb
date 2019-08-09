require 'uri'
require 'forwardable'
require 'path/struct'

module Package
  class Source

    extend Forwardable

    def initialize(value)
      self.uri = value
    end

    attr_reader :uri

    def uri=(value)
      @uri  = URI(value)
      @path = Path::Struct.new(path: @uri.path)

      @uri
    end

    attr_reader :path
    def_delegators :path, :basename

    def internal?
      @uri.is_a?(URI::Generic) || @uri.is_a?(URI::File)
    end

    def external?
      !internal?
    end

  end
end


require 'package/struct'

module Package
  class LoadResult

    def initialize(path, specification, error)
      @path          = path
      @specification = specification
      @error         = error
    end

    attr_reader :path
    attr_reader :specification
    attr_reader :error

    def success?
      !@error && @specification.success?
    end

    def failure?
      !success?
    end

    def to_struct
      Package::Struct.new(@specification.to_h)
    end

  end
end


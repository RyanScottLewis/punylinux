module Path
  # Wrapper for paths, very similar to Pathname only can have an optional name and lazily-defined
  # path values.
  # If the `path` is set to a Proc or a block is given in the `#initialize` method, then it will
  # set the `path` property to the value returned by calling the block on first `#path` invocation.
  class Struct

    def initialize(name: nil, path: nil, &block)
      raise ArgumentError, "Cannot pass both a path and a block" if block_given? && !path.nil?

      self.name = name                        unless name.nil?
      self.path = block_given? ? block : path unless !block_given? && path.nil?
    end

    attr_reader :name

    def name=(value)
      @name = value.to_sym
    end

    def path
      return nil        if @name.nil? && @path.nil?
      return @name.to_s if @path.nil?

      @path = @path.call if @path.is_a?(Proc)

      @path
    end
    alias_method :to_s,   :path
    alias_method :to_str, :to_s

    def path=(value)
      @path = value.to_s unless value.is_a?(Proc)

      @path
    end

    def open(mode=?r)
      File.open(path, mode) { |file| yield(file) }
    end

    def read
      open { |file| file.read }
    end

    def exist?
      File.exist?(path)
    end

    def extname
      File.extname(path)
    end

    def glob(pattern=nil)
      pattern = pattern.nil? ? path : join(pattern)

      Dir[pattern].map { |path| self.class.new(path: path) }
    end

    def join(*arguments)
      self.class.new(path: File.join(path, *arguments))
    end

    def expand_path(*arguments)
      self.class.new(path: File.expand_path(path, *arguments))
    end

    def basename
      self.class.new(path: File.basename(path))
    end

    def dirname
      self.class.new(path: File.dirname(path))
    end

    def sub_ext(ext)
      self.class.new(path: path.to_s.gsub(/#{extname}$/, ext))
    end

    def append_ext(ext)
      self.class.new(path: "#{path}#{ext}")
    end

    def to_dir
      self.class.new(path: "#{path}/")
    end

  end
end


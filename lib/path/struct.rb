module Path
  # Wrapper for paths, very similar to Pathname only can have an optional name and lazily-defined
  # path values.
  # If the `path` is set to a Proc or a block is given in the `#initialize` method, then it will
  # set the `path` property to the value returned by calling the block on first `#path` invocation.
  class Struct

    def initialize(name: nil, path: nil, description: nil, &block)
      raise ArgumentError, "Cannot pass both a path and a block" if block_given? && !path.nil?

      self.name        = name                       unless name.nil?
      self.path        = !block.nil? ? block : path unless block.nil? && path.nil?
      self.description = description
    end

    attr_reader :name

    def name=(value)
      @name = value.to_sym
    end

    attr_reader :description

    def description=(value)
      @description = value.to_s
    end

    def description?
      !!@description && !@description.empty? # TODO: Why the need to check for empty?
    end

    def path # TODO: This leads to things like `path.path` which makes me want to get stomped to death by baby elephants. Rename to something like `location`
      return nil if @name.nil? && @path.nil?

      @path = @path.call if @path.is_a?(Proc)
      return @name.to_s if @path.nil?

      @path
    end

    def value
      path.to_s
    end
    alias_method :to_s, :value
    alias_method :to_str, :to_s

    def path=(value)
      @path = value.is_a?(Proc) ? value : value.to_s

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

    # Take a glob pattern with alternations and explode into individual paths
    # Only handles a single set of alternations, i.e. `/foo/bar/{baz,qux}`
    def explode(pattern=nil)
      pattern = pattern.nil? ? path : join(pattern)
      match   = pattern.match(/{.+}/) # TODO: Scan and iterate to match multiple alternation sets

      return [self] unless match

      alternations = match.to_s.gsub(/^{|}$/, '').split(?,).map(&:strip)

      alternations.map do |alternation|
        pattern.dup.tap do |path|
          path[match.regexp] = alternation
        end
      end
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

  end
end


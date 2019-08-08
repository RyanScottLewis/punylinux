require 'forwardable'
require 'pathname'

module Path
  class Struct

    extend Forwardable

    def initialize(*arguments)
      arguments = arguments.flatten
      return if arguments.empty?
      raise ArgumentError, "expected 0..2 arguments" if arguments.length > 2

      case arguments.length
      when 1 then self.name            = arguments.first
      when 2 then self.name, self.path = arguments
      end
    end

    attr_accessor :name

    def path
      return Pathname(@name.to_s) if @path.nil?
      @path = @path.call if @path.is_a?(Proc)

      @path
    end
    alias_method :value, :path

    def path=(path)
      @path = Pathname(path.to_s)
    end

    def_delegators :path, :open, :read, :exist?, :glob, :extname, :to_s

    def join(*arguments)
      self.class.new path.join(*arguments)
    end

    def basename(*arguments)
      self.class.new path.basename(*arguments)
    end

    def dirname(*arguments)
      self.class.new path.dirname(*arguments)
    end

    def sub_ext(*arguments)
      self.class.new path.sub_ext(*arguments)
    end

    def append_ext(ext)
      sub_ext("#{extname}#{ext}")
    end

    def expand_path(*arguments)
      self.class.new path.expand_path(*arguments)
    end

    def to_str
      to_s
    end

    def to_dir
      "#{path}/"
    end

  end
end


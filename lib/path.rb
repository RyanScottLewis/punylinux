require 'path/list'
require 'path/struct'

module Path
  class << self

    def all
      @all ||= List.new
    end

    def define(*arguments, &block)
      all << Path::Struct.new(*arguments, &block)
    end

  end
end


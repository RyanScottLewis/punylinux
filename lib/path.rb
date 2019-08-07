require 'path/list'
require 'path/struct'

module Path
  class << self

    def all
      @all ||= List.new
    end

    def define(*arguments)
      all << Path::Struct.new(*arguments)
    end

  end
end


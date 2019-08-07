require 'package/dsl'
require 'package/list'

module Package
  class << self

    def all
      @all ||= List.new
    end

    def define(&block)
      all << DSL.call(&block)
    end

  end
end


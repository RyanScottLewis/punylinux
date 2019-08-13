require 'path'

module Helpers
  module Path

    def path(**attributes, &block)
      ::Path.define(**attributes, &block)
    end

    def paths
      ::Path.all
    end

  end

  include Path
end


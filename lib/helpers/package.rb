require 'package'

module Helpers
  module Package

    def packages
      ::Package.all
    end

  end

  include Package
end


require 'package'

def package(&block)
  Package.define(&block)
end

def packages
  Package.all
end


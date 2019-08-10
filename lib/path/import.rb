require 'path'

def Path(value)
  value.is_a?(Path::Struct) ? value : Path::Struct.new(value)
end

def path(**attributes, &block)
  Path.define(**attributes, &block)
end

def paths
  Path.all
end

def read(path)
  Path(path).read
end


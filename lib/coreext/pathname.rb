require 'pathname'

class Pathname

  def glob(pattern=nil)
    self.class.glob(pattern.nil? ? self : self.join(pattern))
  end

end


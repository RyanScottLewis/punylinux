require 'pathname'

class Pathname

  def glob
    self.class.glob(self)
  end

end


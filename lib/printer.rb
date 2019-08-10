class Printer

  def self.call(list, **keywords)
    new.call(list, **keywords)
  end

  def call
    raise NoMethodError
  end

end


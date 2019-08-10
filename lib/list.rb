class List < Array

  def find_by_name(name)
    find { |child| child.name == name }
  end

  def [](identifier)
    if identifier.is_a?(Integer)
      super
    else
      find_by_name(identifier)
    end
  end

  def respond_to_missing?(method, include_private)
    any? { |child| child.name == method }
  end

  def method_missing(method)
    find_by_name(method)
  end

  def names
    map(&:name)
  end

  def name_justification
    names.map(&:length).max
  end

end


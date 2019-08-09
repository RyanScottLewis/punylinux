require 'uri'
require 'dry/types'
require 'package/source'

module Package
  module Types

    include Dry::Types()

    Source      = Instance(Package::Source)
    Callback    = Instance(Proc)
    StringArray = Array.of(Coercible::String)

    Coercible::Source = Types::Constructor(Package::Source)

  end
end


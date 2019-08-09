require 'package/types'
require 'dry/schema'

module Package

  # Validation schema
  Specification = Dry::Schema.Params do
    required(:name).filled(Types::Coercible::Symbol)
    required(:version).filled(Types::Coercible::String)

    required(:archive).filled(Types::Coercible::Source)
    optional(:checksum).filled(Types::Coercible::Source)
    optional(:signature).filled(Types::Coercible::Source)

    optional(:files).filled(Types::StringArray)

    optional(:on_build).filled(Types::Callback)
    optional(:on_check).filled(Types::Callback)
    optional(:on_verify).filled(Types::Callback)
    optional(:on_package).filled(Types::Callback)
  end

end


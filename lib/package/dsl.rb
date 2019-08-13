require 'package/concerns/dsl_helpers'

module Package
  class DSL

    include DSLHelpers

    dsl_property :name
    dsl_property :version

    dsl_property :archive
    dsl_property :signature
    dsl_property :checksum

    dsl_property :files

    dsl_callback :on_verify
    dsl_callback :on_build
    dsl_callback :on_install

  end
end


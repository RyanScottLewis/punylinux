require 'package/types'
require 'dry/struct'

module Package
  class Struct < Dry::Struct

    def self.attribute?(name, type)
      super

      define_method("#{name}?") do
        !!instance_variable_get("@#{name}")
      end
    end

    def initialize(*arguments)
      super

      @identifier = [@name, @version].join(?-)
    end

    attribute  :name,       Types::Symbol
    attribute  :version,    Types::String

    attribute  :archive,    Types::Source
    attribute? :checksum,   Types::Source
    attribute? :signature,  Types::Source

    attribute? :files,      Types::StringArray

    attribute? :on_build,   Types::Callback
    attribute? :on_check,   Types::Callback
    attribute? :on_verify,  Types::Callback
    attribute? :on_package, Types::Callback

    attr_reader :identifier

  end
end


require 'dry/struct'
require 'package/types'
require 'package/path_resolver'
require 'path'

module Package
  class Struct < Dry::Struct

    def self.attribute?(name, type)
      super

      define_method("#{name}?") do
        !send("#{name}").nil?
      end
    end

    def self.paths_delegate(name)
      define_method(name) do
        return nil unless @paths

        @paths.send(name)
      end

      define_method("#{name}=") do |value|
        return nil unless @paths

        @paths.send("#{name}=", value)
      end
    end

    def initialize(*arguments)
      super

      @identifier = [name, version].join(?-)
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

    attr_accessor :paths

    paths_delegate :archive_path
    paths_delegate :checksum_path
    paths_delegate :signature_path
    paths_delegate :build_path
    paths_delegate :lock_path
    paths_delegate :checksum_lock_path
    paths_delegate :signature_lock_path
    paths_delegate :build_lock_path

    paths_delegate :install_files

  end
end


require 'pathname'
require 'package/struct'

module Package
  class DSL

    def self.dsl_property(name)
      define_method(name) do |*arguments|
        raise ArgumentError, "argument length must be 0..1 (got #{arguments.length})" unless arguments.length <= 1

        arguments.length == 1 ? @package.send("#{name}=", arguments.first) : @package.send(name)
      end
    end

    def self.dsl_callback(name)
      define_method(name) do |&block|
        if block.nil?
          @package.send(name)
        else
          @package.send("#{name}=", block)
        end
      end
    end

    def self.call(package=Struct.new, &block)
      new(package).call(&block)
    end

    def initialize(package)
      @package = package
    end

    def call(&block)
      instance_eval(&block)

      @package
    end

    dsl_property :name
    dsl_property :version
    dsl_property :archive
    dsl_property :signature
    dsl_property :checksum
    dsl_property :files

    dsl_callback :on_verify
    dsl_callback :on_build
    dsl_callback :on_package

  end
end


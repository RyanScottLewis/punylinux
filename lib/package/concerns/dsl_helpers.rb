require 'package/struct'

module Package
  module DSLHelpers

    module ClassMethods

      def dsl_property(name)
        define_method(name) do |*arguments|
          raise ArgumentError, "argument length must be 0..1 (got #{arguments.length})" unless arguments.length <= 1

          arguments.length == 1 ? @package.send("#{name}=", arguments.first) : @package.send(name)
        end
      end

      def dsl_callback(name)
        define_method(name) do |&block|
          if block.nil?
            @package.send(name)
          else
            @package.send("#{name}=", block)
          end
        end
      end

      def call(package=Struct.new, &block)
        new(package).call(&block)
      end

    end

    module InstanceMethods

      def initialize(package)
        @package = package
      end

      def call(&block)
        instance_eval(&block)

        @package
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

  end
end


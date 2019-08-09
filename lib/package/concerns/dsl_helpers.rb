module Package
  module DSLHelpers

    module ClassMethods

      def dsl_property(name)
        define_method(name) do |value=nil|
          value.nil? ? @attributes[name] : @attributes[name] = value
        end
      end

      def dsl_callback(name)
        define_method(name) do |&block|
          return @attributes[name] if block.nil?

          @attributes[name] = block
        end
      end

      def call(&block)
        new.call(&block)
      end

      def load(path)
        new.load(path)
      end

    end

    module InstanceMethods

      def initialize
        @attributes = {}
      end

      def call(&block)
        update do
          instance_eval(&block)
        end
      end

      def load(path)
        update do
          instance_eval(File.read(path), path)
        end
      end

      protected

      def update
        @attributes.clear
        yield
        attributes = @attributes.dup
        @attributes.clear

        attributes
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
      base.include(InstanceMethods)
    end

  end
end


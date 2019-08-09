module Package
  class LoadResults < Array

    def specifications
      select { |result| !!result.specification }.map(&:specification)
    end

    def successes
      select(&:success?)
    end

    def failures
      select(&:failure?)
    end

    def has_failures?
      any?(&:failure?)
    end

    def error_messages
      failures.map.with_object([]) do |result, messages|
        error = if result.error
          result.error.to_s
        elsif !!result.specification && result.specification.failure?
          result.specification.errors(full: true).messages.join(', ')
        end

        messages << "%s: %s" % [result.path, error] if error
      end.join("\n")
    end

    def to_structs
      successes.map(&:to_struct)
    end

  end
end


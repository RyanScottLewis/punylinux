module Helpers
  module Configuration

    # Update a Linux/Busybox style configuration file
    def update_config(path, attributes={})
      # Read configuration file as lines
      lines = path.read.lines

      # Delete lines containing custom attribute keys
      lines.delete_if do |line|
        attributes.keys.any? do |key|
          line.include?(key)
        end
      end

      # Add lines for custom attributes
      attributes.each do |key, value|
        lines << [key, value].join(?=)
      end

      # Write configuration file
      path.overwrite(lines.join("\n"))
    end

  end

  include Configuration
end


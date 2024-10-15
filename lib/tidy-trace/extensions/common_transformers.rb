require_relative "builder_extension"

module TidyTrace
  module Extensions
    module CommonTransformers
      extend BuilderExtension

      # Transforms an absolute path to the system's gem directory to a path starting with `gems`.
      # @return [self]
      def transform_replace_prefix(prefix, replacement: "")
        offset = prefix.length
        transform_with do |line|
          if line.start_with?(prefix)
            replacement + line[offset..]
          else
            line
          end
        end
      end

      # Transforms backtrace lines to remove the line number and method name at the end of each line
      def transform_remove_line_number_and_method
        transform_with do |line|
          line.gsub(/:\d+:in `.*'$/, '')
        end
      end
    end
  end
end
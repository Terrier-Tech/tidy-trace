require_relative "builder_extension"

module TidyTrace
  module Extensions
    module CommonTransformers
      extend BuilderExtension

      # Transforms an absolute path to the system's gem directory to a path starting with `gems`.
      # @param prefix [String] the prefix to replace in the trace line
      # @param replacement [String] the string to insert in place of the given prefix
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

      # Replaces the given text with the given replacement
      # @param string [String] the text to replace in the trace line
      # @param replacement [String] the string to insert in place of the given text
      # @return [self]
      def transform_replace(string, replacement: "")
        transform_with { |line| line.gsub(string, replacement) }
      end

      # Transforms backtrace lines to remove the line number and method name at the end of each line
      # @return [self]
      def transform_remove_line_number_and_method
        transform_with do |line|
          line.gsub(/:\d+:in `.*'$/, '')
        end
      end
    end
  end
end
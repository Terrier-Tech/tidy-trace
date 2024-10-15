require_relative "builder_extension"
module TidyTrace
  module Extensions
    module CommonTruncators
      extend BuilderExtension

      # Truncates the backtrace to the last line that has the given prefix.
      # @param prefix [String] the prefix after which to truncate at.
      # @return [self]
      def truncate_prefix(prefix)
        truncate_with do |line|
          line.start_with?(prefix)
        end
      end

      # Truncates the backtrace to the last line that does not have the given prefix.
      # @param prefix [String] the prefix after which to truncate at.
      # @return [self]
      def truncate_not_prefix(prefix)
        truncate_with do |line|
          !line.start_with?(prefix)
        end
      end
    end
  end
end
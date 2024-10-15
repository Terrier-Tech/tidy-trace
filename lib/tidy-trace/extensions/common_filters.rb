require_relative "builder_extension"
module TidyTrace
  module Extensions
    module CommonFilters
      extend BuilderExtension

      # Filters to only lines that contain a given string
      # @param string [String] the string to filter by
      # @return [self]
      def filter_contains(string)
        filter_with do |line|
          line.include?(string)
        end
      end

      # Filters to only lines that match a given regex
      # @param regex [Regexp] the regex to filter by
      # @return [self]
      def filter_matches(regex)
        filter_with do |line|
          regex.match?(line)
        end
      end

      # Filters to only lines that start with a given prefix
      # @param prefix [String] the prefix to filter by
      # @return [self]
      def filter_prefix(prefix)
        filter_with do |line|
          line.start_with?(prefix)
        end
      end

      # Rejects lines that contain a given string
      # @param string [String] the string to reject by
      # @return [self]
      def reject_contains(string)
        filter_with do |line|
          !line.include?(string)
        end
      end

      # Rejects lines that match a given regex
      # @param regex [Regexp] the regex to reject by
      # @return [self]
      def reject_matches(regex)
        filter_with do |line|
          !regex.match?(line)
        end
      end

      # Rejects lines that start with a given prefix
      # @param prefix [String] the prefix to reject by
      # @return [self]
      def reject_prefix(prefix)
        filter_with do |line|
          !line.start_with?(prefix)
        end
      end
    end
  end
end
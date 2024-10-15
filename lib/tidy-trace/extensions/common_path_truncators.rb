require_relative "builder_extension"
require_relative "common_truncators"

module TidyTrace
  module Extensions
    module CommonPathTruncators
      extend BuilderExtension
      include CommonTruncators

      # Truncates the backtrace to the last line in the current project.
      # @param path_root [String] the root path of the project
      # @return [self]
      def truncate_project_path(path_root: Dir.pwd)
        truncate_prefix(path_root)
      end

      # Truncates the backtrace to the last line that is not in the project bin path.
      # @param path_root [String] the root path of the project
      # @return [self]
      def truncate_not_bin_path(path_root: Dir.pwd)
        bin_path = (path_root + "/bin/").freeze
        truncate_not_prefix(bin_path)
      end

      # Truncates the backtrace to the last line that is not a project middleware.
      # @param path_root [String] the root path of the project
      # @return [self]
      def truncate_not_local_rails_middleware_path(path_root: Dir.pwd)
        middleware_path = (path_root + "/lib/middleware/").freeze
        truncate_not_prefix(middleware_path)
      end
    end
  end
end
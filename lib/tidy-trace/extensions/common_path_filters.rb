require_relative "builder_extension"
require_relative "common_filters"

module TidyTrace
  module Extensions
    module CommonPathFilters
      extend BuilderExtension
      include CommonFilters

      # Rejects lines that start with the system's gem directory.
      # @return [self]
      def reject_gem_paths
        gems_path = Gem.paths.home.dup.freeze
        reject_prefix(gems_path)
      end

      # Filters to only lines within the current project.
      # @return [self]
      def filter_project_paths
        project_path = (Dir.pwd + "/").freeze
        filter_prefix(project_path)
      end
    end
  end
end
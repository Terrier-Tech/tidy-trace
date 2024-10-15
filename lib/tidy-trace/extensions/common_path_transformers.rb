require_relative "builder_extension"
require_relative "common_transformers"

module TidyTrace
  module Extensions
    module CommonPathTransformers
      extend BuilderExtension
      include CommonTransformers

      # Transforms an absolute path to the system's gem directory to a path starting with `gems`.
      # @return [self]
      def transform_gem_paths(gem_root: Gem.paths.home, replacement: '')
        gems_path = (gem_root + "/").freeze
        transform_replace_prefix(gems_path, replacement:)
      end

      # Transforms absolute paths within the current project to relative paths.
      # @return [self]
      def transform_project_paths(path_root: Dir.pwd, replacement: './')
        project_path = (path_root + "/").freeze
        transform_replace_prefix(project_path, replacement:)
      end

      # Transforms absolute paths to the user's home directory to use the `~` alias.
      # @return [self]
      def transform_home_paths(home_root: Dir.home, replacement: '~/')
        home_dir = (home_root + "/").freeze
        transform_replace_prefix(home_dir, replacement:)
      end
    end
  end
end
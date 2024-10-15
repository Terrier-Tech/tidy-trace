require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"
require "tidy-trace/builder"
require "tidy-trace/extensions/common_path_transformers"

describe TidyTrace::Extensions::CommonPathTransformers do
  describe :transform_gem_paths do
    it "should remove the path to the gems directory" do
      backtrace = %W[
        #{Gem.default_dir}/gems/a-gem/lib/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .transform_gem_paths
        .build

      actual = tidier.transform(backtrace)

      expected = %w[
        gems/a-gem/lib/file.rb
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end

    it "should replace the gem path with a custom replacement" do
      backtrace = %W[
        #{Gem.default_dir}/gems/a-gem/lib/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .transform_gem_paths(replacement: 'custom_prefix:')
        .build

      actual = tidier.transform(backtrace)

      expected = %w[
        custom_prefix:gems/a-gem/lib/file.rb
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end
  end

  describe :transform_project_paths do
    it "should replace the path to the current project with ./" do
      backtrace = %W[
        #{Dir.pwd}/lib/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .transform_project_paths
        .build

      actual = tidier.transform(backtrace)

      expected = %w[
        ./lib/file.rb
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end
  end

  describe :transform_home_paths do
    it "should replace the path to the user's home directory with ~/" do
      backtrace = %W[
        #{Dir.home}/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .transform_home_paths
        .build

      actual = tidier.transform(backtrace)

      expected = %w[
        ~/file.rb
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end
  end
end
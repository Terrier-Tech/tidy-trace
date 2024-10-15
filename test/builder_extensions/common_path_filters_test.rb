require "minitest/spec"
require "minitest/autorun"
require 'tidy-trace/tidier'
require 'tidy-trace/builder'
require "tidy-trace/extensions/common_path_filters"

describe TidyTrace::Extensions::CommonPathFilters do
  describe :reject_gem_paths do
    it "should reject lines that start with the system's gem directory" do
      backtrace = %W[
        #{Gem.default_dir}/gems/a-gem/lib/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .reject_gem_paths
        .build

      actual = tidier.filter(backtrace)

      expected = %w[
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end
  end

  describe :filter_project_paths do
    it "should filter to only lines within the current project" do
      backtrace = %W[
        #{Dir.pwd}/lib/file.rb
        /path/to/file.rb
      ]

      tidier = TidyTrace::Builder.new
        .filter_project_paths
        .build

      actual = tidier.filter(backtrace)

      expected = %W[
        #{Dir.pwd}/lib/file.rb
      ]

      assert_equal expected, actual
    end
  end
end
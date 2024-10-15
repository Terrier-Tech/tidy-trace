require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"
require "tidy-trace/builder"
require "tidy-trace/extensions/common_path_truncators"

describe TidyTrace::Extensions::CommonPathTruncators do
  describe :truncate_bin_path do
    it "should truncate the backtrace to lines before the bin directory" do
      backtrace = %W[
        /path/to/file.rb
        #{Dir.pwd}/bin/rake
      ]

      tidier = TidyTrace::Builder.new
        .truncate_bin_path
        .build

      actual = tidier.truncate(backtrace)

      expected = %w[/path/to/file.rb]

      assert_equal expected, actual
    end
  end

  describe :truncate_local_rails_middleware_path do
    it "should truncate backtrace to lines before the middleware directory" do
      backtrace = %W[
        /path/to/file.rb
        #{Dir.pwd}/lib/middleware/some_middleware.rb
      ]

      tidier = TidyTrace::Builder.new
        .truncate_local_rails_middleware_path
        .build

      actual = tidier.truncate(backtrace)

      expected = %w[/path/to/file.rb]

      assert_equal expected, actual
    end
  end
end
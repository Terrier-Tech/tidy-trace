require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"
require "tidy-trace/builder"
require "tidy-trace/extensions/common_transformers"

describe TidyTrace::Extensions::CommonTransformers do
  describe :transform_remove_line_number_and_method do
    it "should remove the line number and method name from each backtrace line" do
      backtrace = [
        "/path/to/file.rb:2:in `stuff'",
        "/path/to/another/file.rb:385:in `block (1 levels) in run'",
        "/path/to/file.rb:25:in `run'",
      ]

      tidier = TidyTrace::Builder.new
        .transform_remove_line_number_and_method
        .build

      actual = tidier.transform(backtrace)

      expected = %w[
        /path/to/file.rb
        /path/to/another/file.rb
        /path/to/file.rb
      ]

      assert_equal expected, actual
    end
  end
end


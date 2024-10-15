require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"

describe TidyTrace::Tidier, :transform do
  it "should apply transformer" do
    backtrace = %w[/path/to/file.rb /path/to/another/file.rb]

    tidier = TidyTrace::Tidier.new(transformers: [
      ->(line) { line.upcase },
    ])

    actual = tidier.transform(backtrace)

    expected = %w[
      /PATH/TO/FILE.RB
      /PATH/TO/ANOTHER/FILE.RB
    ]

    assert_equal expected, actual
  end

  it "sequential transformers should apply in order" do
    backtrace = %w[/path/to/file.rb /path/to/another/file.rb]

    tidier = TidyTrace::Tidier.new(transformers: [
      ->(line) { line.gsub('/', '_') },
      ->(line) { line.upcase },
    ])

    actual = tidier.transform(backtrace)

    expected = %w[
      _PATH_TO_FILE.RB
      _PATH_TO_ANOTHER_FILE.RB
    ]

    assert_equal expected, actual
  end
end

def get_current_caller
  caller
end
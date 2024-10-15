require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"

describe TidyTrace::Tidier, :tidy do
  it "should apply all tidy stages" do
    backtrace = %w[
      /path/one/file.rb
      /path/one/file_2.rb
      /path/two/file.rb
      /path/two/file_2.rb
      /path/three/file.rb
    ]

    tidier = TidyTrace::Tidier.new(
      truncators: [->(line) { line.include?("/path/two") }],
      filters: [->(line) { line.include?("file.rb") }],
      transformers: [->(line) { line.upcase }],
    )

    actual = tidier.tidy(backtrace)

    expected = %w[
      /PATH/ONE/FILE.RB
      /PATH/TWO/FILE.RB
    ]

    assert_equal expected, actual
  end

  it "should truncate before filtering" do
    # if filters happen first, the trace won't be truncated because the truncator won't find any lines
    backtrace = %w[
      /path/to/file.rb
      /path/to/another/file.rb
      /reject/this/truncate_here.rb
      /path/to/a_third/file.rb
    ]

    tidier = TidyTrace::Tidier.new(
      truncators: [->(line) { line.include?("truncate_here") }],
      filters: [->(line) { !line.include?("reject") }],
    )

    actual = tidier.tidy(backtrace)

    expected = %w[
      /path/to/file.rb
      /path/to/another/file.rb
    ]

    assert_equal expected, actual
  end
end
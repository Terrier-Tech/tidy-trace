require "minitest/spec"
require "minitest/autorun"
require 'tidy-trace/tidier'
require 'tidy-trace/builder'

describe TidyTrace::Builder, :filter_any do
  it 'should add a filter that matches if any of the given filters match' do
    backtrace = %w[
      /path/one/file.rb
      /path/two/file.rb
      /path/three/file.rb
    ]

    tidier = TidyTrace::Builder.new
      .filter_any { |any|
        any
          .filter_with { |line| line.include?("one") }
          .filter_with { |line| line.include?("two") }
      }
      .build

    actual = tidier.filter(backtrace)

    expected = %w[
      /path/one/file.rb
      /path/two/file.rb
    ]

    assert_equal expected, actual
  end

  it 'should combine with non-any filters' do
    backtrace = %w[
      /path/one/file.rb
      /path/two/file.rb
      /reject/two/file.rb
    ]

    tidier = TidyTrace::Builder.new
      .filter_any { |any|
        any
          .filter_with { |line| line.include?("one") }
          .filter_with { |line| line.include?("two") }
      }
      .filter_with { |line| !line.include?("reject") }
      .build

    actual = tidier.filter(backtrace)

    expected = %w[
      /path/one/file.rb
      /path/two/file.rb
    ]

    assert_equal expected, actual
  end
end
require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"

describe TidyTrace::Tidier, :filter do
  it "should keep lines that match the filter" do
    backtrace = %w[does/not/match does/match]

    tidier = TidyTrace::Tidier.new(filters: [
      ->(line) { line == "does/match" }
    ])

    actual = tidier.filter(backtrace)

    expected = %w[does/match]

    assert_equal expected, actual
  end

  it "should keep lines that match every filter" do
    backtrace = %w[does/not/match.rb matches/filter_1.rb matches/filter_2.rb matches/filter_1/filter_2.rb]

    tidier = TidyTrace::Tidier.new(filters: [
      ->(line) { line.include?("filter_1") },
      ->(line) { line.include?("filter_2") },
    ])

    actual = tidier.filter(backtrace)

    expected = %w[matches/filter_1/filter_2.rb]

    assert_equal expected, actual
  end
end
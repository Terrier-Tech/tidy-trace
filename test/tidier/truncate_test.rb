require "minitest/spec"
require "minitest/autorun"
require "tidy-trace/tidier"

describe TidyTrace::Tidier, :truncate do
  it 'should return backtrace truncated to first line that matches truncator' do
    backtrace = %w[
      /path/matches/file.rb
      /path/does/not/match/file.rb
      /path/matches/file_2.rb
      /path/does/not/match/file_2.rb
    ]

    tidier = TidyTrace::Tidier.new(truncators: [
      ->(line) { line.include?("matches") }
    ])

    actual = tidier.truncate(backtrace)

    expected = %w[
      /path/matches/file.rb
      /path/does/not/match/file.rb
      /path/matches/file_2.rb
    ]

    assert_equal expected, actual
  end

  it 'should return backtrace truncated to first line that matches a truncator' do
    backtrace = %w[
      /path/matches/file.rb
      /path/does/not/match/file.rb
      /path/matches/file_2.rb
      /path/does/not/match/file_2.rb
    ]

    tidier = TidyTrace::Tidier.new(truncators: [
      ->(line) { line.include?("file.rb") },
      ->(line) { line.include?("matches") },
    ])

    actual = tidier.truncate(backtrace)

    expected = %w[
      /path/matches/file.rb
      /path/does/not/match/file.rb
    ]

    assert_equal expected, actual
  end

  it "should return full backtrace if truncator doesn't match" do
    backtrace = %w[
      /path/does/not/match/file.rb
      /path/does/not/match/file_2.rb
    ]

    tidier = TidyTrace::Tidier.new(truncators: [
      ->(line) { line.include?("matches") }
    ])

    actual = tidier.truncate(backtrace)

    expected = %w[
      /path/does/not/match/file.rb
      /path/does/not/match/file_2.rb
    ]

    assert_equal expected, actual
  end
end
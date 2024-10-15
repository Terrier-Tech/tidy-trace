require "minitest/spec"
require "minitest/autorun"
require 'tidy-trace/tidier'
require 'tidy-trace/builder'

describe TidyTrace::Builder, :build do
  it "should build a Tidier with the given transformer" do
    builder = TidyTrace::Builder.new
    builder.instance_variable_get(:@transformers) << ->(line) { line.upcase }
    tidier = builder.build

    assert_equal "TEST", tidier.instance_variable_get(:@transformers).first.call("test")
  end

  it "should build a Tidier with the given filter" do
    builder = TidyTrace::Builder.new
    builder.instance_variable_get(:@filters) << ->(line) { line == "test" }
    tidier = builder.build

    assert tidier.instance_variable_get(:@filters).first.call("test")
  end

  it "should build a Tidier with the given truncator" do
    builder = TidyTrace::Builder.new
    builder.instance_variable_get(:@truncators) << ->(line) { line == "test" }
    tidier = builder.build

    assert tidier.instance_variable_get(:@truncators).first.call("test")
  end
end
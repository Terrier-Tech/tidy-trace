require_relative "lib/tidy-trace/version"

Gem::Specification.new do |spec|
  spec.name = "tidy-trace"
  spec.version = TidyTrace::VERSION
  spec.authors = ["Cole Schultz"]
  spec.email = ["cole@terrier.tech"]

  spec.summary = "A configurable utility for tidying ruby backtraces"
  spec.description = <<~DESC
    A utility for tidying up ruby backtraces by transforming, filtering, and truncating backtrace lines.
    Easily configurable using a builder pattern interface.
  DESC
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"]

  spec.required_ruby_version = ">= 3.1.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
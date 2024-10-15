require_relative 'tidy-trace/tidier'
require_relative 'tidy-trace/builder'

module TidyTrace
  # A Tidier with the global default configuration
  def self.default
    @default ||= Tidier.new
  end

  # Set the global default Tidier
  def self.default=(tidier)
    @default = tidier
  end

  # Build the global default Tidier using a block
  def self.configure_default
    builder = Builder.new
    yield builder
    self.default = builder.build
  end
end
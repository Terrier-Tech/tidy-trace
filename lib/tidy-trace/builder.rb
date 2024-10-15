module TidyTrace
  class Builder

    attr_reader :filters
    attr_reader :truncators

    protected :filters, :truncators

    def initialize
      @truncators = []
      @filters = []
      @transformers = []
    end

    # Add a truncator to the configuration
    def truncate_with(&block)
      @truncators << block
      self
    end

    # Add a truncator that succeeds if any of the given truncators succeed
    def truncate_any
      or_builder = Builder.new
      yield or_builder
      or_truncators = or_builder.truncators.dup
      truncate_with do |line|
        or_truncators.any? { |truncator| truncator.call(line) }
      end
    end

    # Add a truncator that succeeds if all of the given truncators succeed
    def truncate_all
      and_builder = Builder.new
      yield and_builder
      and_truncators = and_builder.truncators.dup
      truncate_with do |line|
        and_truncators.all? { |truncator| truncator.call(line) }
      end
    end

    # Add a filter to the configuration
    def filter_with(&block)
      @filters << block
      self
    end

    # Add a filter that succeeds if any of the given filters succeed
    def filter_any
      or_builder = Builder.new
      yield or_builder
      or_filters = or_builder.filters.dup
      filter_with do |line|
        or_filters.any? { |filter| filter.call(line) }
      end
    end

    # Add a transformer to the configuration
    def transform_with(&block)
      @transformers << block
      self
    end

    # Construct the final Tidier based on the built configuration
    def build
      Tidier.new(
        truncators: @truncators,
        filters: @filters,
        transformers: @transformers,
      )
    end
  end
end
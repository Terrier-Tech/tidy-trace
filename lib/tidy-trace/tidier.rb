module TidyTrace
  class Tidier
    def initialize(transformers: [], filters: [], truncators: [])
      @truncators = truncators || []
      @filters = filters || []
      @transformers = transformers || []
    end

    # Perform the full tidy pipeline on a given backtrace.
    # @param backtrace [Array<String>] the backtrace to tidy
    # @return [Array<String>] the tidied backtrace
    def tidy(backtrace)
      truncated = truncate(backtrace)
      filtered = filter(truncated)
      transform(filtered)
    end

    # Perform the configured truncations on a given backtrace
    # @param backtrace [Array<String>] the backtrace to truncate
    # @return [Array<String>] the truncated backtrace
    def truncate(backtrace)
      @truncators.each do |truncator|
        index = backtrace.rindex { |line| truncator.call(line) }
        return backtrace[0..index] if index
      end
      backtrace
    end

    # Perform the configured filters on a given backtrace
    # @param backtrace [Array<String>] the backtrace to filter
    # @return [Array<String>] the filtered backtrace
    def filter(backtrace)
      return backtrace if @filters.empty?
      backtrace.filter do |line|
        @filters.all? { |filter| filter.call(line) }
      end
    end

    # Perform the configured transformations on a given backtrace
    # @param backtrace [Array<String>] the backtrace to transform
    # @return [Array<String>] the transformed backtrace
    def transform(backtrace)
      return backtrace if @transformers.empty?
      backtrace.map do |line|
        @transformers.reduce(line) do |transformed, transformer|
          transformer.call(transformed)
        end
      end
    end
  end
end
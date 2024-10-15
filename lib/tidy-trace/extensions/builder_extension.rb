require_relative '../builder'

module TidyTrace
  module Extensions
    module BuilderExtension
      def self.extended(base)
        TidyTrace::Builder.include(base)
      end
    end
  end
end
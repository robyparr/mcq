module Support
  module Helpers
    module CapybaraHelper
      def wait_until
        raise ArgumentError, 'wait_until requires a block' unless block_given?

        loop do
          block_result = yield

          break if block_result
          sleep 0.1
        end
      end

      def find_by_testid(testid)
        find("[data-testid='#{testid}'")
      end
    end
  end
end

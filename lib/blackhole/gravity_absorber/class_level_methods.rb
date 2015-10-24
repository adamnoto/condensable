module Blackhole
  module GravityAbsorber
    module ClassLevelMethods
      module_function

      # configuration block
      def blackhole options
        if options[:default]
          Blackhole::DEFAULT_VALUES[self.to_s] = options[:default]
        end
      end
    end
  end
end

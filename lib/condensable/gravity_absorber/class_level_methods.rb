module Condensable
  module GravityAbsorber
    module ClassLevelMethods
      module_function

      # configuration block
      def condensable options
        if options[:default]
          Condensable::DEFAULT_VALUES[self.to_s] = options[:default]
        end
      end
    end
  end
end

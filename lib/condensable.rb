require "condensable/version"
require "condensable/gravity_absorber"
require "condensable/gravity_absorber/class_level_methods"

module Condensable
  # map class with default values
  DEFAULT_VALUES = {}

  def self.included(base)
    base.include(Condensable::GravityAbsorber)
    base.extend(Condensable::GravityAbsorber::ClassLevelMethods)
  end

  def self.new(*args, &block)
    # make class on the fly, on the fly
    klass = Class.new do
      include Condensable
    end

    # initialize if args are specified
    args.each do |arg|
      if arg.is_a?(Hash)
        default_value = arg[:default] || arg['default']
        if default_value
          klass.class_eval do 
            condensable default: default_value
          end
        end
      end
    end

    # if block is given, execute the block
    if block_given?
      klass.class_eval(&block)
    end

    klass
  end
end

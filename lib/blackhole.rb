require "blackhole/version"
require "blackhole/gravity_absorber"
require "blackhole/gravity_absorber/class_level_methods"

module Blackhole
  # map class with default values
  DEFAULT_VALUES = {}

  def self.included(base)
    base.include(Blackhole::GravityAbsorber)
    base.extend(Blackhole::GravityAbsorber::ClassLevelMethods)
  end
end
